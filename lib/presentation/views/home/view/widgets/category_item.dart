import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/presentation/common/ui_components/custom_cached_image.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';

class CategoryItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Color color;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // The new category icons ship with their own navy background
        // and rounded-square framing baked into the PNG. Wrapping them
        // in a coloured container plus a half-visible white circle
        // (the old design) made them look cluttered and washed-out.
        // We now just clip the image to a rounded-square tap target so
        // the gold-on-navy artwork is the entire visual.
        //
        // `color` is kept on the constructor for backward compatibility
        // with callers that still pass it, but it's no longer rendered.
        CustomInkButton(
          width: 62.w,
          height: 62.w,
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          borderRadius: 14.r,
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: CustomCachedImage(
              imageUrl: imageUrl,
              width: 62.w,
              height: 62.w,
              fit: BoxFit.cover,
              errorBackgroundColor: const Color(0xFF1C2A3A),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: 10.w, maxWidth: 74.w),
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              height: 1.2,
              fontWeight: FontWeightM.medium,
              color: const Color(0xFF4B5563), // gray-600
            ),
          ),
        ),
      ],
    );
  }
}
