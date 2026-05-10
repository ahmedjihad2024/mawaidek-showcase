import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/presentation/res/routes_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';
import 'package:mawadk/presentation/views/home/view/widgets/home_search_bar.dart';
import 'package:mawadk/presentation/views/home/view/widgets/location_notification_section.dart';
import 'package:mawadk/presentation/views/home/view/widgets/location_picker_bottom_sheet.dart';

class HomeViewAppBar extends StatelessWidget {
  const HomeViewAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Location & Notification
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
          child: LocationNotificationSection(selectLocation: () {
            LocationPickerBottomSheet.show(
              context,
              onEnablePressed: () async {
                final position =
                    await context.read<HomeBloc>().determinePosition();
                if (position == null) return true;
                final address = await context
                    .read<HomeBloc>()
                    .getAddressFromLatLng(position);
                if (address != null) {
                  debugPrint("😍 Address: $address");
                  context.read<HomeBloc>().add(SetLocationCityEvent(
                      locationAddress: address, position: position));
                }
                return true;
              },
            );
          }),
        ),
        SizedBox(height: 14.h),

        /*
        // Search Bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
          child: HomeSearchBar(
            label: Translation.search_doctor.tr,
            onTap: () async {
              Navigator.of(context).pushNamed(
                RoutesManager.search.route,
                arguments: {'exploreType': ProviderType.Doctor},
              );
            },
          ),
        ),
        */
      ],
    );
  }
}
