import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/dependency_injection.dart';
import 'package:mawadk/app/services/app_preferences.dart';
import 'package:mawadk/presentation/common/ui_components/customized_smart_refresh.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';
import 'package:mawadk/presentation/views/home/view/widgets/profile_header.dart';
import 'package:mawadk/presentation/views/home/view/widgets/profile_menu_items.dart';

class ProfileTabView extends StatefulWidget {
  final double totalBottomNavHeight;

  const ProfileTabView({
    super.key,
    required this.totalBottomNavHeight,
  });

  @override
  State<ProfileTabView> createState() => _ProfileTabViewState();
}

class _ProfileTabViewState extends State<ProfileTabView> {
  HomeState get state => context.read<HomeBloc>().state;

  bool isRegistered = instance<AppPreferences>().isUserRegistered;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return CustomizedSmartRefresh(
          enablePullDown: instance<AppPreferences>().isUserRegistered,
          controller: context.read<HomeBloc>().profileRefreshController,
          onRefresh: () {
            context.read<HomeBloc>().add(GetProfileEvent());
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: widget.totalBottomNavHeight),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  8.verticalSpace,
                  if (isRegistered) ...[
                    // Profile header section
                    ProfileHeader(state: state),
                  ],

                  16.verticalSpace,

                  // Menu items
                  ProfileMenuItems(isRegistered: isRegistered),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

