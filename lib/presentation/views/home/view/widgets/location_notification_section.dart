import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/res/assets_manager.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/routes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';

class LocationNotificationSection extends StatelessWidget {
  final void Function() selectLocation;
  const LocationNotificationSection({super.key, required this.selectLocation});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Location
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Translation.location.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeightM.regular,
                  color: const Color(0xFF6B7280), // gray-500
                ),
              ),
              SizedBox(height: 4.h),
              InkWell(
                onTap: selectLocation,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      SvgM.pickLocation,
                      width: 18.w,
                      height: 18.w, // gray-700
                    ),
                    SizedBox(width: 7.w),
                    Flexible(
                      child: Text(
                        (context.read<HomeBloc>().state.locationCity),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeightM.semiBold,
                          color: const Color(0xFF374151), // gray-700
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 14.w,
                      color: const Color(0xFF374151), // gray-700
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Notification
        CustomInkButton(
          onTap: () {
            Navigator.of(context).pushNamed(
              RoutesManager.notifications.route,
              arguments: {
                'on-review-submitted': (int bookingId) {
                  context.read<HomeBloc>().add(
                        UpdateBookingRatedEvent(
                          bookingId: bookingId,
                        ),
                      );
                },
                'on-booking-cancelled': (int bookingId) {
                  context.read<HomeBloc>().add(
                        CancelBookingUpdateEvent(
                          bookingId: bookingId,
                        ),
                      );
                },
              },
            );
          },
          padding: EdgeInsets.all(6.w),
          backgroundColor: const Color(0xFFF3F4F6), // gray-100
          borderRadius: 99999,
          child: Stack(
            children: [
              SvgPicture.asset(
                SvgM.notificationBing,
                width: 24.w,
                height: 24.w, // gray-700
              ),
              // Red dot indicator
              // Positioned(
              //   right: 0,
              //   top: 0,
              //   child: Container(
              //     width: 8.w,
              //     height: 8.w,
              //     decoration: const BoxDecoration(
              //       color: Color(0xFFEF4444), // red-500
              //       shape: BoxShape.circle,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
