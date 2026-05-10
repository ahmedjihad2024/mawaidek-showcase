import 'package:mawadk/app/extensions.dart';
import 'package:mawadk/presentation/res/color_manager.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomizedSmartRefresh extends StatelessWidget {
  final Widget child;
  final RefreshController controller;
  final void Function()? onLoading;
  final void Function()? onRefresh;
  final bool enableLoading;
  final bool enablePullDown;  
  final EdgeInsetsGeometry? classicFooterPadding;
  final ScrollPhysics? physics;

  const CustomizedSmartRefresh(
      {super.key,
      required this.child,
      required this.controller,
      this.onLoading,
      this.onRefresh,
      this.enableLoading = false,
      this.enablePullDown = true,
      this.classicFooterPadding,
      this.physics = const BouncingScrollPhysics()});



  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      enablePullUp: enableLoading,
      enablePullDown: enablePullDown,
      physics: physics,
      footer: ClassicFooter(
        outerBuilder: (child) {
          return Padding(
            padding: classicFooterPadding ?? EdgeInsets.zero,
            child: child,
          );
        },
        textStyle: context.labelSmall.copyWith(
            color: ColorM.black.withValues(alpha: .5),
            fontWeight: FontWeightM.medium),
        loadingText: Translation.loading.tr,
        noDataText: Translation.no_more.tr,
        failedText: Translation.failed_loading.tr,
        idleText: Translation.load_more.tr,
        canLoadingText: Translation.load_more.tr,
        spacing: 12.w,
        height: 50 + (classicFooterPadding?.vertical ?? 0),
        loadingIcon: SizedBox(
          width: 15.w,
          height: 15.w,
          child: CircularProgressIndicator(
            color: ColorM.purple,
            backgroundColor: ColorM.transparent,
            strokeWidth: 2.2,
            strokeCap: StrokeCap.round,
          ),
        ),
      ),
      onLoading: onLoading,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
