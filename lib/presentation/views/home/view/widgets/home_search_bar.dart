import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/res/assets_manager.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  const HomeSearchBar({super.key, this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return CustomInkButton(
      onTap: onTap,
      height: 45.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      alignment: Alignment.center,
      backgroundColor: const Color(0xFFF3F4F6), // gray-100
      borderRadius: 8.r,
      child: Row(
        children: [
          SvgPicture.asset(
            SvgM.searchNormal,
            width: 24.w,
            height: 24.w,
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeightM.regular,
              color: const Color(0xFF9CA3AF), // gray-400
            ),
          ),
        ],
      ),
    );
  }
}
