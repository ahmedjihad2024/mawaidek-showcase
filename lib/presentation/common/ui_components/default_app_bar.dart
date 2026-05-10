import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/extensions.dart';
import 'package:mawadk/presentation/common/ui_components/app_back_button.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';

class DefaultAppBar extends StatelessWidget {
  const DefaultAppBar({
    super.key,
    this.title,
    this.backFunction,
    this.actionButtons,
    this.customBackButton,
    this.noSpacer = false,
    this.padding,
  });

  final void Function()? backFunction;
  final List<Widget>? actionButtons;
  final String? title;
  final bool noSpacer;
  final Widget? customBackButton;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          EdgeInsets.symmetric(
                horizontal: SizeM.pagePadding.dg,
              ) +
              EdgeInsets.only(top: SizeM.pagePadding.dg),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Center title
          if (title != null)
            Container(
              alignment: Alignment.center,
              width: .7.sw,
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: Text(
                title!,
                textAlign: TextAlign.center,
                maxLines: 4,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: context.bodyLarge.copyWith(
                  height: 1,
                  fontWeight: FontWeightM.semiBold,
                ),
              ),
            ),

          // Left and right buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 8.w,
            children: [
              // Back button — uses the shared AppBackButton so the chevron
              // direction, haptic feedback, and tap target stay consistent
              // with every other screen (including the screens that don't
              // use DefaultAppBar but still drop in AppBackButton directly).
              Align(
                alignment: AlignmentDirectional.topStart,
                child: customBackButton ??
                    AppBackButton(onPressed: backFunction),
              ),

              // Action buttons
              if (actionButtons != null)
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actionButtons!,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
