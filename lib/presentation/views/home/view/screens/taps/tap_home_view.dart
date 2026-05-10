import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/dependency_injection.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/app/services/app_preferences.dart';
import 'package:mawadk/presentation/common/ui_components/circular_progress_indicator.dart';
import 'package:mawadk/presentation/common/ui_components/customized_smart_refresh.dart';
import 'package:mawadk/presentation/common/ui_components/error_widget.dart';
import 'package:mawadk/presentation/common/utils/after_layout.dart';
import 'package:mawadk/presentation/common/utils/state_render.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';
import 'package:mawadk/presentation/views/home/view/widgets/categories_section.dart';
import 'package:mawadk/presentation/views/home/view/widgets/home_top_section.dart';
import 'package:mawadk/presentation/views/home/view/widgets/home_upcoming_appointments_section.dart';
import 'package:mawadk/presentation/views/home/view/widgets/home_view_app_bar.dart';
import 'package:mawadk/presentation/views/home/view/widgets/location_picker_bottom_sheet.dart';
import 'package:mawadk/presentation/views/home/view/widgets/nearby_medical_centers_section.dart';

class TapHomeView extends StatefulWidget {
  final double totalBottomNavHeight;
  const TapHomeView({super.key, required this.totalBottomNavHeight});

  @override
  State<TapHomeView> createState() => _TapHomeViewState();
}

class _TapHomeViewState extends State<TapHomeView>
    with AutomaticKeepAliveClientMixin, AfterLayout {
  double get totalBottomNavHeight => widget.totalBottomNavHeight;

  void selectLocation() {
    LocationPickerBottomSheet.show(
      context,
      onEnablePressed: () async {
        final position = await context.read<HomeBloc>().determinePosition();
        if (position == null) return true;
        final address =
            await context.read<HomeBloc>().getAddressFromLatLng(position);
        if (address != null) {
          debugPrint("😍 Address: $address");
          context.read<HomeBloc>().add(SetLocationCityEvent(
              locationAddress: address, position: position));
        }
        return true;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: CustomizedSmartRefresh(
              controller: context.read<HomeBloc>().refreshHomeController,
              onRefresh: () {
                context.read<HomeBloc>().add(HomeDataEvent());
                if (instance<AppPreferences>().isUserRegistered) {
                  context.read<HomeBloc>().add(GetBookingsEvent(
                        statusApp: BookingStatusApp.pending,
                        isRefresh: true,
                      ));
                }
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: totalBottomNavHeight),
                child: Column(
                  children: [
                    HomeViewAppBar(),
                    ScreenState.setState(
                        reqState: state.homeReqState,
                        loading: () {
                          return Padding(
                            padding: EdgeInsets.only(top: 50.w),
                            child: MyCircularProgressIndicator(),
                          );
                        },
                        error: () {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                    horizontal: SizeM.pagePadding.dg) +
                                EdgeInsets.only(top: 50.w),
                            child: MyErrorWidget(
                                onRetry: () {
                                  context.read<HomeBloc>().add(HomeDataEvent());
                                },
                                errorMessage: state.homeErrorState),
                          );
                        },
                        online: () {
                          return Column(
                            children: [
                              // Top Section
                              HomeTopSection(state: state, context: context),

                              // Upcoming Appointments Section (only for registered users)
                              if (instance<AppPreferences>().isUserRegistered)
                                HomeUpcomingAppointmentsSection(),

                              // Categories Section
                              CategoriesSection(),
                              SizedBox(height: 16.h),

                              // Nearby Medical Centers Section
                              NearbyMedicalCentersSection(),
                            ],
                          );
                        })
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> afterLayout(BuildContext context) async {
    if (!instance<AppPreferences>().isLocationSelected)
      selectLocation();
    else
      context.read<HomeBloc>().add(SetLocationCityEvent());

    context.read<HomeBloc>().add(HomeDataEvent());

    if (instance<AppPreferences>().isUserRegistered) {
      context.read<HomeBloc>().add(GetBookingsEvent(
            statusApp: BookingStatusApp.pending,
            isRefresh: true,
          ));
    }
  }
}
