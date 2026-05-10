import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/dependency_injection.dart';
import 'package:mawadk/app/services/app_preferences.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/home/view/widgets/bookings_content.dart';
import 'package:mawadk/presentation/views/home/view/widgets/bookings_top_tabs.dart';

import '../home_view.dart';

CarouselSliderController CAROUSE_SLIDER_CONTROLLER_BOOKINGS =
    CarouselSliderController();
ValueNotifier<int> SELECTED_TAP_INDEX_BOOKINGS = ValueNotifier(0);

class TapBookingsView extends StatefulWidget {
  final double totalBottomNavHeight;

  const TapBookingsView({super.key, required this.totalBottomNavHeight});

  @override
  State<TapBookingsView> createState() => _TapBookingsViewState();
}

class _TapBookingsViewState extends State<TapBookingsView>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SELECTED_TAP_INDEX_BOOKINGS = ValueNotifier(0);
    CAROUSE_SLIDER_CONTROLLER_BOOKINGS = CarouselSliderController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: widget.totalBottomNavHeight),
          child: Column(
            children: [
              16.verticalSpace,
              _buildBookingsTitle(),
              if (instance<AppPreferences>().isUserRegistered) ...[
                16.verticalSpace,

                // Top Navigation Tabs
                const BookingsTopTabs(),

                24.verticalSpace,

                // Content based on selected tab
                const BookingsContent(),
              ] else ...[
                Expanded(child: RequestLoginWidget())
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      child: Column(
        children: [
          Text(
            Translation.my_booking.tr,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeightM.semiBold,
              color: const Color(0xFF1C2A3A), // Dark Teal
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

