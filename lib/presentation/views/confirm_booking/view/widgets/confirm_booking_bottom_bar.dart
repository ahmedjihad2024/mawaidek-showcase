import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/routes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/confirm_booking/bloc/confirm_booking_bloc.dart';
import 'package:mawadk/app/services/sadad_payment_runner.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';
import 'package:mawadk/presentation/views/home/view/screens/home_view.dart';
import 'package:mawadk/presentation/views/profile_completion/view/widgets/success_dialog.dart';

class ConfirmBookingBottomBar extends StatelessWidget {
  final ConfirmBookingState state;
  final int providerId;
  final int? providerDoctorId;
  final DateTime date;
  final String time;
  final BookingPeriod period;

  const ConfirmBookingBottomBar({
    super.key,
    required this.state,
    required this.providerId,
    this.providerDoctorId,
    required this.date,
    required this.time,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    final confirmData = state.confirmData;
    if (confirmData == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(15, 23, 42, 0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: CustomInkButton(
        enabled: state.isConfrirmButtonEnabled,
        onTap: state.isConfrirmButtonEnabled
            ? () {
                final doctorName = confirmData.providerDoctor?.name ??
                    confirmData.provider.name;
                final showSuccess = () {
                  // Success haptic — Apple HIG defines `selectionClick`
                  // for confirmation moments; mediumImpact would feel
                  // alarming here. The dialog already gives a strong
                  // visual cue; this just adds a tactile beat.
                  HapticFeedback.lightImpact();
                  context.showAppointmentSuccessDialog(
                    doctorName: doctorName,
                    appointmentDate: date,
                    appointmentTime: time,
                    onDone: () {
                      _landUserOnBookingsTabAfterPayment(context);
                    },
                  );
                };

                // Online flow takes the dedicated runner — it handles
                // create-booking, the Sadad PaymentScreen, and the
                // status-poll handshake. Cash flow stays on the bloc
                // path it has used since day one.
                //
                // The runner now returns a typed outcome so we can route
                // the user to the right destination instead of leaving
                // them stuck on this confirm-booking screen with a
                // snackbar:
                //   - success    → already handled by onSuccess (above)
                //   - cancelled  → BookingDetails for the just-created
                //                  booking so they see the explanation
                //                  banner and can re-book if needed
                //   - failed     → BookingDetails (failure banner)
                //   - pending    → BookingDetails (soft "we're confirming")
                //   - dismissed  → Home (booking left pending; cron will
                //                  reconcile within 15 min)
                if (state.paymentMethod.isOnline) {
                  SadadPaymentRunner(
                    context: context,
                    providerId: providerId,
                    providerDoctorId: providerDoctorId,
                    date: date,
                    time: time,
                    period: period,
                    doctorName: doctorName,
                    onSuccess: showSuccess,
                  ).run().then((result) {
                    if (!context.mounted) return;
                    _handlePaymentOutcome(context, result);
                  });
                  return;
                }

                context.read<ConfirmBookingBloc>().add(
                      CreateBookingEvent(
                        providerId: providerId,
                        providerDoctorId: providerDoctorId,
                        date: date,
                        time: time,
                        period: period,
                        paymentMethod: state.paymentMethod,
                        onSuccess: showSuccess,
                      ),
                    );
              }
            : null,
        backgroundColor: state.isConfrirmButtonEnabled
            ? const Color(0xFF1C2A3A)
            : const Color(0xFFD1D5DB),
        borderRadius: 50.r,
        height: 48.h,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              Translation.confirm_and_pay.tr,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeightM.medium,
                color: state.isConfrirmButtonEnabled
                    ? Colors.white
                    : const Color(0xFF9CA3AF),
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: state.isConfrirmButtonEnabled
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Text(
                Translation.price_qar
                    .trNamed({'price': confirmData.price.total.toString()}),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeightM.medium,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Closes the confirm-booking screen and lands the patient on the
  /// upcoming-bookings list with the freshly-paid booking visible at
  /// the top. This is the "the appointment is done — go look at it"
  /// moment, so we want three things to happen as one smooth motion:
  ///
  ///   1. Pop everything down to the bottom-nav root.
  ///   2. Switch the active tab to "My Bookings" with a slide animation.
  ///   3. Force-refetch the upcoming list so the new booking appears
  ///      with its correct paid state (the local cache still has the
  ///      pre-payment snapshot — without the refetch the user would
  ///      see "Awaiting payment" briefly until they navigated away
  ///      and came back).
  ///   4. A green success snackbar at the top of the bookings list as
  ///      the final confirmation that the payment landed.
  ///
  /// All four steps are wrapped in one frame so the user perceives
  /// them as a single transition, not a stutter.
  void _landUserOnBookingsTabAfterPayment(BuildContext context) {
    // Pop confirm-booking + any intermediate route (slot picker etc.)
    // down to the bottom-nav root.
    Navigator.of(context).popUntil((route) => route.isFirst);

    // Switch the bottom-nav controller to the Home tab. The home
    // upcoming-appointments widget reads from the same booking list
    // the My Bookings tab does, so refreshing once below feeds both.
    HomeTapsControllers.BOTTOM_NAV_BAR_SELECTED_TAB.value = 0;
    HomeTapsControllers.BOTTOM_NAV_BAR_SLIDER_CONTROLLER.animateToPage(
      0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );

    // Immediate refresh — both the home dashboard data and the
    // upcoming-bookings list. `GetBookingsEvent(pending)` feeds both
    // the Home tab's "Upcoming Appointments" widget and the My
    // Bookings tab list, so one event refreshes both in lockstep.
    HomeView.homeBloc?.add(HomeDataEvent());
    HomeView.homeBloc?.add(GetBookingsEvent(
      statusApp: BookingStatusApp.pending,
      isRefresh: true,
    ));

    // Defensive second refresh 1.2 s later — covers the slow-webhook
    // race where the first refresh fires before Sadad's webhook has
    // landed on the backend. Without this, on a slow network the user
    // briefly sees "Awaiting payment" + a Continue Payment CTA on a
    // booking that has actually paid; tapping the CTA then bounces
    // off the backend's "booking not pending" guard. The retry
    // guarantees the paid state surfaces before the user can react.
    Future.delayed(const Duration(milliseconds: 1200), () {
      HomeView.homeBloc?.add(GetBookingsEvent(
        statusApp: BookingStatusApp.pending,
        isRefresh: true,
      ));
    });

    // Snackbar confirmation. We schedule it for the next frame so it
    // attaches to the tab's ScaffoldMessenger AFTER the tab swap, not
    // the confirm-booking scaffold that's about to be unmounted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.hideCurrentSnackBar();
      messenger?.showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF059669), // success green
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          margin: EdgeInsets.all(12.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  Translation.payment_success_message.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeightM.semiBold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// Decides where to send the user after the payment runner finishes.
  void _handlePaymentOutcome(BuildContext context, PaymentRunnerResult result) {
    switch (result.outcome) {
      case PaymentRunnerOutcome.success:
        // Already handled inline by SadadPaymentRunner.onSuccess →
        // showSuccess dialog + popUntil(first). Nothing else to do.
        return;

      case PaymentRunnerOutcome.cancelled:
      case PaymentRunnerOutcome.failed:
      case PaymentRunnerOutcome.pendingVerify:
        // Route the user to the booking detail so they see the system
        // banner. We REPLACE this confirm-booking screen rather than
        // push on top — the user is done with confirm-booking, no
        // sense leaving it on the back-stack.
        if (result.bookingId != null && result.bookingId! > 0) {
          Navigator.of(context).pushReplacementNamed(
            RoutesManager.bookingDetails.route,
            arguments: {'booking-id': result.bookingId},
          );
        } else {
          // bookingId missing — fall back to home so the user isn't
          // stuck on confirm-booking with no useful action.
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        return;

      case PaymentRunnerOutcome.dismissed:
        // Drop straight to home. The upcoming-bookings tab will surface
        // a Resume Payment CTA so the user can pick it back up.
        Navigator.of(context).popUntil((route) => route.isFirst);
        return;

      case PaymentRunnerOutcome.gatewayUnavailable:
      case PaymentRunnerOutcome.bookingCreateFailed:
        // Stay on this screen — the user already saw the error snackbar
        // and may want to retry.
        return;
    }
  }
}
