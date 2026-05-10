import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mawadk/presentation/common/ui_components/custom_form_field/simple_form.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/res/assets_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';
import 'package:mawadk/presentation/views/home/view/widgets/filter_bottom_sheet.dart';

class ExploreSearchFilter extends StatelessWidget {
  final HomeState state;

  const ExploreSearchFilter({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      child: Column(
        children: [
          // Search and Filter Row
          Row(
            children: [
              // Search Bar
              Expanded(
                child: SimpleForm(
                  hintText: state.selectedExploreTap.tr,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  controller:
                      context.read<HomeBloc>().exploreSearchEditingController,
                  height: 40.w,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  backgroundColor: const Color(0xFFF3F4F6),
                  outlineBorder: false,
                  prefixWidget: SvgPicture.asset(
                    SvgM.searchNormal,
                    width: 24.w,
                    height: 24.w,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF9CA3AF), // gray-400
                      BlendMode.srcIn,
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      context.read<HomeBloc>().add(GetProvidersEvent(
                          providerType: state.selectedExploreTap,
                          search: value,
                          filter: state.filterDataForType,
                          isRefresh: true));
                    }
                  },
                  onChanged: (value) {
                    if (value.isEmpty) {
                      context.read<HomeBloc>().add(
                            ApplyFilterEvent(
                                filterData: state.filterDataForType,
                                isSearch: false),
                          );
                    }
                  },
                ),
              ),

              SizedBox(width: 16.w),

              // Filter Button
              CustomInkButton(
                onTap: () {
                  FilterBottomSheet.show(
                    context,
                    initialData: state.filterDataForType,
                    onFilterApplied: (filterData) {
                      context.read<HomeBloc>().add(GetProvidersEvent(
                          providerType: state.selectedExploreTap,
                          search: context.read<HomeBloc>().oldSearch,
                          filter: filterData,
                          isRefresh: true));
                    },
                  );
                },
                width: 40.w,
                height: 40.w,
                backgroundColor: const Color(0xFF3879D4),
                padding: EdgeInsets.all(12.w),
                borderRadius: 10.r,
                child: SvgPicture.asset(
                  SvgM.filter,
                  width: 16.w,
                  height: 9.w,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
