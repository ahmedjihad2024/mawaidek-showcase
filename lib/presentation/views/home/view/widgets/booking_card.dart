import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/presentation/common/ui_components/custom_cached_image.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/res/assets_manager.dart';
import 'package:mawadk/presentation/res/color_manager.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';

class BookingCard extends StatelessWidget {
  final String imageUrl;
  final String doctorName;
  final String specialty;
  final DateTime date;
  final String location;
  final BookingStatus status;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onReBook;
  final VoidCallback? onAddReview;
  final VoidCallback? onResumePayment;
  final bool isRated;
  final String? total;
  final String? invoiceNumber;

  /// 'cash' | 'online' (or '' for legacy bookings). Drives the small
  /// payment-method chip in the bottom strip; we hide the chip when the
  /// API didn't surface a method.
  final PaymentMethod? paymentMethod;

  /// 'pending' | 'paid' | 'failed' | 'refunded'. Drives the colour of
  /// the status dot next to the method chip.
  final PaymentStatus paymentStatus;

  /// True when the booking is online + pending and the slot hasn't
  /// expired — surfaces a primary "Continue Payment" CTA above the
  /// cancel button so the user can recover from a half-finished Sadad
  /// session without re-picking the slot.
  final bool canResumePayment;

  const BookingCard({
    super.key,
    required this.imageUrl,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.location,
    required this.status,
    required this.isRated,
    this.onTap,
    this.onCancel,
    this.onReBook,
    this.onAddReview,
    this.onResumePayment,
    this.total,
    this.invoiceNumber,
    this.paymentMethod,
    this.paymentStatus = PaymentStatus.pending,
    this.canResumePayment = false,
  });

  // Status color mapping
  Color get _statusColor => switch (status) {
        BookingStatus.upcoming => const Color(0xFF009FF5),
        BookingStatus.completed => const Color(0xFF22C55E),
        BookingStatus.cancelled => const Color(0xFFEF4444),
      };

  Color get _statusBgColor => switch (status) {
        BookingStatus.upcoming => const Color(0xFFE8F7FF),
        BookingStatus.completed => const Color(0xFFECFDF5),
        BookingStatus.cancelled => const Color(0xFFFEF2F2),
      };

  String get _statusText => switch (status) {
        BookingStatus.upcoming => Translation.upcoming.tr,
        BookingStatus.completed => Translation.completed.tr,
        BookingStatus.cancelled => Translation.cancelled.tr,
      };

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final difference = dateOnly.difference(today).inDays;

    final String dateLabel;
    if (difference == 0) {
      dateLabel = Translation.today.tr;
    } else if (difference == 1) {
      dateLabel = Translation.tomorrow.tr;
    } else if (difference == -1) {
      dateLabel = Translation.yesterday.tr;
    } else {
      dateLabel = DateFormat('MMM d, yyyy', locale).format(date);
    }

    final String timeLabel = DateFormat('hh:mm a', locale).format(date);

