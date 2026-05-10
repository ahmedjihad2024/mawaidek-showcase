import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mawadk/app/dependency_injection.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/app/user_messages.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/usecase/booking_create_usecase.dart';
import 'package:mawadk/domain/usecase/payment_status_usecase.dart';
import 'package:mawadk/presentation/common/utils/overlay_loading.dart';
import 'package:mawadk/presentation/common/utils/snackbar_helper.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/confirm_booking/payment_resume_dialog.dart';
import 'package:sadad_qa_payments/sadad_qa_payments.dart';

/// Orchestrates the four-step online-payment flow from the confirm-
/// booking screen:
///
///   1. POST /bookings with payment_method=online + Idempotency-Key.
///      Backend creates the booking pending + mints a Sadad SDK token.
///   2. Push the Sadad PaymentScreen widget with the returned token,
///      order id, and (backend-computed) amount + customer info. The
///      mobile NEVER decides the amount — that is read straight off the
///      payment block the backend returned.
///   3. After the SDK pops, parse its result. The SDK returns "3" for
///      success and "2" for failure as a numeric string. We do not
///      trust this alone — see step 4.
///   4. Belt-and-braces: GET /payments/{id}/status. Backend will live-
///      verify with Sadad if the webhook hasn't arrived yet, so we never
///      mark a booking as paid based on a tampered SDK return.
///
/// The runner is a plain class (not a Widget / Bloc / Stateful) so the
/// confirm-booking view can call it from its onTap and await the final
/// result without juggling extra state.
///
/// `run()` and `resume()` both return a [PaymentRunnerResult] so the
/// caller can decide where to send the user next. The runner does NOT
/// navigate on its own (apart from presenting the Sadad sheet) — that
/// is the caller's job because each entry point has different ideas
/// about "where home is."

/// Final state of a payment-runner invocation. The caller maps each
/// outcome to a navigation decision; the runner stays UI-agnostic.
enum PaymentRunnerOutcome {
  /// Booking confirmed + payment captured. Caller should land the user
  /// on the success screen / home, refresh booking lists.
  success,

  /// User explicitly cancelled at the resume dialog. Slot already
  /// released. Caller should send the user to the booking-detail screen
  /// for the cancelled booking so they see the system explanation.
  cancelled,

  /// User backed out without confirming (tapped outside, killed app,
  /// etc.). Booking remains pending; the 15-min cron will reconcile.
  /// Caller should land the user on Home / their bookings list.
  dismissed,

  /// Backend confirmed the payment failed. Slot released. Caller
  /// should land the user on the booking-detail screen so they see the
  /// failure banner and can decide next step.
  failed,

  /// Backend says the transaction is still being verified — webhook
  /// hasn't landed but a cron will reconcile. Caller should land on
  /// the booking-detail screen with the soft "we're confirming" copy.
  pendingVerify,

  /// Could not initiate or resume the payment session (gateway down,
  /// network down, expired session). Caller should keep the user on
  /// the current screen so they can retry.
  gatewayUnavailable,

  /// The /bookings POST itself failed (validation, network, server).
  /// Caller should keep the user on the confirm-booking screen.
  bookingCreateFailed,
}

class PaymentRunnerResult {
  final PaymentRunnerOutcome outcome;

  /// The booking that was created (or, in `resume()`, the booking that
  /// was being resumed). null when we never got past the create step.
  final int? bookingId;

  const PaymentRunnerResult(this.outcome, {this.bookingId});
}

class SadadPaymentRunner {
  final BuildContext context;
  final int providerId;
  final int? providerDoctorId;
  final DateTime date;
  final String time; // hh:mm a from the slot picker
  final BookingPeriod period;
  final String doctorName;

  /// Called when the entire flow has completed successfully — booking
  /// confirmed, payment captured. The view passes its existing
  /// "navigate back to services" callback.
  final VoidCallback onSuccess;

  SadadPaymentRunner({
    required this.context,
    required this.providerId,
    required this.providerDoctorId,
    required this.date,
    required this.time,
    required this.period,
    required this.doctorName,
    required this.onSuccess,
  });

