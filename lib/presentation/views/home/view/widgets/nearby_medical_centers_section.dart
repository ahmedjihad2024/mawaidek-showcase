import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/routes_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';
import 'package:mawadk/presentation/views/home/view/widgets/medical_center_card.dart';

class NearbyMedicalCentersSection extends StatelessWidget {
  const NearbyMedicalCentersSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomeState state = context.read<HomeBloc>().state;

    return Column(
      children: [
        // Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Translation.nearby_medical_centers.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeightM.bold,
                  color: const Color(0xFF1C2A3A), // Dark Teal
                ),
              ),
              CustomInkButton(
                onTap: () {
                  // Navigate to nearby medical centers page
                  Navigator.of(context)
                      .pushNamed(RoutesManager.nearbyMedicalCenters.route);
                },
                child: Text(
                  Translation.see_all.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeightM.medium,
                    color: const Color(0xFF6B7280), // gray-500
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 10.h),
        // Cards
        SizedBox(
          height: 250.h + SizeM.pagePadding.dg,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg) +
                EdgeInsets.only(bottom: SizeM.pagePadding.dg),
            physics: const BouncingScrollPhysics(),
            itemCount: state.homeData!.nearby.length,
            separatorBuilder: (context, index) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              Provider provider = state.homeData!.nearby[index];
              return MedicalCenterCard(
                image: provider.image,
                title: provider.name,
                address: provider.address,
                distanceKm: provider.distanceKm,
                rating: double.parse(provider.rating.toStringAsFixed(2)),
                reviews: int.parse(provider.countRating),
                type: provider.type.isHospital
                    ? Translation.hospital.tr
                    : Translation.clinic.tr,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    RoutesManager.services.route,
                    arguments: {
                      'exploreType': provider.type,
                      "provider-id": provider.id
                    },
                  );
                },
                onFavoriteTap: () {
                  context
                      .read<HomeBloc>()
                      .add(ToggleFavoriteEvent(provider: provider));
                },
                isFavorite: provider.isFavorite,
              );
            },
          ),
        ),
      ],
    );
  }
}
