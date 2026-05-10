import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/presentation/common/ui_components/animated_tap_bar.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/home/view/screens/taps/tap_bookings_view.dart';

class BookingsTopTabs extends StatelessWidget {
  const BookingsTopTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      Translation.upcoming.tr,
      Translation.completed.tr,
      Translation.cancelled.tr,
    ];

    return Column(
      children: [
        // Animated Tabs Navigator
        ValueListenableBuilder(
            valueListenable: SELECTED_TAP_INDEX_BOOKINGS,
            builder: (context, value, _) {
              return AnimatedTapsNavigator(
                tabs: tabs,
                selectedTap: value,
                onTap: (index) {
                  SELECTED_TAP_INDEX_BOOKINGS.value = index;
                  CAROUSE_SLIDER_CONTROLLER_BOOKINGS.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.fastLinearToSlowEaseIn,
                  );
                },
                margin: 0,
                padding: 0,
                isStickStyle: true,
                stickHeight: 3.h,
                stickWidth: 83.w,
                stickTopMargin:
                    55.h - 3.h, // Position stick at bottom of container
                isStickAtTop: false,
                containerHeight: 55.h,
                backgroundColor: Colors.transparent,
                borderColor: Colors.transparent,
                borderWidth: 0,
                activeTextColor: const Color(0xFF1C2A3A), // Dark Teal
                inactiveTextColor: const Color(0xFF9CA3AF), // gray-400
                fontSize: 16.sp,
                borderRadius: 0,
                fontWeight: FontWeightM.semiBold,
                stickColor: const Color(0xFF1C2A3A), // Dark Teal
                stickBorderRadius: 50.r,
                animationDuration: const Duration(milliseconds: 300),
                animationCurve: Curves.easeInOut,
              );
            }),

        Divider(
          height: 1.h,
          color: const Color(0xFFE5E7EB), // gray-300
        ),
      ],
    );
  }
}
