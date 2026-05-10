import 'package:animated_visibility/animated_visibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';
import 'package:mawadk/presentation/views/home/view/widgets/filter_bottom_sheet.dart';

class ExploreFilterChips extends StatelessWidget {
  const ExploreFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final filterData = state.filterDataForType;

        final hasActiveFilters =
            (filterData.rating != null || filterData.nearestToMe);

        return AnimatedVisibility(
          visible: hasActiveFilters,
          enterDuration: const Duration(milliseconds: 300),
          exitDuration: const Duration(milliseconds: 300),
          enter: slideInHorizontally(
                initialOffsetX: -1,
                curve: Curves.fastEaseInToSlowEaseOut,
              ) +
              fadeIn(
                curve: Curves.fastEaseInToSlowEaseOut,
              ) +
              expandVertically(
                curve: Curves.fastEaseInToSlowEaseOut,
              ),
          exit: slideOutHorizontally(
                targetOffsetX: 1,
                curve: Curves.fastEaseInToSlowEaseOut,
              ) +
              fadeOut(
                curve: Curves.fastEaseInToSlowEaseOut,
              ) +
              shrinkVertically(
                curve: Curves.fastEaseInToSlowEaseOut,
              ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Clear all button
                CustomInkButton(
                  onTap: () {
                    context.read<HomeBloc>().add(GetProvidersEvent(
                        providerType: state.selectedExploreTap,
                        search: context.read<HomeBloc>().oldSearch,
                        filter: FilterData(),
                        isRefresh: true));
                  },
                  backgroundColor: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  borderRadius: 8.r,
                  side: BorderSide(
                    color: const Color(0xFFD1D5DB), // gray-300
                    width: 1.w,
                  ),
                  child: Text(
                    Translation.clear_all.tr,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeightM.medium,
                      color: const Color(0xFF3879D4), // Blue
                    ),
                  ),
                ),

                // Rating chip
                if (filterData!.rating != null) ...[
                  SizedBox(width: 12.w),
                  ExploreRatingChip(rating: filterData.rating!),
                ],

                // Nearest to Me chip
                if (filterData.nearestToMe) ...[
                  SizedBox(width: 12.w),
                  ExploreFilterChip(
                    label: Translation.nearest_to_me.tr,
                    onRemove: () {
                      final updatedFilter = FilterData(
                        rating: filterData.rating,
                        nearestToMe: false,
                      );
                      context.read<HomeBloc>().add(GetProvidersEvent(
                          providerType: state.selectedExploreTap,
                          search: context.read<HomeBloc>().oldSearch,
                          filter: updatedFilter,
                          isRefresh: true));
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class ExploreFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  
  const ExploreFilterChip({
    super.key,
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E5), // Orange Range
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeightM.medium,
              color: const Color(0xFF525A66), // Neutrals Gray 1
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 14.w,
              color: const Color(0xFF9CA3AF), // gray-400
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreRatingChip extends StatelessWidget {
  const ExploreRatingChip({
    super.key,
    required this.rating,
  });

  final int? rating;

  @override
  Widget build(BuildContext context) {
    var state = context.read<HomeBloc>().state;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E5), // Orange Range
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Translation.ratings.tr,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeightM.medium,
              color: const Color(0xFF525A66), // Neutrals Gray 1
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            '$rating+',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeightM.medium,
              color: const Color(0xFF3879D4), // Blue
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: () {
              final filterData = state.filterDataForType;
              final updatedFilter = FilterData(
                rating: null,
                nearestToMe: filterData.nearestToMe,
              );
              context.read<HomeBloc>().add(GetProvidersEvent(
                  providerType: state.selectedExploreTap,
                  search: context.read<HomeBloc>().oldSearch,
                  filter: updatedFilter,
                  isRefresh: true));
            },
            child: Icon(
              Icons.close,
              size: 14.w,
              color: const Color(0xFF9CA3AF), // gray-400
            ),
          ),
        ],
      ),
    );
  }
}
