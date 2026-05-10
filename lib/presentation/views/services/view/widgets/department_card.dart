import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/presentation/common/ui_components/custom_cached_image.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:smooth_corner/smooth_corner.dart';

class DepartmentCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int doctorsCount;
  final bool isSelected;
  final VoidCallback? onTap;

  const DepartmentCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.doctorsCount,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? const Color.fromRGBO(56, 121, 212, .6)
        : Colors.black.withValues(alpha: 0.06);

    final bgColor = isSelected
        ? const Color.fromRGBO(56, 121, 212, .04)
        : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: SmoothContainer(
        smoothness: 1,
        alignment: Alignment.center,
        borderRadius: BorderRadius.circular(12.r),
        color: bgColor,
        side: BorderSide(
          width: 1.w,
          color: borderColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomCachedImage(
              imageUrl: imageUrl,
              width: 32.w,
              height: 32.w,
              errorBackgroundColor: Colors.transparent,
            ),
            SizedBox(height: 8.w),
            Text(
              title,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                height: 1,
                fontWeight: FontWeightM.medium,
                color: const Color(0xFF4B5563),
              ),
            ),
            SizedBox(height: 3.w),
            Text(
              Translation.doctors_count.trNamed(
                {"count": doctorsCount.toString()},
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                height: 1,
                fontWeight: FontWeightM.regular,
                color: const Color(0xFF4B5563),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
