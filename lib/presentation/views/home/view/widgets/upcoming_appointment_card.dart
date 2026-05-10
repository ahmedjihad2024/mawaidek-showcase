import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mawadk/presentation/common/ui_components/custom_cached_image.dart';
import 'package:mawadk/presentation/res/assets_manager.dart';
import 'package:mawadk/presentation/res/color_manager.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';

class UpcomingAppointmentCard extends StatelessWidget {
  final String imageUrl;
  final String doctorName;
  final String specialty;
  final String location;
  final DateTime date;
  final VoidCallback? onTap;
  final bool isFirst;

  const UpcomingAppointmentCard({
    super.key,
    required this.imageUrl,
    required this.doctorName,
    required this.specialty,
    required this.location,
    required this.date,
    this.onTap,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final difference = dateOnly.difference(today).inDays;

    final String dateLabel;
    if (difference == 0) {
      dateLabel = Translation.today.tr;
    } else if (difference == 1) {
      dateLabel = Translation.tomorrow.tr;
    } else {
      dateLabel = DateFormat('EEE, MMM d', locale).format(date);
    }

    final String timeLabel = DateFormat('hh:mm a', locale).format(date);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: isFirst
              ? Border.all(
                  color: ColorM.primary.withValues(alpha: 0.12), width: 1.2)
              : Border.all(
                  color: Colors.grey.withValues(alpha: 0.12), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: ColorM.primary.withValues(alpha: isFirst ? 0.06 : 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left accent bar
            Container(
              width: 3.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: isFirst
                    ? ColorM.primary
                    : ColorM.primary.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 10.w),

            // Doctor avatar
            CustomCachedImage(
              imageUrl: imageUrl,
              width: 40.w,
              height: 40.w,
              isCircle: true,
            ),
            SizedBox(width: 10.w),

            // Doctor info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Row 1: Name
                  Text(
                    doctorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeightM.bold,
                      color: ColorM.primary,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Row 2: Specialty + Location inline
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          specialty,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeightM.medium,
                            color: const Color(0xFF6B7280),
                            height: 1.2,
                          ),
                        ),
                      ),
                      if (location.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            '·',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeightM.bold,
                              color: const Color(0xFFD1D5DB),
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          SvgM.pickLocationBorder,
                          width: 10.w,
                          height: 10.w,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF9CA3AF),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Flexible(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeightM.regular,
                              color: const Color(0xFF9CA3AF),
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),

            // Date & Time column on the right
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Date
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      SvgM.calendar,
                      width: 12.w,
                      height: 12.w,
                      colorFilter: ColorFilter.mode(
                        ColorM.primary.withValues(alpha: 0.6),
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      dateLabel,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeightM.semiBold,
                        color: ColorM.primary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                // Time
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 12.w,
                      color: ColorM.primary.withValues(alpha: 0.6),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      timeLabel,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeightM.semiBold,
                        color: ColorM.primary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(width: 4.w),

            // Arrow
            Icon(
              Icons.chevron_right_rounded,
              size: 18.w,
              color: const Color(0xFFD1D5DB),
            ),
          ],
        ),
      ),
    );
  }
}
