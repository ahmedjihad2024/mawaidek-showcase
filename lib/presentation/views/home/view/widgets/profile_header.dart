import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mawadk/presentation/common/ui_components/custom_cached_image.dart';
import 'package:mawadk/presentation/res/assets_manager.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/routes_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';

class ProfileHeader extends StatelessWidget {
  final HomeState state;

  const ProfileHeader({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      child: Column(
        children: [
          Text(
            Translation.profile.tr,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeightM.semiBold,
              color: const Color(0xFF1C2A3A), // Dark Teal
            ),
          ),
          32.verticalSpace,
          Stack(
            children: [
              if (state.image == null)
                SvgPicture.asset(
                  SvgM.personCover,
                  width: 168.w,
                  height: 168.w,
                )
              else
                CustomCachedImage(
                  imageUrl: state.image!,
                  width: 168.w,
                  height: 168.w,
                  borderRadius: BorderRadius.circular(99999),
                ),

              // Edit button
              Positioned(
                right: 10.w,
                bottom: 10.w,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(RoutesManager.editProfile.route).then((_){
                          context.read<HomeBloc>().add(HandleUserDateEvent());
                    });
                  },
                  child: Container(
                    width: 34.w,
                    height: 34.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C2A3A),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(13.r),
                        bottomRight: Radius.circular(13.r),
                        topLeft: Radius.circular(13.r),
                        bottomLeft: Radius.circular(4.r),
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        SvgM.pen,
                        width: 18.w,
                        height: 18.h,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // User info
          Text(
            state.name ?? "NONE",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeightM.bold,
              color: const Color(0xFF1F2A37),
              height: 1.5,
            ),
          ),

          SizedBox(height: 4.h),

          Text(
            state.phoneNumber == null ? "NONE" : "+974-${state.phoneNumber}",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeightM.regular,
              color: const Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
