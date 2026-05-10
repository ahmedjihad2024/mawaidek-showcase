import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mawadk/presentation/common/ui_components/double_back_to_exit.dart';
import 'package:mawadk/presentation/common/utils/after_layout.dart';
import 'package:mawadk/presentation/res/assets_manager.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';
import 'package:mawadk/presentation/views/home/view/screens/taps/profile_tab_view.dart';
import 'package:mawadk/presentation/views/home/view/widgets/figma_bottom_nav_bar.dart';

import '../../../../../app/extensions.dart';
import '../../../../../app/services/firebase_messeging_services.dart';
import '../../../../common/ui_components/custom_ink_button.dart';
import '../../../../res/fonts_manager.dart';
import '../../../../res/routes_manager.dart';
import '../../../../res/sizes_manager.dart';
import '../../../../res/translations_manager.dart';
import 'taps/tap_home_view.dart';
import 'package:mawadk/presentation/views/home/view/screens/taps/tap_explore_view.dart';
import 'package:mawadk/presentation/views/home/view/screens/taps/tap_bookings_view.dart';
import 'package:mawadk/presentation/views/ai_chat/view/widgets/floating_assistant_button.dart';

class HomeTapsControllers {
  static ValueNotifier<int> BOTTOM_NAV_BAR_SELECTED_TAB = ValueNotifier(0);
  static CarouselSliderController BOTTOM_NAV_BAR_SLIDER_CONTROLLER =
      CarouselSliderController();
}

class BookingTapControllers {
  static ValueNotifier<int> selectedTap = ValueNotifier(0);
  static CarouselSliderController BOTTOM_NAV_BAR_SLIDER_CONTROLLER =
      CarouselSliderController();
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static HomeBloc? homeBloc;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin, AfterLayout {
  final double navHeight = 76.h;

  late List<BottomNavItem> bottomNavItems;

  @override
  void initState() {
    HomeTapsControllers.BOTTOM_NAV_BAR_SELECTED_TAB.value =
        0; // Start with Home
    HomeTapsControllers.BOTTOM_NAV_BAR_SLIDER_CONTROLLER =
        CarouselSliderController();

    BookingTapControllers.selectedTap.value = 0;
    BookingTapControllers.BOTTOM_NAV_BAR_SLIDER_CONTROLLER =
        CarouselSliderController();

    bottomNavItems = [
      BottomNavItem(
          title: Translation.home.tr,
          svgPath: SvgM.homeBorder,
          selectedSvgPath: SvgM.home),
      BottomNavItem(
          title: Translation.discover.tr,
          svgPath: SvgM.discoverBorder,
          selectedSvgPath: SvgM.discover),
      BottomNavItem(
          title: Translation.my_booking.tr,
          svgPath: SvgM.calendar2Border,
          selectedSvgPath: SvgM.calendar2),
      BottomNavItem(
          title: Translation.profile.tr,
          svgPath: SvgM.profileBorder,
          selectedSvgPath: SvgM.profile),
    ];
    super.initState();
  }

  @override
  void dispose() {
    HomeView.homeBloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DoubleBackToExitWidget(
      message: Translation.press_back_again_to_exit.tr,
      child: Scaffold(
        body: Stack(
          children: [
            // page view
            Align(
              alignment: Alignment.center,
              child: CarouselSlider(
                items: [
                  // Home (Figma Home)
                  TapHomeView(totalBottomNavHeight: navHeight),
                  // Explore (Figma Explore)
                  TapExploreView(totalBottomNavHeight: navHeight),
                  // Booking (Figma Booking)
                  TapBookingsView(totalBottomNavHeight: navHeight),

                  ProfileTabView(totalBottomNavHeight: navHeight),
                ],
                options: CarouselOptions(
                  initialPage: 0, // Start with Home
                  viewportFraction: 1,
                  aspectRatio: 1,
                  height: double.infinity,
                  enableInfiniteScroll: false,
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  padEnds: false,
                  animateToClosest: false,
                  onPageChanged: (tapIndex, carouselPageChangedReason) {
                    // Only handle programmatic page changes, ignore manual swipes
                    if (carouselPageChangedReason ==
                        CarouselPageChangedReason.manual) {
                      // Prevent manual swiping by not updating the selected tab
                      // This effectively disables swipe navigation
                      return;
                    }
                  },
                ),
                carouselController:
                    HomeTapsControllers.BOTTOM_NAV_BAR_SLIDER_CONTROLLER,
              ),
            ),

            // AI Assistant floating button (home + explore tabs only)
            ValueListenableBuilder<int>(
              valueListenable:
                  HomeTapsControllers.BOTTOM_NAV_BAR_SELECTED_TAB,
              builder: (context, tabIndex, _) {
                final showOnTab = tabIndex == 0 || tabIndex == 1;
                if (!showOnTab) return const SizedBox.shrink();
                return FloatingAssistantButton(bottomOffset: navHeight);
              },
            ),

            // bottom navigation bar
            SafeArea(
              bottom: false,
              child: FigmaBottomNavBar(
                hight: navHeight,
                selectedIndex: HomeTapsControllers.BOTTOM_NAV_BAR_SELECTED_TAB,
                items: bottomNavItems,
                onTap: (tapIndex) {
                  HomeTapsControllers.BOTTOM_NAV_BAR_SELECTED_TAB.value =
                      tapIndex;
                  HomeTapsControllers.BOTTOM_NAV_BAR_SLIDER_CONTROLLER
                      .animateToPage(
                    tapIndex,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.fastLinearToSlowEaseIn,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> afterLayout(BuildContext context) async {
    HomeView.homeBloc = context.read<HomeBloc>();
    await FirebaseMessegingServices.instance
        .handleInitialMessageAndMessageTapped();
  }
}

class RequestLoginWidget extends StatelessWidget {
  const RequestLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeM.pagePadding.dg,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10.w,
          children: [
            Text(
              Translation.please_login_first.tr,
              style: context.labelLarge.copyWith(color: Color(0xFF448E29)),
            ),
            CustomInkButton(
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    RoutesManager.signIn.route, (_) => false);
              },
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 5.w),
              backgroundColor: Color(0xFF448E29),
              smoothness: 1,
              child: Text(
                Translation.login.tr,
                style: context.labelLarge.copyWith(
                  fontWeight: FontWeightM.regular,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