    return CustomInkButton(
      onTap: onTap,
      padding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      borderRadius: 14.r,
      side: BorderSide(
        color: Colors.grey.withValues(alpha: 0.12),
        width: 0.8,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Invoice number (left) + Status badge (right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Invoice number
                    if (invoiceNumber != null && invoiceNumber!.isNotEmpty)
                      Text(
                        '#$invoiceNumber',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeightM.medium,
                          color: const Color(0xFF9CA3AF),
                          height: 1.2,
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    // Status badge
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: _statusBgColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        _statusText,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeightM.semiBold,
                          color: _statusColor,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Doctor info row
                Row(
                  children: [
                    // Doctor image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CustomCachedImage(
                        imageUrl: imageUrl,
                        width: 64.w,
                        height: 64.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Doctor details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctorName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeightM.bold,
                              color: ColorM.primary,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            specialty,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeightM.medium,
                              color: const Color(0xFF6B7280),
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          // Location
                          if (location.isNotEmpty)
                            Row(
                              children: [
                                SvgPicture.asset(
                                  SvgM.pickLocationBorder,
                                  width: 12.w,
                                  height: 12.w,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF9CA3AF),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Text(
                                    location,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeightM.regular,
                                      color: const Color(0xFF9CA3AF),
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom section: Date/Time bar + Actions
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Date, Time, Price row
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          // Date chip
                          _InfoChip(
                            icon: SvgPicture.asset(
                              SvgM.calendar,
                              width: 13.w,
                              height: 13.w,
                              colorFilter: ColorFilter.mode(
                                ColorM.primary.withValues(alpha: 0.55),
                                BlendMode.srcIn,
                              ),
                            ),
                            label: dateLabel,
                          ),
                      
                          // Time chip
                          _InfoChip(
                            icon: Icon(
                              Icons.access_time_rounded,
                              size: 13.w,
                              color: ColorM.primary.withValues(alpha: 0.55),
                            ),
                            label: timeLabel,
                          ),
                      
                          // Total price
                          if (total != null &&
                              total!.isNotEmpty &&
                              total != '0.0' &&
                              total != '0')
                            Text(
                              Translation.price_qar
                                  .trNamed({'price': total!}),
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeightM.bold,
                                color: ColorM.primary,
                                height: 1.2,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Payment chip strip — payment method + status dot.
                // Hidden when the API didn't surface a method (legacy
                // bookings) so we never render half-empty UI.
                if (paymentMethod != null) ...[
                  SizedBox(height: 8.h),
                  _PaymentChipStrip(
                    paymentMethod: paymentMethod!,
                    paymentStatus: paymentStatus,
                  ),
                ],

                // Action buttons
                if (status == BookingStatus.upcoming ||
                    status == BookingStatus.completed) ...[
                  SizedBox(height: 10.h),
                  // The Resume-Payment CTA replaces Cancel-only when the
                  // user has a half-finished online payment. Cancel is
                  // still reachable from the booking-details screen, but
                  // here the dominant action shifts to "finish what you
                  // started" because that's what 95% of these users
                  // actually need.
                  if (canResumePayment) ...[
                    SizedBox(
                      width: double.infinity,
                      child: CustomInkButton(
                        onTap: onResumePayment,
                        backgroundColor: ColorM.primary,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        borderRadius: 10.r,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.payments_rounded,
                                color: Colors.white, size: 15.w),
                            SizedBox(width: 6.w),
                            Text(
                              Translation.resume_online_payment.tr,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeightM.semiBold,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                  Row(
                    children: [
                      // Primary action (Cancel / Re-book)
                      Expanded(
                        child: CustomInkButton(
                          onTap: status == BookingStatus.upcoming
                              ? onCancel
                              : onReBook,
                          backgroundColor: status == BookingStatus.upcoming
                              ? const Color(0xFFFEF2F2)
                              : const Color(0xFFF3F4F6),
                          padding: EdgeInsets.symmetric(vertical: 9.h),
                          borderRadius: 10.r,
                          alignment: Alignment.center,
                          child: Text(
                            status == BookingStatus.upcoming
                                ? Translation.cancel.tr
                                : Translation.re_book.tr,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeightM.semiBold,
                              color: status == BookingStatus.upcoming
                                  ? const Color(0xFFEF4444)
                                  : ColorM.primary,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),

                      // Secondary action (Add Review - only for completed & not rated)
                      if (status == BookingStatus.completed && !isRated) ...[
                        SizedBox(width: 10.w),
                        Expanded(
                          child: CustomInkButton(
                            onTap: onAddReview,
                            backgroundColor: ColorM.primary,
                            padding: EdgeInsets.symmetric(vertical: 9.h),
                            borderRadius: 10.r,
                            alignment: Alignment.center,
                            child: Text(
                              Translation.add_review.tr,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeightM.semiBold,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact payment-status strip rendered inside the booking card.
///
/// Shows two pieces of information the user can never see today:
///   * the payment method (cash vs online with the right icon)
///   * the payment status (a coloured dot + word — paid/pending/failed
///     /refunded)
///
/// Both are derived from the API's `payment_method` and `payment_status`
/// fields. Nothing else in the UI exposes this, so users couldn't tell
/// "did I already pay or do I owe money at the clinic?" — this fixes
/// that at the list level so they don't even need to open the booking.
class _PaymentChipStrip extends StatelessWidget {
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;

  const _PaymentChipStrip({
    required this.paymentMethod,
    required this.paymentStatus,
  });

  ({Color bg, Color fg, IconData icon, String label}) get _statusTone {
    switch (paymentStatus) {
      case PaymentStatus.paid:
        return (
          bg: const Color(0xFFECFDF5),
          fg: const Color(0xFF059669),
          icon: Icons.check_circle_rounded,
          label: Translation.payment_status_paid.tr,
        );
      case PaymentStatus.failed:
        return (
          bg: const Color(0xFFFEF2F2),
          fg: const Color(0xFFDC2626),
          icon: Icons.error_rounded,
          label: Translation.payment_status_failed.tr,
        );
      case PaymentStatus.refunded:
        return (
          bg: const Color(0xFFF1F5F9),
          fg: const Color(0xFF475569),
          icon: Icons.replay_rounded,
          label: Translation.payment_status_refunded.tr,
        );
      case PaymentStatus.pending:
      default:
        return (
          bg: const Color(0xFFFEF3C7),
          fg: const Color(0xFFD97706),
          icon: Icons.schedule_rounded,
          label: Translation.payment_status_pending.tr,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = paymentMethod.isOnline;
    final tone = _statusTone;

    return Row(
      children: [
        // Payment method chip
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isOnline
                    ? Icons.credit_card_rounded
                    : Icons.payments_outlined,
                size: 12.w,
                color: const Color(0xFF6B7280),
              ),
              SizedBox(width: 4.w),
              Text(
                isOnline
                    ? Translation.paid_with_card.tr
                    : Translation.paid_with_cash.tr,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeightM.medium,
                  color: const Color(0xFF374151),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        if(isOnline) ...[SizedBox(width: 6.w),
        // Status pill
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: tone.bg,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(tone.icon, size: 11.w, color: tone.fg),
              SizedBox(width: 4.w),
              Text(
                tone.label,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeightM.semiBold,
                  color: tone.fg,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),]
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final Widget icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: ColorM.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeightM.semiBold,
              color: ColorM.primary,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
