import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mawadk/presentation/common/ui_components/custom_cached_image.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/common/ui_components/rate_widget.dart';
import 'package:mawadk/presentation/common/utils/fast_function.dart';
import 'package:mawadk/presentation/res/assets_manager.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';

class ExploreClinicAndHospitalCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String type;
  final String location;
  final String? distanceKm;
  final double rating;
  final int reviews;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const ExploreClinicAndHospitalCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.type,
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
      backgroundColor: Colors.white,
      borderRadius: 8.r,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: Stack(
        children: [
          Column(
            children: [
              // Image
              CustomCachedImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: 121.h,
                fit: BoxFit.cover,
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Type
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
                              fontSize: 14.sp,
                              fontWeight: FontWeightM.bold,
                              color: const Color(0xFF4B5563), // gray-600
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              SvgM.hospital,
                              width: 16.w,
                              height: 16.w,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF9CA3AF), // gray-600
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              type,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeightM.regular,
                                color: const Color(0xFF9CA3AF), // gray-600
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    // Location & Distance
                    Row(
                      children: [
                        SvgPicture.asset(
                          SvgM.pickLocation,
                          width: 14.w,
                          height: 14.w,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF6B7280), // gray-500
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
                        SizedBox(width: 8.w),
                        // Single star rating
                        RateWidget(
                          readonly: true,
                          initialRate: rating,
                          size: 12.w,
                          spacing: .3.w,
                          activeColor: Color(0xFFFEB052),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '(' +
                              reviews.formatCompact(startThreshold: 10000) +
                              ' ' +
                              Translation.reviews.tr +
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

          // Favorite button
          Positioned(
            top: 8.h,
            right: 8.w,
            child: CustomInkButton(
              onTap: onFavoriteTap,
              backgroundColor: Colors.black.withValues(alpha: 0.06),
              padding: EdgeInsets.all(5.w),
              borderRadius: 99999,
              child: SvgPicture.asset(
                SvgM.heart,
                width: 20.w,
                height: 20.h,
                colorFilter: isFavorite
                    ? null
                    : ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
