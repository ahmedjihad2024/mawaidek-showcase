import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/extensions.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/res/color_manager.dart';
import 'package:smooth_corner/smooth_corner.dart';

class AnimatedTapsNavigator extends StatefulWidget {
  final List<String> tabs;
  final int selectedTap;
  final double? margin;
  final double? padding;
  final Function(int) onTap;
  final bool isStickStyle;
  final double? stickHeight;
  final double? stickWidth;
  final double? stickTopMargin;
  final bool isStickAtTop;

  // New customization parameters
  final double? containerHeight;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final Color? activeTextColor;
  final Color? inactiveTextColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? stickColor;
  final double? stickBorderRadius;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final double smoothness;

  const AnimatedTapsNavigator({
    required this.tabs,
    required this.selectedTap,
    required this.onTap,
    this.margin,
    this.padding,
    this.isStickStyle = false,
    this.stickHeight,
    this.stickWidth,
    this.stickTopMargin,
    this.isStickAtTop = false,
    this.containerHeight,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.activeTextColor,
    this.inactiveTextColor,
    this.fontSize,
    this.fontWeight,
    this.stickColor,
    this.stickBorderRadius,
    this.animationDuration,
    this.animationCurve,
    this.smoothness = 0,
    super.key,
  });

  @override
  _AnimatedTapsNavigatorState createState() => _AnimatedTapsNavigatorState();
}

class _AnimatedTapsNavigatorState extends State<AnimatedTapsNavigator> {
  late double margin;
  late double padding;
  late double stickHeight;
  late double stickTopMargin;
  late double containerHeight;
  late double borderRadius;
  late Color backgroundColor;
  late Color borderColor;
  late double borderWidth;
  late Color activeTextColor;
  late Color inactiveTextColor;
  late double fontSize;
  late FontWeight fontWeight;
  late Color stickColor;
  late double stickBorderRadius;
  late Duration animationDuration;
  late Curve animationCurve;

  @override
  void initState() {
    margin = widget.margin ?? SizeM.pagePadding.dg;
    padding = widget.padding ?? 6.w;
    stickHeight = widget.stickHeight ?? 3.h;
    containerHeight = widget.containerHeight ?? 50.h;
    borderRadius = widget.borderRadius ?? 12.r;
    backgroundColor = widget.backgroundColor ?? Colors.white;
    borderColor = widget.borderColor ?? const Color(0xFFEEF0EE);
    borderWidth = widget.borderWidth ?? 1;
    activeTextColor = widget.activeTextColor ?? ColorM.primary;
    inactiveTextColor = widget.inactiveTextColor ?? const Color(0xFF6A6A6A);
    fontSize = widget.fontSize ?? 14.sp;
    fontWeight = widget.fontWeight ?? FontWeightM.medium;
    stickColor = widget.stickColor ?? ColorM.primary;
    stickBorderRadius = widget.stickBorderRadius ?? 6.r;
    animationDuration =
        widget.animationDuration ?? const Duration(milliseconds: 300);
    animationCurve = widget.animationCurve ?? Curves.fastLinearToSlowEaseIn;

    // Fix stick positioning
    if (widget.isStickAtTop) {
      stickTopMargin = widget.stickTopMargin ?? padding;
    } else {
      stickTopMargin =
          widget.stickTopMargin ?? (containerHeight - stickHeight - padding);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = (constraints.maxWidth - (margin * 2) - (padding * 2)) /
          widget.tabs.length;

      // Calculate stick width and position
      final calculatedStickWidth = widget.stickWidth ?? (width - (padding * 2));

      // Calculate stick left position
      final stickLeft =
          (widget.selectedTap * width) + (width - calculatedStickWidth) / 2;

      return Container(
        margin: EdgeInsets.symmetric(horizontal: margin),
        padding: EdgeInsets.all(padding),
        decoration: ShapeDecoration(
          shape: SmoothRectangleBorder(
            smoothness: widget.smoothness,
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: borderColor,
              width: borderWidth,
            ),
          ),
          color: backgroundColor,
        ),
        height: containerHeight,
        child: Stack(
          children: [
            // Background fill or stick indicator
            if (widget.isStickStyle)
              // Stick/Indicator style
              PositionedDirectional(
                top: stickTopMargin,
                start: stickLeft,
                child: AnimatedContainer(
                  duration: animationDuration,
                  curve: animationCurve,
                  width: calculatedStickWidth,
                  height: stickHeight,
                  decoration: ShapeDecoration(
                    color: stickColor,
                    shape: SmoothRectangleBorder(
                      smoothness: 1,
                      borderRadius: BorderRadius.circular(stickBorderRadius),
                    ),
                  ),
                ),
              )
            else
              // Background fill style (original behavior)
              Row(
                children: [
                  AnimatedContainer(
                    duration: animationDuration,
                    curve: animationCurve,
                    margin: EdgeInsetsDirectional.only(
                      start: (widget.selectedTap * width),
                    ),
                    width: width,
                    height: double.infinity,
                    decoration: ShapeDecoration(
                      color: stickColor,
                      shape: SmoothRectangleBorder(
                        smoothness: 1,
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                    ),
                  ),
                ],
              ),
            // Tabs content
            Row(
              children: List.generate(widget.tabs.length, (index) {
                return Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => widget.onTap(index),
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(padding),
                        width: width,
                        child: FittedBox(
                          child: Text(
                            widget.tabs[index],
                            textAlign: TextAlign.center,
                            softWrap: true,
                            maxLines: 2,
                            style: context.labelMedium.copyWith(
                              fontWeight: fontWeight,
                              fontSize: fontSize,
                              height: 1,
                              color: index == widget.selectedTap
                                  ? (widget.isStickStyle
                                      ? activeTextColor
                                      : Colors.white)
                                  : inactiveTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}
