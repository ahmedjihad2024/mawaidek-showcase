import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Polished back button used across the app.
///
/// Why a custom widget instead of the stock IconButton:
///   * 44×44 minimum tap target (Apple HIG, Material accessibility spec).
///   * RTL-aware chevron — the arrow always points "back" in the user's
///     reading direction, so Arabic users see it pointing right.
///   * Haptic feedback (light impact) on press, plus a subtle scale-down
///     animation while held — the affordance feels alive and matches the
///     iOS native feel the user explicitly asked for.
///   * Soft circular surface with a hairline border and a 4-px shadow so
///     it stays legible on hero images, gradients, and busy headers
///     without needing a separate AppBar background.
///   * Auto-hides when the navigator can't pop. Prevents the dead-end
///     button on the splash/home/onboarding roots.
class AppBackButton extends StatefulWidget {
  const AppBackButton({
    super.key,
    this.onPressed,
    this.size = 44,
    this.iconSize = 18,
    this.backgroundColor,
    this.iconColor,
    this.tooltip,
  });

  /// Override the default `Navigator.maybePop`. Use when you need to
  /// confirm a discard, save form state, etc.
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final String? tooltip;

  @override
  State<AppBackButton> createState() => _AppBackButtonState();
}

class _AppBackButtonState extends State<AppBackButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scale = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 90),
    reverseDuration: const Duration(milliseconds: 130),
    lowerBound: 0.92,
    upperBound: 1.0,
    value: 1.0,
  );

  @override
  void dispose() {
    _scale.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    HapticFeedback.lightImpact();
    if (widget.onPressed != null) {
      widget.onPressed!();
      return;
    }
    // maybePop respects PopScope/WillPopScope guards (form-discard
    // confirmation, etc.) — never call .pop() directly.
    await Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    // Hide when there's nothing to pop. The home/splash/onboarding
    // roots use this widget too — without this guard they'd render a
    // dead button.
    final canPop = Navigator.of(context).canPop();
    if (!canPop && widget.onPressed == null) {
      return SizedBox(width: widget.size.w, height: widget.size.w);
    }

    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final bg = widget.backgroundColor ?? Colors.white;
    final iconColor = widget.iconColor ?? const Color(0xFF323F49);

    final button = ScaleTransition(
      scale: _scale,
      child: Container(
        width: widget.size.w,
        height: widget.size.w,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF000000).withValues(alpha: 0.06),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(
          isRTL
              ? CupertinoIcons.chevron_right
              : CupertinoIcons.chevron_left,
          size: widget.iconSize.w,
          color: iconColor,
        ),
      ),
    );

    final wrapped = Semantics(
      button: true,
      label: widget.tooltip ?? 'Back',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _scale.reverse(),
        onTapCancel: () => _scale.forward(),
        onTap: () async {
          await _scale.forward();
          await _handleTap();
        },
        child: button,
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: wrapped);
    }
    return wrapped;
  }
}
