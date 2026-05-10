import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/res/assets_manager.dart';
import 'package:mawadk/presentation/res/color_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';

import 'package:smooth_corner/smooth_corner.dart';

class LocationPickerBottomSheet extends StatefulWidget {
  final Future<bool> Function()? onEnablePressed;
  final VoidCallback? onDismiss;

  const LocationPickerBottomSheet({
    super.key,
    this.onEnablePressed,
    this.onDismiss,
  });

  static Future<void> show(
    BuildContext context, {
    Future<bool> Function()? onEnablePressed,
    VoidCallback? onDismiss,
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            LocationPickerTopSheet(
          onEnablePressed: onEnablePressed,
          onDismiss: onDismiss,
        ),
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.4),
        barrierDismissible: true,
      ),
    );
  }

  @override
  State<LocationPickerBottomSheet> createState() =>
      _LocationPickerBottomSheetState();
}

class _LocationPickerBottomSheetState extends State<LocationPickerBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // This class is now just for compatibility
  }
}

class LocationPickerTopSheet extends StatefulWidget {
  final Future<bool> Function()? onEnablePressed;
  final VoidCallback? onDismiss;

  const LocationPickerTopSheet({
    super.key,
    this.onEnablePressed,
    this.onDismiss,
  });

  @override
  State<LocationPickerTopSheet> createState() => _LocationPickerTopSheetState();
}

class _LocationPickerTopSheetState extends State<LocationPickerTopSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0), // Start from top (hidden)
      end: Offset.zero, // End at normal position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() async {
    await _animationController.reverse();
    if (mounted) {
      Navigator.of(context).pop();
      widget.onDismiss?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: _dismiss,
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Container(
              color: Colors.black.withValues(alpha: 0.4 * _fadeAnimation.value),
              child: child,
            );
          },
          child: Column(
            children: [
              SlideTransition(
                position: _slideAnimation,
                child: SmoothClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32.r),
                    bottomRight: Radius.circular(32.r),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0C1A4B).withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color:
                              const Color(0xFF323247).withValues(alpha: 0.02),
                          blurRadius: 20,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Content
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Column(
                              children: [
                                42.verticalSpace,
                                // Title
                                Text(
                                  Translation.enable_locations_title.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.sp,
                                    color: const Color(0xFF040302),
                                    height: 26 / 24,
                                    letterSpacing: 0.12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                28.verticalSpace,

                                // Location illustration
                                SizedBox(
                                  width: 143.857.w,
                                  height: 166.h,
                                  child: SvgPicture.asset(
                                    SvgM.pickLocation,
                                    fit: BoxFit.contain,
                                    colorFilter: ColorFilter.mode(ColorM.primary.withValues(alpha: .8), BlendMode.srcIn),
                                  ),
                                ),

                                28.verticalSpace,

                                // Subtitle
                                Text(
                                  Translation.enable_locations_subtitle.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                    color: const Color(0xFF433F41),
                                    height: 1.2,
                                    letterSpacing: 0.3,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                28.verticalSpace,

                                // Enable button
                                CustomInkButton(
                                  onTap: isLoadingLocation
                                      ? null
                                      : () async {
                                          setState(() {
                                            isLoadingLocation = true;
                                          });
                                          // Expect a boolean result: true when location obtained/success,
                                          // false when permission denied or operation failed.
                                          bool success = await (widget
                                                  .onEnablePressed
                                                  ?.call() ??
                                              Future.value(false));
                                          if (success) {
                                            _dismiss();
                                          } else {
                                            // Keep the sheet open so the user sees the instruction and
                                            // doesn't end up on a blank screen. Reset loading state.
                                            if (mounted) {
                                              setState(() {
                                                isLoadingLocation = false;
                                              });
                                            }
                                          }
                                        },
                                  width: 175.w,
                                  height: 56.h,
                                  borderRadius: 12.r,
                                  alignment: Alignment.center,
                                  backgroundColor: isLoadingLocation
                                      ? Colors.transparent
                                      : ColorM.primary,
                                  child: isLoadingLocation
                                      ? SizedBox(
                                          width: 30.w,
                                          height: 30.w,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            color: ColorM.primary,
                                            backgroundColor: Colors.transparent,
                                            strokeCap: StrokeCap.round,
                                          ),
                                        )
                                      : Text(
                                          Translation.continue_location.tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                            color: Colors.white,
                                            letterSpacing: -0.32,
                                          ),
                                        ),
                                ),

                                20.verticalSpace,
                              ],
                            ),
                          ),

                          // Home indicator
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Center(
                              child: Container(
                                width: 80.w,
                                height: 5.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB3BECD),
                                  borderRadius: BorderRadius.circular(100.r),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: _dismiss,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
