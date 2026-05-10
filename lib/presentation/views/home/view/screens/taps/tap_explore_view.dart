import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/presentation/common/utils/after_layout.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';
import 'package:mawadk/presentation/views/home/view/widgets/explore_content.dart';
import 'package:mawadk/presentation/views/home/view/widgets/explore_filter_chips.dart';
import 'package:mawadk/presentation/views/home/view/widgets/explore_search_filter.dart';
import 'package:mawadk/presentation/views/home/view/widgets/explore_top_tabs.dart';

class TapExploreView extends StatefulWidget {
  final double totalBottomNavHeight;

  const TapExploreView({super.key, required this.totalBottomNavHeight});

  @override
  State<TapExploreView> createState() => _TapExploreViewState();
}

class _TapExploreViewState extends State<TapExploreView>
    with AutomaticKeepAliveClientMixin, AfterLayout {
  final TextEditingController _searchController = TextEditingController();
  final CarouselSliderController _carouselSliderController =
      CarouselSliderController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  HomeState get state => context.read<HomeBloc>().state;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: widget.totalBottomNavHeight),
              child: Column(
                children: [
                  16.verticalSpace,
                  // Explore Title
                  _buildExploreTitle(),

                  16.verticalSpace,

                  // Top Navigation Tabs
                  ExploreTopTabs(
                    state: state,
                    carouselController: _carouselSliderController,
                  ),

                  SizedBox(height: 24.h),

                  // Search and Filter Section
                  ExploreSearchFilter(state: state),
                  SizedBox(height: 10.h),

                  // Filter Chips
                  const ExploreFilterChips(),

                  10.verticalSpace,

                  // Content based on selected tab
                  ExploreViewContent(
                      carouselSliderController: _carouselSliderController),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExploreTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      child: Column(
        children: [
          Text(
            Translation.explore.tr,
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

  @override
  Future<void> afterLayout(BuildContext context) async {}
}