  /// New-booking entry point — creates the booking + initiates payment +
  /// hands off to the SDK loop. Returns the final outcome so the caller
  /// can decide where to navigate.
  Future<PaymentRunnerResult> run() async {
    // Convert "hh:mm a" -> "HH:mm" for the booking endpoint, mirroring
    // the cash-flow path in ConfirmBookingBloc.
    final parsedTime = DateFormat('hh:mm a', 'en').parse(time.trim());
    final time24 = DateFormat('HH:mm', 'en').format(parsedTime);

    OverlayLoading.instance.show();
    final createResult = await instance<BookingCreateUseCase>().execute(
      BookingCreateRequest(
        providerId: providerId,
        providerDoctorId: providerDoctorId,
        date: date,
        time: time24,
        period: period,
        paymentMethod: PaymentMethod.online,
        idempotencyKey: _newIdempotencyKey(),
      ),
    );
    OverlayLoading.instance.hide();

    BookingCreatePayment? payment;
    int? createdBookingId;
    createResult.fold(
      (failure) {
        SnackbarHelper.showMessage(failure.userMessage, ErrorMessage.snackBar);
      },
      (response) {
        payment = response.payment;
        // BookingCreateResponse exposes `bookingId` separately so we don't
        // have to fully parse the embedded booking object — that parse
        // was failing on decimal fields the backend returns as int
        // defaults (lat/lng=0, discount_percentage=0), throwing
        //   "type 'int' is not a subtype of type 'String?' in type cast"
        // mid-confirm. We only need the id for cancel/fail deep-links;
        // the booking-details screen refetches everything else.
        createdBookingId = response.bookingId;
      },
    );
    if (payment == null) {
      return const PaymentRunnerResult(PaymentRunnerOutcome.bookingCreateFailed);
    }
    if (!payment!.isReady) {
      SnackbarHelper.showMessage(
        Translation.payment_gateway_unavailable.tr,
        ErrorMessage.snackBar,
      );
      return PaymentRunnerResult(
        PaymentRunnerOutcome.gatewayUnavailable,
        bookingId: createdBookingId,
      );
    }

    return _runSdkLoop(payment!, createdBookingId);
  }

  /// Resume entry point — looks up the half-finished payment for an
  /// existing booking and jumps straight into the SDK loop. Used by the
  /// "Continue Payment" button on the booking-details screen + the
  /// bookings-list card for users who got killed mid-payment.
  Future<PaymentRunnerResult> resume(int bookingId) async {
    OverlayLoading.instance.show();
    final result =
        await instance<PaymentResumeUseCase>().execute(bookingId);
    OverlayLoading.instance.hide();

    BookingCreatePayment? payment;
    result.fold(
      (failure) {
        SnackbarHelper.showMessage(failure.userMessage, ErrorMessage.snackBar);
      },
      (response) {
        payment = response.payment;
      },
    );
    if (payment == null) {
      return PaymentRunnerResult(
        PaymentRunnerOutcome.gatewayUnavailable,
        bookingId: bookingId,
      );
    }
    if (!payment!.isReady) {
      if (context.mounted) {
        SnackbarHelper.showMessage(
          Translation.payment_gateway_unavailable.tr,
          ErrorMessage.snackBar,
        );
      }
      return PaymentRunnerResult(
        PaymentRunnerOutcome.gatewayUnavailable,
        bookingId: bookingId,
      );
    }
    return _runSdkLoop(payment!, bookingId);
  }

  /// Shared SDK-presentation loop. Both entry points feed in here once
  /// they have a fresh BookingCreatePayment with valid SDK params.
  /// Returns the [PaymentRunnerResult] for the caller to act on.
  Future<PaymentRunnerResult> _runSdkLoop(
    BookingCreatePayment payment,
    int? bookingId,
  ) async {
    // The SDK can close in three ways:
    //   - back/close button -> result is null
    //   - explicit failure  -> result is a Map with status="2"
    //   - explicit success  -> result is a Map with status="3"
    // For the first two we open the resume dialog so the user can choose
    // to try again with a fresh token. For success we skip straight to
    // server verification.
    SadadSdkParams currentSdk = payment.sdk!;
    Map? sdkResult;
    bool resumed;

    do {
      resumed = false;
      sdkResult = await _presentSadadPaymentScreen(currentSdk);
      print(sdkResult);
      final closedWithoutResult = sdkResult == null;
      final reportedFailure = sdkResult != null &&
          (sdkResult['status'] ?? '').toString() == '2';

      if (!closedWithoutResult && !reportedFailure) break;

      // Ask the user: continue payment, or cancel booking?
      if (!context.mounted) {
        return PaymentRunnerResult(
          PaymentRunnerOutcome.dismissed,
          bookingId: bookingId,
        );
      }
      final choice = await PaymentResumeDialog.show(context);

      if (choice == PaymentResumeChoice.retry) {
        // Mint a fresh token against the SAME booking. If the retry call
        // fails (token endpoint down, transaction already terminal) we
        // surface a soft error and bail to the resume dialog's
        // dismissed branch — the cron will eventually clean up.
        OverlayLoading.instance.show();
        final retried = await instance<PaymentRetryUseCase>()
            .execute(payment.transactionId!);
        OverlayLoading.instance.hide();

        SadadSdkParams? freshSdk;
        retried.fold(
          (failure) {
            SnackbarHelper.showMessage(
              Translation.payment_retry_failed.tr,
              ErrorMessage.snackBar,
            );
          },
          (response) {
            freshSdk = response.payment?.sdk;
          },
        );
        if (freshSdk == null) {
          return PaymentRunnerResult(
            PaymentRunnerOutcome.dismissed,
            bookingId: bookingId,
          );
        }
        currentSdk = freshSdk!;
        resumed = true;
        continue;
      }

      if (choice == PaymentResumeChoice.cancel) {
        await _releaseSlot(payment.transactionId!);
        if (context.mounted) {
          SnackbarHelper.showMessage(
            Translation.payment_cancelled.tr,
            ErrorMessage.snackBar,
          );
        }
        return PaymentRunnerResult(
          PaymentRunnerOutcome.cancelled,
          bookingId: bookingId,
        );
      }

      // PaymentResumeChoice.dismissed — user tapped outside / dragged
      // the sheet away. Leave the booking pending; the 15-min server
      // cron will reconcile or expire it. No nag, no force.
      return PaymentRunnerResult(
        PaymentRunnerOutcome.dismissed,
        bookingId: bookingId,
      );
    } while (resumed);

    // 3. Belt and braces: server-side verify. The backend's
    //    PaymentController.status fires a live verifyTransaction call
    //    if the webhook hasn't landed yet — we trust the backend's
    //    answer, not the SDK's.
    OverlayLoading.instance.show();
    final statusResult = await instance<PaymentStatusUseCase>().execute(
      payment.transactionId!,
    );
    OverlayLoading.instance.hide();

    PaymentRunnerOutcome outcome = PaymentRunnerOutcome.pendingVerify;

    await statusResult.fold(
      (failure) async {
        SnackbarHelper.showMessage(failure.userMessage, ErrorMessage.snackBar);
        outcome = PaymentRunnerOutcome.pendingVerify;
      },
      (response) async {
        final data = response.data;
        if (data != null && data.isSuccess) {
          onSuccess();
          outcome = PaymentRunnerOutcome.success;
        } else if (data != null && data.isFailedOrExpired) {
          // Backend confirms failure — also release the slot. We don't
          // do this on `pending` because the webhook may still arrive
          // and flip it to paid; the cron handles that race.
          await _releaseSlot(payment.transactionId!);
          if (context.mounted) {
            SnackbarHelper.showMessage(
              Translation.payment_failed.tr,
              ErrorMessage.snackBar,
            );
          }
          outcome = PaymentRunnerOutcome.failed;
        } else {
          // Pending — webhook hasn't landed yet. Surface a softer
          // message; the 15-min cron reconciles either way.
          if (context.mounted) {
            SnackbarHelper.showMessage(
              Translation.payment_pending_verification.tr,
              ErrorMessage.snackBar,
            );
          }
          outcome = PaymentRunnerOutcome.pendingVerify;
        }
      },
    );

    return PaymentRunnerResult(outcome, bookingId: bookingId);
  }

