import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';

class CustomInkButton extends StatelessWidget {

  final Widget? child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? backgroundColor;
  final Color? splashColor;
  final Color? highlightColor;
  final double? borderRadius;
  final BorderRadius? customBorderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final bool enabled;
  final Duration? animationDuration;
  final AlignmentGeometry? alignment;
  final BorderSide side;
  final double smoothness;
  final List<BoxShadow>? boxShadow;
  
  const CustomInkButton(
      {Key? key,
      this.child,
      this.onTap,
      this.onLongPress,
      this.backgroundColor,
      this.splashColor,
      this.highlightColor,
      this.borderRadius,
      this.customBorderRadius,
      this.padding,
      this.width,
      this.height,
      this.enabled = true,
      this.animationDuration,
      this.alignment,
      this.side = BorderSide.none,
      this.smoothness = 0,
      this.boxShadow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        shadows: boxShadow,
        shape: SmoothRectangleBorder(
          smoothness: smoothness,
          borderRadius: BorderRadius.circular(borderRadius ?? 6),
        ),
      ),
      child: SmoothClipRRect(
        smoothness: smoothness,
        borderRadius: BorderRadius.circular(borderRadius ?? 6),
        side: side,
        child: Material(
          color: backgroundColor ?? Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          animationDuration:
              animationDuration ?? const Duration(milliseconds: 200),
          child: InkWell(
            onTap: enabled ? onTap : null,
            onLongPress: enabled ? onLongPress : null,
            splashColor: splashColor,
            highlightColor: highlightColor,
            child: Container(
              width: width,
              height: height,
              padding: padding,
              alignment: alignment,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
