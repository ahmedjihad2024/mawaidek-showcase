import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mawadk/presentation/res/color_manager.dart';

class BottomNavItem {
  final String title;
  final String svgPath;
  final String selectedSvgPath;
  BottomNavItem({
    required this.title,
    required this.svgPath,
    required this.selectedSvgPath,
  });
}

/// Figma-faithful bottom nav bar with three measured improvements
/// over the previous instant-toggle version:
///
///   1. The "selected" pill background now fades in/out via
///      AnimatedContainer (220 ms easeOut) instead of cutting hard.
///      Subtle but it removes the "snappy" feel a user notices without
///      being able to articulate.
///
///   2. selectionClick haptic on tap. Apple HIG explicitly defines
///      this as the haptic for "I changed which item is selected" —
///      softer than lightImpact (which is for momentary buttons).
///
///   3. Selected vs unselected SVG cross-fades over 180 ms via
///      AnimatedSwitcher rather than swapping the asset in a single
///      frame. Pairs naturally with the pill fade for one cohesive
///      motion.
///
/// What this widget DELIBERATELY does NOT do:
///   * No icon scale animation — the Figma design is intentionally
///     uniform, scaling would break that rhythm.
///   * No sliding pill across the row — visually exciting but
///     unnecessary; the user already knows which tab they tapped.
///   * No labels for selected-only — would create asymmetry; if labels
///     are wanted, all four tabs should show them, which is a design
///     decision and not a polish patch.
class FigmaBottomNavBar extends StatelessWidget {
  final ValueNotifier<int> selectedIndex;
  final List<BottomNavItem> items;
  final void Function(int) onTap;
  final double hight;

  const FigmaBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onTap,
    required this.hight,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedIndex,
      builder: (context, value, _) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: hight,
            decoration: BoxDecoration(
              color: ColorM.white,
              border: Border(
                top: BorderSide(
                  color: Colors.black.withValues(alpha: .06),
                  width: 1.w,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(items.length, (i) {
                final isSelected = value == i;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onTap(i);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    width: 45.w,
                    height: 45.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ColorM.primary.withValues(alpha: .1)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      transitionBuilder: (child, anim) =>
                          FadeTransition(opacity: anim, child: child),
                      child: SvgPicture.asset(
                        isSelected
                            ? items[i].selectedSvgPath
                            : items[i].svgPath,
                        key: ValueKey<bool>(isSelected),
                        width: 22.w,
                        height: 22.w,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
