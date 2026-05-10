import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mawadk/presentation/common/ui_components/custom_cached_image.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/common/ui_components/rate_widget.dart';
import 'package:mawadk/presentation/res/assets_manager.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';

class MedicalCenterCard extends StatelessWidget {
  final String image;
  final String title;
  final String address;
  final String? distanceKm;
  final double rating;
  final int reviews;
  final String type;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  const MedicalCenterCard({
    super.key,
    required this.image,
    required this.title,
    required this.address,
    this.distanceKm,
    required this.rating,
    required this.reviews,
    required this.type,
    required this.onTap,
    required this.onFavoriteTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomInkButton(
          onTap: onTap,
          width: 232.w,
          backgroundColor: Colors.white,
          borderRadius: 8.r,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 3,
              offset: const Offset(3, 3),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.09),
              blurRadius: 1,
              offset: const Offset(1, 1),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 0,
              offset: const Offset(0, 0),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              CustomCachedImage(
                height: 121.h,
                width: double.infinity,
                imageUrl: image,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r),
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              height: 1.2,
                              fontWeight: FontWeightM.bold,
                              color: const Color(0xFF4B5563), // gray-600
                            ),
                          ),
                        ),
                        5.horizontalSpace,
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              SvgM.hospital,
                              width: 16.w,
                              height: 16.h,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              type,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeightM.regular,
                                color: const Color(0xFF6B7280), // gray-500
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    // Address & Distance
                    Row(
                      children: [
                        SvgPicture.asset(
                          SvgM.pickLocationBorder,
                          width: 14.w,
                          height: 14.h, // gray-500
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeightM.regular,
                              color: const Color(0xFF6B7280), // gray-500
                            ),
                          ),
                        ),
                        if (distanceKm != null && distanceKm!.isNotEmpty && distanceKm != '0.0' && distanceKm != '0') ...[
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C2A3A).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              '$distanceKm ${Translation.km.tr}',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeightM.semiBold,
                                color: const Color(0xFF1C2A3A),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 8.h),

                    // Rating
                    Row(
                      children: [
                        Text(
                          rating.toString(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeightM.semiBold,
                            color: const Color(0xFF6B7280), // gray-500
                          ),
                        ),
                        SizedBox(width: 4.w),
                        RateWidget(
                          readonly: true,
                          initialRate: rating,
                          size: 12.w,
                          spacing: .3.w,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '(' +
                              '$reviews' +
                              ' ' +
                              '${Translation.reviews.tr}' +
                              ')',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeightM.regular,
                            color: const Color(0xFF6B7280), // gray-500
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        PositionedDirectional(
          top: 5.w,
          end: 5.w,
          child: CustomInkButton(
            backgroundColor: Colors.black.withValues(alpha: 0.1),
            padding: EdgeInsets.all(5.w),
            borderRadius: 99999,
            onTap: onFavoriteTap,
            child: SvgPicture.asset(
              isFavorite ? SvgM.heart : SvgM.heartBorder,
              width: 17.w,
              height: 17.w,
            ),
          ),
        ),
      ],
    );
  }
}
