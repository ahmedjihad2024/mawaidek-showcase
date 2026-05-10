import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/app/supported_locales.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/common/ui_components/logout_bottom_sheet.dart';
import 'package:mawadk/presentation/res/assets_manager.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/routes_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';

class ProfileMenuItems extends StatelessWidget {
  final bool isRegistered;

  const ProfileMenuItems({
    super.key,
    required this.isRegistered,
  });

  Future<void> _changeLanguage(BuildContext context, SupportedLocales language) async {
    if (language.locale.languageCode == context.locale.languageCode) return;
    await context.setLocale(language.locale);
    await Phoenix.rebirth(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Edit Profile
        if (isRegistered) ...[
          _buildMenuItem(
            context: context,
            icon: SvgM.userEdit,
            title: Translation.edit_profile.tr,
            onTap: () {
              Navigator.of(context).pushNamed(RoutesManager.editProfile.route).then((_) {
                context.read<HomeBloc>().add(HandleUserDateEvent());
              });
            },
          ),
          _buildDivider(),
          // Favorite
          _buildMenuItem(
            context: context,
            icon: SvgM.profileHeart,
            title: Translation.favorite.tr,
            onTap: () {
              Navigator.of(context).pushNamed(RoutesManager.favorites.route);
            },
          ),
          _buildDivider(),
          // Notifications
          _buildMenuItem(
            context: context,
            icon: SvgM.notificationBorder2,
            title: Translation.notifications.tr,
            onTap: () {
              Navigator.of(context).pushNamed(
                RoutesManager.notifications.route,
                arguments: {
                  'on-review-submitted': (int bookingId) {
                    context.read<HomeBloc>().add(UpdateBookingRatedEvent(bookingId: bookingId));
                  },
                  'on-booking-cancelled': (int bookingId) {
                    context.read<HomeBloc>().add(CancelBookingUpdateEvent(bookingId: bookingId));
                  },
                },
              );
            },
          ),
          _buildDivider(),
        ],

        // Languages
        _buildLanguageSelector(context),

        _buildDivider(),

        /*
        // Help and Support
        _buildMenuItem(
          context: context,
          icon: SvgM.messageQuestion,
          title: Translation.help_and_support.tr,
          onTap: () {
            Navigator.of(context).pushNamed(RoutesManager.helpAndSupport.route);
          },
        ),

        _buildDivider(),
        */

        /*
        // Terms and Conditions
        _buildMenuItem(
          context: context,
          icon: SvgM.securitySafe,
          title: Translation.terms_and_conditions.tr,
          onTap: () {
            Navigator.of(context).pushNamed(RoutesManager.termsAndConditions.route);
          },
        ),

        if (isRegistered) ...[
          _buildDivider(),
          // Logout
          _buildMenuItem(
            context: context,
            icon: SvgM.logout,
            title: Translation.logout.tr,
            onTap: () => _showLogoutDialog(context),
            showArrow: false,
          ),
          _buildDivider(),
          SizedBox(height: 24.h),
          // Delete Account
          _buildDeleteAccountButton(context),
          SizedBox(height: 24.h),
        ],
        */

        if (isRegistered) ...[
          _buildDivider(),
          // Logout
          _buildMenuItem(
            context: context,
            icon: SvgM.logout,
            title: Translation.logout.tr,
            onTap: () => _showLogoutDialog(context),
            showArrow: false,
          ),
          _buildDivider(),
          SizedBox(height: 24.h),
        ],

        if (!isRegistered) ...[
          SizedBox(height: 24.h),
          _loginButton(context),
        ],
      ],
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return CustomInkButton(
      onTap: onTap,
      borderRadius: 0,
      padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg, vertical: 12.h),
      backgroundColor: Colors.transparent,
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 24.w,
            height: 24.w,
            fit: BoxFit.contain,
            colorFilter: const ColorFilter.mode(
              Color(0xFF6B7280),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeightM.regular,
                color: const Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ),
          if (showArrow)
            RotatedBox(
              quarterTurns: Directionality.of(context) == TextDirection.ltr ? 0 : 2,
              child: SvgPicture.asset(
                SvgM.arrowRight,
                width: 14.w,
                height: 14.h,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF6B7280),
                  BlendMode.srcIn,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg, vertical: 12.h),
      child: Row(
        children: [
          SvgPicture.asset(
            SvgM.language,
            width: 24.w,
            height: 24.h,
            colorFilter: const ColorFilter.mode(
              Color(0xFF6B7280),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              Translation.languages.tr,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeightM.regular,
                color: const Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFD6C2FD).withValues(alpha: 0.2),
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageItem(context: context, language: SupportedLocales.EN),
                _buildLanguageItem(context: context, language: SupportedLocales.AR),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem({
    required BuildContext context,
    required SupportedLocales language,
  }) {
    return GestureDetector(
      onTap: () {
        _changeLanguage(context, language);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: context.locale.languageCode == language.locale.languageCode
              ? const Color(0xFFF9FAFB)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          language.locale.languageCode == SupportedLocales.EN.locale.languageCode
              ? Translation.en.tr
              : Translation.ar.tr,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeightM.medium,
            color: context.locale.languageCode == language.locale.languageCode
                ? const Color(0xFF374151)
                : const Color(0xFF6A6A6A),
            height: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1.h,
      color: const Color(0xFFE5E7EB),
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return Center(
      child: CustomInkButton(
        onTap: () => _showDeleteAccountDialog(context),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        backgroundColor: Colors.transparent,
        child: Text(
          Translation.delete_account.tr,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeightM.regular,
            color: const Color(0xFFF41731), // Red color
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Center(
      child: CustomInkButton(
        onTap: () {
          Navigator.of(context).pushNamedAndRemoveUntil(RoutesManager.signIn.route, (_) => false);
        },
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 5.w),
        backgroundColor: Colors.transparent,
        child: Text(
          Translation.login.tr,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeightM.regular,
            color: Colors.green, // Red color
            height: 1.5,
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: View.of(context).viewInsets.bottom,
        ),
        child: LogoutBottomSheet(
          actionType: AccountActionType.logout,
          onCancel: () => Navigator.of(context).pop(),
          context: context,
          onSuccess: () {
            Navigator.of(context)
              ..pop()
              ..pushNamedAndRemoveUntil(RoutesManager.signUp.route, (_) => false);
          },
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (c) => Padding(
        padding: EdgeInsets.only(
          bottom: View.of(context).viewInsets.bottom,
        ),
        child: LogoutBottomSheet(
          actionType: AccountActionType.deleteAccount,
          onCancel: () => Navigator.of(context).pop(),
          context: context,
          onSuccess: () {
            Navigator.of(context)
              ..pop()
              ..pushNamedAndRemoveUntil(RoutesManager.signUp.route, (_) => false);
          },
        ),
      ),
    );
  }
}
