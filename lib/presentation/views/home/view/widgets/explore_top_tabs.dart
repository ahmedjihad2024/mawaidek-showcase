import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/presentation/common/ui_components/animated_tap_bar.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';

class ExploreTopTabs extends StatelessWidget {
  final HomeState state;
  final CarouselSliderController carouselController;

  const ExploreTopTabs({
    super.key,
    required this.state,
    required this.carouselController,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      Translation.doctors.tr,
      Translation.clinics.tr,
      Translation.hospitals.tr,
    ];

    return Column(
      children: [
        // Animated Tabs Navigator
        AnimatedTapsNavigator(
          tabs: tabs,
          selectedTap: switch (state.selectedExploreTap) {
            ProviderType.Doctor => 0,
            ProviderType.Clinic => 1,
            ProviderType.Hospital => 2,
          },
          onTap: (index) {
            context.read<HomeBloc>().add(NavExploreTapEvent(
                    type: switch (index) {
                  0 => ProviderType.Doctor,
                  1 => ProviderType.Clinic,
                  2 => ProviderType.Hospital,
                  _ => ProviderType.Doctor,
                }));
            carouselController.animateToPage(
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
          stickTopMargin: 55.h - 3.h, // Position stick at bottom of container
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
        ),

        Divider(
          height: 1.h,
          color: const Color(0xFFE5E7EB), // gray-300
        ),
      ],
    );
  }
}
