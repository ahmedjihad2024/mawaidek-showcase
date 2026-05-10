import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/presentation/res/color_manager.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';

/// The choice the user made on the resume dialog.
enum PaymentResumeChoice { retry, cancel, dismissed }

/// Bottom-sheet style dialog shown when the user backs out of the
/// Sadad PaymentScreen.
///
/// UX rationale:
/// - Default action (right-side, primary blue) = "Continue Payment".
///   We want to nudge completion, not abandonment.
/// - Cancel button (left-side, neutral) = "Cancel Booking".
///   No alarming red — the user is making a normal choice, not destroying data.
/// - Body text explains the 15-min hold transparently so the user knows
///   the slot is reserved and what happens if they walk away.
/// - Tap-outside / hardware back returns `dismissed` (slot stays held; the
///   server's 15-min cron is the safety net). This protects accidental taps.
class PaymentResumeDialog extends StatelessWidget {
  const PaymentResumeDialog({super.key});

  static Future<PaymentResumeChoice> show(BuildContext context) async {
    final result = await showModalBottomSheet<PaymentResumeChoice>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PaymentResumeDialog(),
    );
    return result ?? PaymentResumeChoice.dismissed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 18.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            // Hero icon — clock-with-pause feel.
            Center(
              child: Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      ColorM.primary.withValues(alpha: 0.12),
                      ColorM.heavyBlue.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  Icons.payments_rounded,
                  color: ColorM.primary,
                  size: 30.w,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Title
            Text(
              Translation.payment_resume_dialog_title.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeightM.bold,
                color: ColorM.black2,
                height: 1.3,
              ),
            ),
            SizedBox(height: 10.h),

            // Body — explains the 15-min hold transparently.
            Text(
              Translation.payment_resume_dialog_body.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: ColorM.lightPurple,
                height: 1.55,
              ),
            ),
            SizedBox(height: 22.h),

            // Primary CTA — Continue Payment
            _PrimaryButton(
              label: Translation.payment_resume_continue.tr,
              icon: Icons.refresh_rounded,
              onTap: () =>
                  Navigator.of(context).pop(PaymentResumeChoice.retry),
            ),
            SizedBox(height: 10.h),

            // Secondary — Cancel Booking (neutral, not destructive)
            _SecondaryButton(
              label: Translation.payment_resume_cancel_booking.tr,
              onTap: () =>
                  Navigator.of(context).pop(PaymentResumeChoice.cancel),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ColorM.primary, ColorM.heavyBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: ColorM.primary.withValues(alpha: 0.28),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18.w),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeightM.semiBold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6F9),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeightM.medium,
              color: ColorM.lightPurple,
            ),
          ),
        ),
      ),
    );
  }
}
