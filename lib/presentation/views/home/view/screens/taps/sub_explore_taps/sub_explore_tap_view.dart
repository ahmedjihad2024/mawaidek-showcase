import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/app/extensions.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/presentation/common/ui_components/circular_progress_indicator.dart';
import 'package:mawadk/presentation/common/ui_components/customized_smart_refresh.dart';
import 'package:mawadk/presentation/common/ui_components/error_widget.dart';
import 'package:mawadk/presentation/common/utils/after_layout.dart';
import 'package:mawadk/presentation/common/utils/state_render.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';
import 'package:mawadk/presentation/views/home/view/widgets/explore_clinic_card.dart';
import 'package:mawadk/presentation/views/home/view/widgets/explore_doctor_card.dart';
import 'package:mawadk/presentation/res/routes_manager.dart';
import 'package:mawadk/presentation/views/home/view/widgets/filter_bottom_sheet.dart';

class SubExploreTapView extends StatefulWidget {
  final ProviderType exploreType;
  final HomeState state;
  const SubExploreTapView(
      {super.key, required this.exploreType, required this.state});

  @override
  State<SubExploreTapView> createState() => _SubExploreTapViewState();
}

class _SubExploreTapViewState extends State<SubExploreTapView>
    with AutomaticKeepAliveClientMixin, AfterLayout {
  ProviderType get exploreType => widget.exploreType;
  HomeState get state => widget.state;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScreenState.setState(
        reqState: state.reqStateForType,
        loading: () {
          return MyCircularProgressIndicator();
        },
        empty: () {
          return InkWell(
            onTap: () {
              context.read<HomeBloc>().add(GetProvidersEvent(
                  providerType: widget.exploreType,
                  search: context.read<HomeBloc>().oldSearch,
                  filter: state.filterDataForType,
                  isRefresh: false));
            },
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
                child: Text(
                  Translation.no_result_available.tr,
                  textAlign: TextAlign.center,
                  style: context.labelMedium.copyWith(
                    fontWeight: FontWeightM.medium,
                  ),
                ),
              ),
            ),
          );
        },
        error: () {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
            child: MyErrorWidget(
                onRetry: () {
                  context.read<HomeBloc>().add(GetProvidersEvent(
                      providerType: widget.exploreType,
                      search: context.read<HomeBloc>().oldSearch,
                      filter: state.filterDataForType,
                      isRefresh: true));
                },
                errorMessage: state.errorForType),
          );
        },
        online: () {
          List<Provider> providers = state.providersForType(widget.exploreType);
          return CustomizedSmartRefresh(
            controller: context.read<HomeBloc>().getTypeController(exploreType),
            enableLoading: true,
            onLoading: () {
              context.read<HomeBloc>().add(GetProvidersEvent(
                  providerType: widget.exploreType,
                  search: context.read<HomeBloc>().oldSearch,
                  filter: state.filterDataForType,
                  isRefresh: false));
            },
            onRefresh: () {
              context.read<HomeBloc>().add(GetProvidersEvent(
                  providerType: widget.exploreType,
                  search: context.read<HomeBloc>().oldSearch,
                  filter: state.filterDataForType,
                  isRefresh: true));
            },
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg) +
                  EdgeInsets.only(bottom: SizeM.pagePadding.dg, top: 5.h),
              itemCount: providers.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                return switch (exploreType) {
                  ProviderType.Doctor => ExploreDoctorCard(
                      imageUrl: providers[index].image,
                      name: providers[index].name,
                      specialty: providers[index].category?.name ?? "",
                      location: providers[index].address,
                      distanceKm: providers[index].distanceKm,
                      rating: double.parse(
                          providers[index].rating.toStringAsFixed(1)),
                      reviews: int.parse(providers[index].countRating),
                      isFavorite: providers[index].isFavorite,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          RoutesManager.services.route,
                          arguments: {
                            'exploreType': ProviderType.Doctor,
                            "provider-id": providers[index].id
                          },
                        );
                      },
                      onFavoriteTap: () {
                        context.read<HomeBloc>().add(
                            ToggleFavoriteEvent(provider: providers[index]));
                      },
                    ),
                  ProviderType.Clinic => ExploreClinicAndHospitalCard(
                      type: providers[index].type.tr,
                      imageUrl: providers[index].image,
                      name: providers[index].name,
                      location: providers[index].address,
                      distanceKm: providers[index].distanceKm,
                      rating: double.parse(
                          providers[index].rating.toStringAsFixed(1)),
                      reviews: int.parse(providers[index].countRating),
                      isFavorite: providers[index].isFavorite,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          RoutesManager.services.route,
                          arguments: {
                            'exploreType': ProviderType.Clinic,
                            "provider-id": providers[index].id
                          },
                        );
                      },
                      onFavoriteTap: () {
                        context.read<HomeBloc>().add(
                            ToggleFavoriteEvent(provider: providers[index]));
                      },
                    ),
                  ProviderType.Hospital => ExploreClinicAndHospitalCard(
                      type: providers[index].type.tr,
                      imageUrl: providers[index].image,
                      name: providers[index].name,
                      location: providers[index].address,
                      distanceKm: providers[index].distanceKm,
                      rating: double.parse(
                          providers[index].rating.toStringAsFixed(1)),
                      reviews: int.parse(providers[index].countRating),
                      isFavorite: providers[index].isFavorite,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          RoutesManager.services.route,
                          arguments: {
                            'exploreType': ProviderType.Hospital,
                            "provider-id": providers[index].id
                          },
                        );
                      },
                      onFavoriteTap: () {
                        context.read<HomeBloc>().add(
                            ToggleFavoriteEvent(provider: providers[index]));
                      },
                    ),
                };
              },
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> afterLayout(BuildContext context) async {
    context.read<HomeBloc>().add(GetProvidersEvent(
          filter: FilterData(),
          isRefresh: true,
          providerType: widget.exploreType,
        ));
  }
}
