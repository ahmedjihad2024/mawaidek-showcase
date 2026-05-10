import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';

class BookingFeesSummary extends StatelessWidget {
  final Booking booking;

  const BookingFeesSummary({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFECF6FF),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _FeeRow(
            title: Translation.consultation_fee.tr,
            value: Translation.price_qar
                .trNamed({'price': booking.subtotal.toString()}),
            isTotal: false,
          ),
          SizedBox(height: 6.h),
          _FeeRow(
            title: Translation.service_fee.tr,
            value: Translation.price_qar
                .trNamed({'price': booking.feeServices.toString()}),
            isTotal: false,
          ),
          SizedBox(height: 8.h),
          Container(
            height: 1.h,
            width: double.infinity,
            color: const Color(0xFFE5E7EA),
          ),
          SizedBox(height: 8.h),
          _FeeRow(
            title: Translation.total.tr,
            value: Translation.price_qar
                .trNamed({'price': booking.total.toString()}),
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _FeeRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isTotal;

  const _FeeRow({
    required this.title,
    required this.value,
    required this.isTotal,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(
      fontSize: isTotal ? 13.sp : 14.sp,
      fontWeight: isTotal ? FontWeightM.bold : FontWeightM.medium,
      color: isTotal ? const Color(0xFF1C2A3A) : const Color(0xFF4C4747),
      height: 1.2,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style),
        Text(value, style: style),
      ],
    );
  }
}
