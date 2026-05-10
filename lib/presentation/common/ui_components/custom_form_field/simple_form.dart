import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/extensions.dart';
import 'package:mawadk/presentation/res/color_manager.dart';
import 'package:smooth_corner/smooth_corner.dart';

import 'custom_form_field.dart';

class SimpleForm extends StatelessWidget {
  final TextEditingController controller;
  final SecurityController? securityController;
  final String hintText;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final String? Function(String)? validator;
  final Widget Function(bool)? suffixWidget;
  final Widget? prefixWidget;
  final bool? obscureText;
  final Widget? label;
  final int? textLength;
  final double? height;
  final bool outlineBorder;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Future<Widget?> Function(String, void Function() hide)?
      searchResultsBuilder;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final TextStyle? hintStyle;
  final double? fontSize;
  final int maxLines;
  final AlignmentDirectional alignment;
  final double? borderRadius;
  final bool removeShadow;
  final Color? unFocusedBorderColor;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final double smoothness;

  const SimpleForm(
      {super.key,
      this.securityController,
      required this.hintText,
      required this.keyboardType,
      required this.controller,
      this.height,
      this.focusNode,
      this.validator,
      this.suffixWidget,
      this.obscureText,
      this.prefixWidget,
      this.textLength,
      this.hintStyle,
      this.label,
      this.backgroundColor,
      this.padding,
      this.outlineBorder = true,
      this.searchResultsBuilder,
      this.onFieldSubmitted,
      this.textInputAction,
      this.fontSize,
      this.maxLines = 1,
      this.alignment = AlignmentDirectional.center,
      this.onChanged,
      this.borderRadius,
      this.removeShadow = true,
      this.unFocusedBorderColor,
      this.readOnly = false,
      this.inputFormatters,
      this.smoothness = 0});

  @override
  Widget build(BuildContext context) {
    return NiceTextForm(
      key: super.key,
      alignment: alignment,
      maxLines: maxLines,
      prefixWidget: prefixWidget,
      height: height ?? 45.h,
      width: double.infinity,
      textLength: textLength,
      cursorColor: const Color(0xFF1C2A3A), // Dark Teal
      controller: securityController,
      searchResultsBuilder: searchResultsBuilder,
      onTextChanged: onChanged,
      inputFormatters: inputFormatters,
      validatorStyle: context.labelSmall.copyWith(
        color: ColorM.red,
        fontSize: 12.sp,
        fontWeight: FontWeightM.medium,
      ),
      boxDecoration: outlineBorder
          ? ShapeDecoration(
              color: backgroundColor ?? const Color(0xFFF9FAFB), // gray-50
              shape: SmoothRectangleBorder(
                smoothness: smoothness,
                borderRadius: BorderRadius.circular(
                    borderRadius ?? 8.r), // 8px border radius
                side: BorderSide(
                  color: unFocusedBorderColor ??
                      const Color(0xFFD1D5DB), // gray-300
                  width: 1.w,
                ),
              ))
          : ShapeDecoration(
              color: backgroundColor ?? const Color(0xFFF9FAFB), // gray-50
              shape: SmoothRectangleBorder(
                smoothness: smoothness,
                borderRadius: BorderRadius.circular(
                    borderRadius ?? 8.r), // 8px border radius
              ),
            ),
      activeBoxDecoration: outlineBorder
          ? ShapeDecoration(
              color: backgroundColor ?? const Color(0xFFF9FAFB), // gray-50
              shape: SmoothRectangleBorder(
                smoothness: smoothness,
                borderRadius: BorderRadius.circular(
                    borderRadius ?? 8.r), // 8px border radius
                side: BorderSide(
                  color: const Color(0xFF1C2A3A), // Dark Teal for active state
                  width: 1.w,
                ),
              ))
          : null,
      padding: padding ??
          EdgeInsets.symmetric(horizontal: 16.w), // 16px horizontal, 12px vertical
      isPhoneForm: false,
      obscureText: obscureText,
      focusNode: focusNode,
      label: label,
      keyboardType: keyboardType,
      hintText: hintText,
      validator: validator,
      textStyle: context.labelLarge.copyWith(
        fontSize: fontSize ?? 14.sp, // 14px font size
        fontWeight: FontWeightM.regular,
        color: const Color(0xFF111928), // gray-900
      ),
      hintStyle: hintStyle ??
          context.labelLarge.copyWith(
            color: const Color(0xFF9CA3AF), // gray-400
            fontSize: fontSize ?? 14.sp, // 14px font size
            fontWeight: FontWeightM.regular,
          ),
      textEditingController: controller,
      sufixWidget: suffixWidget,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      readOnly: readOnly,
    );
  }
}
