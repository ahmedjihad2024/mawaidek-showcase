import 'package:flutter/material.dart';
import 'package:mawadk/app/enums.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';

/// Visual recipe for a single payment-status badge. Centralised so the
/// icon, foreground, and background colours stay in lockstep.
class PaymentTone {
  final Color bg;
  final Color fg;
  final IconData icon;
  final String label;

  PaymentTone({
    required this.bg,
    required this.fg,
    required this.icon,
    required this.label,
  });
}

PaymentTone paymentStatusTone(PaymentStatus status) {
  switch (status) {
    case PaymentStatus.paid:
      return PaymentTone(
        bg: const Color(0xFFECFDF5),
        fg: const Color(0xFF059669),
        icon: Icons.check_circle_outline_rounded,
        label: Translation.payment_status_paid.tr,
      );
    case PaymentStatus.failed:
      return PaymentTone(
        bg: const Color(0xFFFEF2F2),
        fg: const Color(0xFFDC2626),
        icon: Icons.error_outline_rounded,
        label: Translation.payment_status_failed.tr,
      );
    case PaymentStatus.refunded:
      return PaymentTone(
        bg: const Color(0xFFF1F5F9),
        fg: const Color(0xFF475569),
        icon: Icons.replay_rounded,
        label: Translation.payment_status_refunded.tr,
      );
    case PaymentStatus.pending:
    default:
      return PaymentTone(
        bg: const Color(0xFFFEF3C7),
        fg: const Color(0xFFD97706),
        icon: Icons.schedule_rounded,
        label: Translation.payment_status_pending.tr,
      );
  }
}

class BookingPaymentInfoSection extends StatelessWidget {
  final Booking booking;

  const BookingPaymentInfoSection({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final isOnline = booking.paymentMethod.isOnline;
    final methodLabel = isOnline
        ? Translation.paid_with_card.tr
        : Translation.paid_with_cash.tr;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE5E7EA), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Row 1 — payment method
          _PaymentRow(
            iconBg: isOnline
                ? const Color(0xFFEEF2FF)
                : const Color(0xFFFEF3C7),
            icon: Icon(
              isOnline
                  ? Icons.credit_card_rounded
                  : Icons.payments_outlined,
              color: isOnline
                  ? const Color(0xFF4F46E5)
                  : const Color(0xFFD97706),
              size: 18.w,
            ),
            label: Translation.payment_method.tr,
            value: methodLabel,
          ),

          if (isOnline) ...[
            SizedBox(height: 12.h),
            Container(height: 1.h, color: const Color(0xFFF1F3F5)),
            SizedBox(height: 12.h),
            // Row 2 — payment status
            _PaymentStatusRow(paymentStatus: booking.paymentStatus),
          ],

          // Row 3 — invoice number (tap to copy)
          if (booking.invoiceNumber.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Container(height: 1.h, color: const Color(0xFFF1F3F5)),
            SizedBox(height: 12.h),
            _InvoiceRow(invoiceNumber: booking.invoiceNumber),
          ],
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final Color iconBg;
  final Widget icon;
  final String label;
  final String value;
  final Widget? trailing;

  const _PaymentRow({
    required this.iconBg,
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: icon,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeightM.regular,
                  color: const Color(0xFF6B7280),
                  height: 1.3,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeightM.semiBold,
                  color: const Color(0xFF1F2A37),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _PaymentStatusRow extends StatelessWidget {
  final PaymentStatus paymentStatus;

  const _PaymentStatusRow({required this.paymentStatus});

  @override
  Widget build(BuildContext context) {
    final tone = paymentStatusTone(paymentStatus);
    return _PaymentRow(
      iconBg: tone.bg,
      icon: Icon(tone.icon, color: tone.fg, size: 18.w),
      label: Translation.payment_status_label.tr,
      value: tone.label,
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: tone.bg,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          tone.label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeightM.semiBold,
            color: tone.fg,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

class _InvoiceRow extends StatelessWidget {
  final String invoiceNumber;

  const _InvoiceRow({required this.invoiceNumber});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: invoiceNumber));
        await HapticFeedback.selectionClick();
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(Translation.invoice_copied.tr),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
              margin: EdgeInsets.all(12.w),
            ),
          );
      },
      borderRadius: BorderRadius.circular(8.r),
      child: _PaymentRow(
        iconBg: const Color(0xFFE0F2FE),
        icon: Icon(
          Icons.receipt_long_outlined,
          color: const Color(0xFF0369A1),
          size: 18.w,
        ),
        label: Translation.invoice_number_label.tr,
        value: '#$invoiceNumber',
        trailing: Icon(
          Icons.copy_rounded,
          size: 16.w,
          color: const Color(0xFF6B7280),
        ),
      ),
    );
  }
}