  /// Best-effort call to free the slot immediately. We don't surface a
  /// user-facing error if this fails — the cron is the safety net and
  /// will expire the booking within 15 minutes either way.
  Future<void> _releaseSlot(int transactionId) async {
    try {
      await instance<PaymentCancelUseCase>().execute(transactionId);
    } catch (_) {
      // Swallow — the user already saw the cancel/fail message. Cron
      // will clean up the orphan if needed.
    }
  }

  Future<Map?> _presentSadadPaymentScreen(SadadSdkParams sdk) async {
    final mode = sdk.packageMode == 'release'
        ? PackageMode.release
        : PackageMode.debug;
    return await Navigator.of(context).push<Map?>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => PaymentScreen(
          themeColor: const Color(0xFF1C2A3A),
          paymentButtonColor: const Color(0xFF1C2A3A),
          paymentButtonTextColor: Colors.white,
          customerName: sdk.customerName,
          mobile: sdk.customerMobile,
          email: sdk.customerEmail,
          token: sdk.token,
          amount: sdk.amountQar,
          orderId: sdk.orderId,
          packageMode: mode,
          isWalletEnabled: false, 
          paymentTypes: const [
            PaymentType.creditCard,
            PaymentType.debitCard,
            PaymentType.sadadPay,
          ],
          productDetail: [
            {
              'itemname': doctorName.isEmpty ? 'Mawadk consultation' : doctorName,
              'amount': sdk.amountQar.toStringAsFixed(2),
            }
          ],
          // Sadad's PaymentScreen renders this image at the top of its
          // checkout sheet. We use the no-name logo so the bundled
          // 'Mawadk' titleText below it doesn't repeat the wordmark.
          image: Image.asset(
            'assets/images/logo-no-name.png',
            width: 64,
            height: 64,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Image.asset(
              'assets/images/app-icon-no-background.png',
              width: 64,
              height: 64,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          titleText: 'Mawadk',
          // Apple Pay / Google Pay live mode requires merchant-id setup
          // with the wallet vendor. Stubs here keep the SDK happy while
          // isWalletEnabled stays false.
          googleMerchantID: '',
          googleMerchantName: 'Mawadk',
        ),
      ),
    );
  }

  /// Random + timestamped — uniqueness collision-free for our scale and
  /// the backend's idempotency window (15 min).
  String _newIdempotencyKey() {
    final ts  = DateTime.now().millisecondsSinceEpoch.toRadixString(16);
    final rnd = Random.secure().nextInt(0xFFFFFFFF).toRadixString(16);
    return 'mwk-$ts-$rnd';
  }
}
