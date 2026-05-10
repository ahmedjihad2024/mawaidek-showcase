import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/routes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/booking_details/bloc/booking_details_bloc.dart';
import 'package:mawadk/presentation/views/cancel_booking/view/cancel_booking_bottom_sheet.dart';
import 'package:mawadk/app/services/sadad_payment_runner.dart';

class BookingActionButtons extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onReviewSubmitted;
  final VoidCallback? onBookingCancelled;

  const BookingActionButtons({
    super.key,
    required this.booking,
    this.onReviewSubmitted,
    this.onBookingCancelled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 1,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (booking.status.isPending) {
      return _UpcomingButtons(
        booking: booking,
        onBookingCancelled: onBookingCancelled,
      );
    } else if (booking.status.isCompleted) {
      return _CompletedButtons(
        booking: booking,
        onReviewSubmitted: onReviewSubmitted,
        onBookingCancelled: onBookingCancelled,
      );
    }
    return const SizedBox.shrink();
  }
}

// ─────────────────────────────────────────────
// Upcoming Buttons (cancel + optional resume payment)
// ─────────────────────────────────────────────

class _UpcomingButtons extends StatefulWidget {
  final Booking booking;
  final VoidCallback? onBookingCancelled;

  const _UpcomingButtons({
    required this.booking,
    this.onBookingCancelled,
  });

  @override
  State<_UpcomingButtons> createState() => _UpcomingButtonsState();
}

class _UpcomingButtonsState extends State<_UpcomingButtons> {
  /// Resume a half-finished online payment.
  Future<void> _resumeOnlinePayment() async {
    final booking = widget.booking;
    final doctorName = booking.providerDoctor?.name ?? booking.provider.name;
    final runner = SadadPaymentRunner(
      context: context,
      providerId: booking.provider.id,
      providerDoctorId: booking.providerDoctor?.id,
      date: DateTime.tryParse(booking.date) ?? DateTime.now(),
      time: booking.time,
      period: booking.period == 'morning'
          ? BookingPeriod.morning
          : BookingPeriod.evening,
      doctorName: doctorName,
      onSuccess: () {
        if (!mounted) return;
        Navigator.of(context).pop();
        widget.onBookingCancelled?.call();
      },
    );
    final result = await runner.resume(booking.id);
    if (!mounted) return;
    if (result.outcome != PaymentRunnerOutcome.success) {
      context
          .read<BookingDetailsBloc>()
          .add(GetBookingDetailsEvent(bookingId: booking.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final canResume = widget.booking.canResumeOnlinePayment;

    return Column(
      children: [
        if (canResume) ...[
          SizedBox(
            width: double.infinity,
            child: CustomInkButton(
              onTap: () => _resumeOnlinePayment(),
              backgroundColor: const Color(0xFF1C2A3A),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              borderRadius: 50.r,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payments_rounded,
                      color: Colors.white, size: 18.w),
                  SizedBox(width: 8.w),
                  Text(
                    Translation.resume_online_payment.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeightM.semiBold,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
        ],
        Row(
          children: [
            Expanded(
              child: CustomInkButton(
                onTap: () {
                  CancelBookingBottomSheet.show(context, widget.booking.id)
                      .then((result) {
                    if (result == true && mounted) {
                      widget.onBookingCancelled?.call();
                      Navigator.of(context).pop();
                    }
                  });
                },
                backgroundColor: const Color(0xFFF41731),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                borderRadius: 50.r,
                alignment: Alignment.center,
                child: Text(
                  Translation.cancel.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeightM.medium,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Completed Buttons (rebook + add review)
// ─────────────────────────────────────────────

class _CompletedButtons extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onReviewSubmitted;
  final VoidCallback? onBookingCancelled;

  const _CompletedButtons({
    required this.booking,
    this.onReviewSubmitted,
    this.onBookingCancelled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomInkButton(
            onTap: () {
              Category category = booking.provider.type.isDoctor
                  ? (booking.provider.category ??
                      booking.provider.categories!.first)
                  : booking.providerDoctor!.category;
              Navigator.of(context).pushNamed(
                RoutesManager.appointmentBooking.route,
                arguments: {
                  'provider-id': booking.provider.id,
                  'provider-name': booking.provider.name,
                  'department': category,
                  'provider-type': booking.provider.type,
                },
              );
            },
            backgroundColor: const Color(0xFFE5E7EB),
            padding: EdgeInsets.symmetric(vertical: 12.h),
            borderRadius: 50.r,
            alignment: Alignment.center,
            child: Text(
              Translation.re_book.tr,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeightM.bold,
                color: const Color(0xFF1C2A3A),
                height: 1.5,
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        if (!booking.isRated)
          Expanded(
            child: CustomInkButton(
              onTap: () {
                dynamic providerDoctor = booking.provider.type.isDoctor
                    ? booking.provider
                    : booking.providerDoctor;

                if (providerDoctor == null) return;

                Navigator.of(context).pushNamed(
                  RoutesManager.review.route,
                  arguments: {
                    'booking-id': booking.id,
                    'provider-type': booking.provider.type,
                    'doctor-image': providerDoctor.image,
                    'doctor-name': providerDoctor.name,
                  },
                ).then((result) {
                  if (result == true && context.mounted) {
                    context.read<BookingDetailsBloc>().add(
                          UpdateBookingRatedEvent(bookingId: booking.id),
                        );
                    onReviewSubmitted?.call();
                  }
                });
              },
              backgroundColor: const Color(0xFF1C2A3A),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              borderRadius: 50.r,
              alignment: Alignment.center,
              child: Text(
                Translation.add_review.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeightM.bold,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
