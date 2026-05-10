import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mawadk/app/extensions.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/presentation/common/ui_components/custom_cached_image.dart';
import 'package:mawadk/presentation/res/assets_manager.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:smooth_corner/smooth_corner.dart';

class AppointmentInfoSection extends StatelessWidget {
  final Category department;
  final String providerName;

  const AppointmentInfoSection({
    super.key,
    required this.department,
    required this.providerName,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothContainer(
      smoothness: 1,
      padding: EdgeInsets.all(18.w),
      borderRadius: BorderRadius.circular(12.r),
      margin: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      color: Color.fromRGBO(56, 121, 212, 0.04),
      child: Row(
        spacing: 12.w,
        children: [
          CustomCachedImage(
            imageUrl: department.image,
            width: 48.w,
            height: 48.w,
          ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.w,
              children: [
                Text(
                  department.name,
                  style: context.headlineSmall
                      .copyWith(fontWeight: FontWeightM.medium),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      SvgM.hospital,
                      width: 16.w,
                      height: 16.w,
                    ),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        providerName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeightM.regular,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
