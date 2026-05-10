import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/extensions.dart';
import 'package:mawadk/presentation/res/color_manager.dart';

import '../../res/sizes_manager.dart';

void showSnackBar({
  required String msg,
  required BuildContext context,
  int seconds = 3,
  bool isError = false,
}) {
  /// TWO
  // ScaffoldMessenger.of(context).removeCurrentSnackBar();
  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(SizeM.commonBorderRadius.r),
  //         side: BorderSide(
  //             color: isError ? ColorM.purple : ColorM.purple, width: 1.w)),
  // padding: EdgeInsets.symmetric(
  //   horizontal: 10.dg,
  //   vertical: 12.dg,
  // ),
  //     margin: EdgeInsets.all(SizeM.pagePadding.dg),
  //     backgroundColor: context.whiteHeavyPurple2Color,
  //     elevation: 5,
  //     duration: Duration(seconds: seconds),
  //     behavior: SnackBarBehavior.floating,
  //     content: Text(
  //       msg,
  //       style: context.labelMedium,
  //       softWrap: true,
  //     )));
  final bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;

  AnimatedSnackBar.removeAll();
  AnimatedSnackBar(
    duration: Duration(seconds: seconds),
    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
    animationCurve: Curves.fastEaseInToSlowEaseOut,
    snackBarStrategy: RemoveSnackBarStrategy(),
    mobilePositionSettings: MobilePositionSettings(
      bottomOnDissapear: -(.5.sh),
      bottomOnAppearance:
          30.dg + (isIOS ? 0 : MediaQuery.viewPaddingOf(context).bottom),
      left: SizeM.pagePadding.dg,
      right: SizeM.pagePadding.dg,
    ),
    builder: ((context) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 10.dg,
          vertical: 12.dg,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isError
                ? ColorM.primary
                : ColorM.primary.withValues(alpha: .3),
            width: 1.w,
          ),
        ),
        child: Text(
          msg,
          style: context.labelMedium,
        ),
      );
    }),
  ).show(context);
}
