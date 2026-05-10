import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/common/ui_components/default_app_bar.dart';
import 'package:mawadk/presentation/common/ui_components/circular_progress_indicator.dart';
import 'package:mawadk/presentation/common/ui_components/error_widget.dart';
import 'package:mawadk/presentation/common/utils/state_render.dart';
import 'package:mawadk/presentation/res/color_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/assets_manager.dart';
import 'package:mawadk/presentation/views/services/view/widgets/department_card.dart';
import 'package:mawadk/presentation/views/services/bloc/services_bloc.dart';
import 'package:mawadk/presentation/views/services/view/widgets/services_sections.dart';

class ServicesView extends StatefulWidget {
  final ProviderType exploreType;
  final int providerId;

  const ServicesView(
      {super.key, required this.exploreType, required this.providerId});

  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
  ProviderType get exploreType => widget.exploreType;
  int get providerId => widget.providerId;

  bool _isExpanded = false;
  bool _isAboutExpanded = false;

  ServicesState get state => context.read<ServicesBloc>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<ServicesBloc, ServicesState>(
          builder: (context, state) {
            return Column(
              children: [
                // Custom App Bar
                _buildCustomAppBar(),

                24.verticalSpace,

                // Content
                Expanded(
                  child: ScreenState.setState(
                    reqState: state.reqState,
                    loading: () {
                      return const Center(child: MyCircularProgressIndicator());
                    },
                    error: () {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeM.pagePadding.dg,
                        ),
                        child: MyErrorWidget(
                          onRetry: () {
                            context.read<ServicesBloc>().add(
                                  GetProviderShowEvent(providerId: providerId),
                                );
                          },
                          errorMessage: state.errorState,
                        ),
                      );
                    },
                    online: () {
                      return _buildContent();
                    },
                  ),
                ),

                // Bottom Button
                if (state.reqState.isSuccess)
                  ServicesBottomBar(
                    state: state,
                    exploreType: exploreType,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return DefaultAppBar(
        title: exploreType.tr,
        backFunction: () => Navigator.of(context).pop(),
        actionButtons: [
          CustomInkButton(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.all(5.w),
            borderRadius: 5.r,
            onTap: () {
              if (state.providerData != null) {
                context.read<ServicesBloc>().add(ToggleFavoriteEvent());
              }
            },
            child: SvgPicture.asset(
              (state.providerData?.provider.isFavorite ?? false)
                  ? SvgM.heart
                  : SvgM.heartBorder,
              width: 17.w,
              height: 17.w,
              colorFilter: ColorFilter.mode(
                ColorM.primary.withValues(
                    alpha: (state.providerData?.provider.isFavorite ?? false)
                        ? 1
                        : .5),
                BlendMode.srcIn,
              ),
            ),
          )
        ]);
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Content Card
          ServicesMainCard(state: state, exploreType: exploreType),

          SizedBox(height: 24.h),

          // Stats Tabs
          ServicesStatsTabs(state: state, exploreType: exploreType),

          SizedBox(height: 24.h),

          if (exploreType.isDoctor) ...[
            // Categories Section
            ServicesCategories(state: state),

            SizedBox(height: 24.h),
          ],

          if (exploreType.isHospital || exploreType.isClinic) ...[
            // Categories Section
            _buildSelectDepartment(),

            SizedBox(height: 24.h),
          ],

          // About Me Section
          ServicesAboutMe(
            state: state,
            isExpanded: _isAboutExpanded,
            onToggle: () {
              setState(() {
                _isAboutExpanded = !_isAboutExpanded;
              });
            },
          ),

          SizedBox(height: 24.h),

          // Location Section
          ServicesLocation(state: state),

          SizedBox(height: 24.h),

          // Working Time Section
          ServicesWorkingTime(state: state),

          SizedBox(height: 24.h),

          // Reviews Section
          ServicesReviews(state: state),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildSelectDepartment() {
    final categories = state.providerData?.categories ?? [];
    if (categories.isEmpty) return const SizedBox.shrink();

    final shouldShowButton = categories.length > 3;
    final displayCount = _isExpanded
        ? categories.length
        : (categories.length > 3 ? 3 : categories.length);
    final displayedCategories = categories.take(displayCount).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      child: Column(
        spacing: 8.w,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Translation.select_department.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeightM.bold,
                  color: const Color(0xFF1C2A3A), // Dark Teal
                ),
              ),
              if (shouldShowButton)
                CustomInkButton(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Text(
                    _isExpanded
                        ? Translation.see_less.tr
                        : Translation.see_all.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeightM.medium,
                      color: const Color(0xFF6B7280), // gray-500
                    ),
                  ),
                ),
            ],
          ),
          GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: displayedCategories.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8.w,
                crossAxisSpacing: 12.w,
              ),
              itemBuilder: (con, index) {
                final category = displayedCategories[index];
                final isSelected = state.selectedCategory?.id == category.id;
                return DepartmentCard(
                  title: category.name,
                  doctorsCount: category.doctorsCount,
                  imageUrl: category.image,
                  isSelected: isSelected,
                  onTap: () {
                    context.read<ServicesBloc>().add(
                          SelectDepartmentEvent(category),
                        );
                  },
                );
              }),
        ],
      ),
    );
  }
}
