import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/extensions.dart';

import '../../res/color_manager.dart';
import '../../res/fonts_manager.dart';
import '../../res/translations_manager.dart';

class MyErrorWidget extends StatelessWidget {
  final void Function() onRetry;
  final String errorMessage;
  const MyErrorWidget(
      {super.key, required this.onRetry, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 10.w,
        children: [
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: context.labelMedium.copyWith(
              fontWeight: FontWeightM.medium,
            ),
          ),
          TextButton(
              onPressed: onRetry,
              style: context.theme.textButtonTheme.style!.copyWith(
                backgroundColor: WidgetStatePropertyAll(
                    ColorM.purple.withValues(alpha: .05)),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r))),
                // elevation: WidgetStatePropertyAll(5),
                // shadowColor: WidgetStatePropertyAll(ColorM.lightGreen.withValues(alpha: .1)),
                // minimumSize: WidgetStatePropertyAll(Size(10, 70.w)),
                padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.w)),
              ),
              child: FittedBox(
                child: Text(
                  Translation.retry_button.tr,
                  style: context.labelMedium
                      .copyWith(fontWeight: FontWeightM.medium),
                ),
              )),
        ],
      ),
    );
  }
}
