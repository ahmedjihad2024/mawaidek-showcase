import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/data/responses/responses.dart' as app_responses;
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingLocationSection extends StatelessWidget {
  final app_responses.Booking booking;

  const BookingLocationSection({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final lat = double.tryParse(booking.provider.lat);
    final lng = double.tryParse(booking.provider.lng);

    if (lat == null || lng == null) return const SizedBox.shrink();

    final googleMapsWebUrl =
        'https://www.google.com/maps?q=$lat,$lng&z=13';
    final googleMapsAppUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Translation.location.tr,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeightM.semiBold,
            color: const Color(0xFF1F2A37),
            height: 1.5,
          ),
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: () async {
            if (await canLaunchUrl(googleMapsAppUrl)) {
              await launchUrl(
                googleMapsAppUrl,
                mode: LaunchMode.externalApplication,
              );
            } else {
              final fallbackUrl = Uri.parse(googleMapsWebUrl);
              if (await canLaunchUrl(fallbackUrl)) {
                await launchUrl(fallbackUrl);
              }
            }
          },
          child: Container(
            width: double.infinity,
            height: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        color: Colors.black.withOpacity(0.05),
                      ),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.open_in_new,
                                size: 16.w,
                                color: const Color(0xFF1C64F2),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                Translation.open_in_goole_map.tr,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeightM.medium,
                                  color: const Color(0xFF1C64F2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
