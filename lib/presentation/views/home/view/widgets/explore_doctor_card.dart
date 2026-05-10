import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mawadk/presentation/common/ui_components/custom_cached_image.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/common/utils/fast_function.dart';
import 'package:mawadk/presentation/res/assets_manager.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';

class ExploreDoctorCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String specialty;
  final String location;
  final String? distanceKm;
  final double rating;
  final int reviews;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const ExploreDoctorCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.specialty,
    required this.location,
    this.distanceKm,
    required this.rating,
    required this.reviews,
    required this.isFavorite,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkButton(
      onTap: onTap,
      padding: EdgeInsets.all(12.w),
      backgroundColor: Colors.white,
      borderRadius: 12.r,
      side: BorderSide(
        color: const Color(0xFFF3F4F6), // gray-100
        width: 0.5.w,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: Row(
        children: [
          // Doctor Image - Smaller size
          CustomCachedImage(
            imageUrl: imageUrl,
            width: 109.w,
            height: 109.h,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(12.r),
          ),

          SizedBox(width: 12.w),

          // Doctor Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Favorite
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          height: 1.2,
                          fontSize: 16.sp,
                          fontWeight: FontWeightM.bold,
                          color: const Color(0xFF1F2A37), // gray-800
                        ),
                      ),
                    ),
                    CustomInkButton(
                      onTap: onFavoriteTap,
                      backgroundColor: Colors.black.withValues(alpha: 0.06),
                      padding: EdgeInsets.all(5.w),
                      borderRadius: 99999,
                      child: SvgPicture.asset(
                        isFavorite ? SvgM.heart : SvgM.heartBorder,
                        width: 17.w,
                        height: 17.w,
                      ),
                    ),
                  ],
                ),

                8.verticalSpace,
                Divider(
                  height: 1.h,
                  color: const Color(0xFDE5E7EB),
                ),
                8.verticalSpace,

                // Specialty
                Text(
                  specialty,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    height: 1.1,
                    fontWeight: FontWeightM.semiBold,
                    color: const Color(0xFF4B5563),
                  ),
                ),

                SizedBox(height: 4.h),

                // Location & Distance
                Row(
                  children: [
                    SvgPicture.asset(
                      SvgM.pickLocation,
                      width: 12.w,
                      height: 12.w,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF4B5563), // gray-600
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        location,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          height: 1.2,
                          fontSize: 12.sp,
                          fontWeight: FontWeightM.regular,
                          color: const Color(0xFF4B5563), // gray-600
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

                SizedBox(height: 6.h),

                // Rating and Reviews
                Row(
                  children: [
                    // Single star with rating
                    SvgPicture.asset(
                      SvgM.star,
                      width: 10.w,
                      height: 10.h,
                      colorFilter: const ColorFilter.mode(
                        Colors.amber,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeightM.regular,
                        color: const Color(0xFF6B7280), // gray-500
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '|' +
                          ' ' +
                          reviews.formatCompact(startThreshold: 10000) +
                          ' ' +
                          Translation.reviews.tr,
                      style: TextStyle(
                        fontSize: 11.sp,
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
    );
  }
}
