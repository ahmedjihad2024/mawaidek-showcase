import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';

class BookingAutoActionBanner extends StatelessWidget {
  final String message;

  const BookingAutoActionBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFDE68A), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18.w,
            color: const Color(0xFFB45309),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeightM.medium,
                color: const Color(0xFF78350F),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
