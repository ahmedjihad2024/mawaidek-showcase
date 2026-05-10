import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mawadk/presentation/common/ui_components/custom_cached_image.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/res/assets_manager.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';

class AvailableDoctorsCard extends StatelessWidget {
  final VoidCallback onTap;
  final String imageUrl;
  final String name;
  final String specialty;
  final double rating;
  final double price;
  final int experienceInYears;
  final bool isSelected;

  const AvailableDoctorsCard(
      {super.key,
      required this.onTap,
      required this.imageUrl,
      required this.name,
      required this.specialty,
      required this.rating,
      required this.price,
      required this.experienceInYears,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return CustomInkButton(
      onTap: onTap,
      padding: EdgeInsets.all(12.w),
      backgroundColor: Colors.white,
      borderRadius: 12.r,
      side: BorderSide(
        color: Colors.black.withValues(alpha: .05), // gray-100
        width: 1.w,
      ),
      child: Row(
        children: [
          // Doctor Image - Smaller size
          CustomCachedImage(
            imageUrl: imageUrl,
            width: 91.w,
            height: 91.w,
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
                          fontWeight: FontWeightM.semiBold,
                          color: const Color(0xFF1F2A37), // gray-800
                        ),
                      ),
                    ),
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: isSelected
                              ? null
                              : Border.all(
                                  width: 1.w,
                                  color: Colors.black.withValues(alpha: .2)),
                          color: isSelected
                              ? Color.fromRGBO(41, 34, 48, 1)
                              : Colors.transparent),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              size: 14.w,
                              color: Colors.white,
                            )
                          : null,
                    )
                  ],
                ),

                8.verticalSpace,
                Divider(
                  height: 1.h,
                  color: const Color(0xFDE5E7EB),
                  endIndent: 90.w,
                ),
                8.verticalSpace,

                // Specialty
                Text(
                  specialty,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.1,
                    fontWeight: FontWeightM.regular,
                    color: const Color(0xFF4B5563),
                  ),
                ),

                SizedBox(height: 4.h),

                // Rating and Reviews
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Single star with rating
                        SvgPicture.asset(
                          SvgM.star,
                          width: 15.w,
                          height: 15.w,
                          colorFilter: const ColorFilter.mode(
                            Colors.amber,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          rating.toString(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeightM.regular,
                            color: const Color(0xFF6B7280), // gray-500
                          ),
                        ),
                        Text(
                          " | ${Translation.experience_count.trNamed({
                                'count': experienceInYears.toString()
                              })}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeightM.regular,
                            color: const Color(0xFF6B7280), // gray-500
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 1.w,),
                    Flexible(
                      child: FittedBox(
                        child: Text(
                          Translation.price_qar.trNamed({'price': price.toString()}),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeightM.semiBold,
                            color: Color.fromRGBO(36, 101, 176, 1), // gray-500
                          ),
                        ),
                      ),
                    )
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
