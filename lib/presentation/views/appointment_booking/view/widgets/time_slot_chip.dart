import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/presentation/res/color_manager.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:smooth_corner/smooth_corner.dart';

class TimeSlotChip extends StatelessWidget {
  final String time;
  final bool isSelected;
  final bool isAvailable;

  const TimeSlotChip({
    super.key,
    required this.time,
    required this.isSelected,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 12.w),
      decoration: ShapeDecoration(
        color: isSelected ? const Color(0xFF1F1B2E) : Colors.white,
        shape: SmoothRectangleBorder(
            borderRadius: BorderRadius.circular(14.r), smoothness: 1),
        shadows: [
          if (!isSelected && isAvailable)
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Text(
        time,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeightM.semiBold,
          color: isSelected ? Colors.white : ColorM.black,
          height: 1.15,
        ),
      ),
    );
  }
}
