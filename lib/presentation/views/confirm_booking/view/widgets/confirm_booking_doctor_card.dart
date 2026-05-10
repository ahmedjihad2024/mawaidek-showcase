import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/presentation/common/ui_components/custom_cached_image.dart';
import 'package:mawadk/presentation/res/assets_manager.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';

class ConfirmBookingDoctorCard extends StatelessWidget {
  final BookingConfirmData confirmData;
  final ProviderType providerType;
  final DateTime date;
  final String time;

  const ConfirmBookingDoctorCard({
    super.key,
    required this.confirmData,
    required this.providerType,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    dynamic providerDoctor = providerType.isDoctor
        ? confirmData.provider
        : confirmData.providerDoctor;
    final provider = confirmData.provider;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.02),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (providerDoctor != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCachedImage(
                  imageUrl: providerDoctor.image,
                  width: 91.w,
                  height: 91.w,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        providerDoctor.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeightM.semiBold,
                          color: const Color(0xFF1F2A37),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        height: 1.h,
                        width: double.infinity,
                        color: const Color(0xFFE5E7EB),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        providerDoctor.category.name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeightM.regular,
                          color: const Color(0xFF4B5563),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          if (providerDoctor.rating > 0) ...[
                            Row(
                              children: [
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
                                  providerDoctor.rating.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeightM.regular,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              height: 1.h,
              width: double.infinity,
              color: const Color(0xFFE5E7EB),
            ),
          ],
          SizedBox(height: 12.h),
          Text(
            Translation.scheduled_appointment.tr,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeightM.medium,
              color: const Color(0xFF1F2A37),
              height: 1.2,
            ),
          ),
          SizedBox(height: 12.h),
          _InfoRow(
            title: Translation.date.tr,
            value: DateFormat('MMMM d, y', context.locale.languageCode)
                .format(date),
          ),
          SizedBox(height: 10.h),
          _InfoRow(
            title: Translation.time.tr,
            value: time,
          ),
          if (!providerType.isDoctor) ...[
            SizedBox(height: 10.h),
            _InfoRow(
              title: confirmData.provider.type.isHospital
                  ? Translation.hospital.tr
                  : Translation.clinic.tr,
              value: provider.name,
            ),
          ],
          SizedBox(height: 10.h),
          _InfoRow(
            title: Translation.location.tr,
            value: provider.address,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeightM.regular,
              color: const Color(0xFF637D92),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeightM.medium,
            color: const Color(0xFF18273B),
          ),
        ),
      ],
    );
  }
}
