import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mawadk/app/dependency_injection.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/app/services/app_preferences.dart';
import 'package:mawadk/presentation/common/ui_components/custom_cached_image.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/common/utils/snackbar_helper.dart';
import 'package:mawadk/presentation/res/assets_manager.dart';
import 'package:mawadk/presentation/res/color_manager.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/routes_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/home/view/widgets/category_item.dart';
import 'package:mawadk/presentation/views/reviews/view/widgets/review_card.dart';
import 'package:mawadk/presentation/views/services/bloc/services_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicesMainCard extends StatelessWidget {
  final ServicesState state;
  final ProviderType exploreType;

  const ServicesMainCard({
    super.key,
    required this.state,
    required this.exploreType,
  });

  @override
  Widget build(BuildContext context) {
    final provider = state.providerData?.provider;
    if (provider == null) return const SizedBox.shrink();

    if (exploreType == ProviderType.Doctor) {
      return GestureDetector(
        onTap: () {},
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          margin: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CustomCachedImage(
                width: 109.w,
                height: 109.w,
                imageUrl: provider.image,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(12.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeightM.bold,
                        color: const Color(0xFF1F2A37),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: const Color(0xFFE5E7EB),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      state.providerData?.provider.categories
                              ?.map((e) => e.name)
                              .join(', ') ??
                          "",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeightM.semiBold,
                        color: const Color(0xFF4B5563),
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        SvgPicture.asset(
                          SvgM.pickLocation,
                          width: 14.w,
                          height: 14.w,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF4B5563),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            provider.address,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeightM.regular,
                              color: const Color(0xFF4B5563),
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCachedImage(
                width: double.infinity,
                height: 143.h,
                imageUrl: provider.image,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(12.r),
              ),
              SizedBox(height: 16.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeightM.bold,
                      color: const Color(0xFF1F2A37),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      SvgPicture.asset(
                        SvgM.pickLocation,
                        width: 14.w,
                        height: 14.w,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF4B5563),
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          provider.address,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeightM.regular,
                            color: const Color(0xFF4B5563),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}

class ServicesStatsTabs extends StatelessWidget {
  final ServicesState state;
  final ProviderType exploreType;

  const ServicesStatsTabs({
    super.key,
    required this.state,
    required this.exploreType,
  });

  @override
  Widget build(BuildContext context) {
    final provider = state.providerData?.provider;
    if (provider == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatTab(
            icon: SvgM.profile2user,
            value: exploreType == ProviderType.Doctor
                ? '${provider.clients}+'
                : '${provider.countDoctors}+',
            label: exploreType == ProviderType.Doctor
                ? Translation.patients.tr
                : Translation.doctors.tr,
            iconBgColor: const Color(0xFFF3F4F6),
            iconColor: const Color(0xFF4B5563),
          ),
          _buildStatTab(
            icon: SvgM.medal,
            value: '${provider.experienceYears}+',
            label: Translation.experience.tr,
            iconBgColor: const Color(0xFFF3F4F6),
            iconColor: const Color(0xFF4B5563),
          ),
          _buildStatTab(
            icon: SvgM.star,
            value: provider.rating.toStringAsFixed(1),
            label: Translation.rating.tr,
            iconBgColor: const Color(0xFFF3F4F6),
            iconColor: const Color(0xFF4B5563),
          ),
          _buildStatTab(
            icon: SvgM.messages,
            value: provider.countRating,
            label: Translation.reviews.tr,
            iconBgColor: const Color(0xFFF3F4F6),
            iconColor: const Color(0xFF4B5563),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTab({
    required String icon,
    required String value,
    required String label,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(56.r),
          ),
          child: Center(
            child: SvgPicture.asset(
              icon,
              width: 24.w,
              height: 24.w,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeightM.semiBold,
            color: const Color(0xFF4B5563),
            height: 1.5,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeightM.regular,
            color: const Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class ServicesAboutMe extends StatelessWidget {
  final ServicesState state;
  final bool isExpanded;
  final VoidCallback onToggle;

  const ServicesAboutMe({
    super.key,
    required this.state,
    required this.isExpanded,
    required this.onToggle,
  });

  String _getFullAboutText() {
    final provider = state.providerData?.provider;
    if (provider?.description != null && provider!.description.isNotEmpty) {
      return provider.description;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Translation.about_me.tr,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeightM.semiBold,
              color: const Color(0xFF1F2A37),
              height: 1.5,
            ),
          ),
          SizedBox(height: 6.h),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: RichText(
                textScaler: MediaQuery.of(context).textScaler,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _getFullAboutText()
                          .substring(0, min(100, _getFullAboutText().length)),
                      style: TextStyle(
                        color: const Color(0xFF6B7280),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: Translation.view_more.tr,
                      style: TextStyle(
                        color: ColorM.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = onToggle,
                    )
                  ],
                )),
            secondChild: RichText(
                textScaler: MediaQuery.of(context).textScaler,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _getFullAboutText(),
                      style: TextStyle(
                        color: const Color(0xFF6B7280),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: Translation.view_less.tr,
                      style: TextStyle(
                        color: ColorM.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = onToggle,
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class ServicesLocation extends StatelessWidget {
  final ServicesState state;

  const ServicesLocation({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final provider = state.providerData?.provider;
    if (provider == null) return const SizedBox.shrink();

    final lat = double.tryParse(provider.lat);
    final lng = double.tryParse(provider.lng);

    if (lat == null || lng == null) return const SizedBox.shrink();

    final googleMapsWebUrl = 'https://www.google.com/maps?q=$lat,$lng&z=13';
    final googleMapsAppUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Translation.location.tr,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeightM.semiBold,
              color: const Color(0xFF1F2A37),
              height: 1.5,
            ),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () async {
              if (await canLaunchUrl(googleMapsAppUrl)) {
                await launchUrl(
                  googleMapsAppUrl,
                  mode: LaunchMode.externalApplication,
                );
              } else {
                final fallbackUrl = Uri.parse(googleMapsWebUrl);
                if (await canLaunchUrl(fallbackUrl)) {
                  await launchUrl(fallbackUrl);
                }
              }
            },
            child: Container(
              width: double.infinity,
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.r),
                          color: Colors.black.withOpacity(0.05),
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.open_in_new,
                                  size: 16.w,
                                  color: const Color(0xFF1C64F2),
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  Translation.open_in_goole_map.tr,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeightM.medium,
                                    color: const Color(0xFF1C64F2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServicesWorkingTime extends StatelessWidget {
  final ServicesState state;

  const ServicesWorkingTime({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final schedules = state.providerData?.provider.schedules ?? [];
    if (schedules.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Translation.working_time.tr,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeightM.semiBold,
              color: const Color(0xFF1F2A37),
              height: 1.5,
            ),
          ),
          SizedBox(height: 8.h),
          ...schedules.map((schedule) => Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Text(
                  '${schedule.day}: ${schedule.hours}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeightM.regular,
                    color: const Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class ServicesReviews extends StatelessWidget {
  final ServicesState state;

  const ServicesReviews({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final ratings = state.providerData?.ratings ?? [];
    if (ratings.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Translation.recent_reviews.tr,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeightM.semiBold,
                  color: const Color(0xFF1F2A37),
                  height: 1.5,
                ),
              ),
              CustomInkButton(
                onTap: () {
                  Navigator.of(context).pushNamed(RoutesManager.reviews.route,
                      arguments: {
                        'provider-id': state.providerData!.provider.id
                      });
                },
                backgroundColor: Colors.transparent,
                child: Text(
                  Translation.see_all.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeightM.medium,
                    color: const Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ratings.length > 2 ? 2 : ratings.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final rating = ratings[index];
            return ReviewCard(
              imageUrl: rating.userImage,
              name: rating.userName,
              rating: rating.rating,
              dateString: rating.dateAt,
              comment: rating.comment,
            );
          },
        ),
      ],
    );
  }
}

class ServicesCategories extends StatelessWidget {
  final ServicesState state;

  const ServicesCategories({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final categories = state.providerData?.provider.categories ?? [];
    if (categories.isEmpty) return const SizedBox.shrink();

    final colors = [
      const Color(0xFFDC9497),
      const Color(0xFF93C19E),
      const Color(0xFFF5AD7E),
      const Color(0xFFACA1CD),
      const Color(0xFF4D9B91),
      const Color.fromARGB(255, 112, 78, 191),
      const Color.fromARGB(255, 171, 198, 237),
      const Color(0xFF89CCDB),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
          child: Text(
            Translation.categories.tr,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeightM.semiBold,
              color: const Color(0xFF1F2A37),
              height: 1.5,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 105.h,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(width: 16.w),
            itemCount: categories.length > 4 ? 4 : categories.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
            itemBuilder: (context, index) => CategoryItem(
              imageUrl: categories[index].image,
              title: categories[index].name,
              color: colors[index % colors.length],
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }
}

class ServicesBottomBar extends StatelessWidget {
  final ServicesState state;
  final ProviderType exploreType;

  const ServicesBottomBar({
    super.key,
    required this.state,
    required this.exploreType,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled =
        exploreType.isDoctor || state.selectedCategory != null;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(15, 23, 42, 0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: CustomInkButton(
        enabled: isEnabled,
        onTap: isEnabled
            ? () {
                if (instance<AppPreferences>().isUserRegistered) {
                  final category = exploreType.isDoctor
                      ? state.providerData!.categories.first
                      : state.selectedCategory;
                  if (category == null && !exploreType.isDoctor) return;

                  Navigator.of(context).pushNamed(
                    RoutesManager.appointmentBooking.route,
                    arguments: {
                      'provider-id': state.providerData!.provider.id,
                      'provider-name': state.providerData!.provider.name,
                      'department': category,
                      'provider-type': exploreType
                    },
                  );
                } else {
                  SnackbarHelper.showMessage(
                      Translation.please_login_first.tr, ErrorMessage.snackBar);
                }
              }
            : null,
        backgroundColor:
            isEnabled ? const Color(0xFF1C2A3A) : const Color(0xFFD1D5DB),
        borderRadius: 50.r,
        height: 48.h,
        alignment: Alignment.center,
        child: Text(
          Translation.book_appointment.tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeightM.medium,
            color: isEnabled ? Colors.white : const Color(0xFF9CA3AF),
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
