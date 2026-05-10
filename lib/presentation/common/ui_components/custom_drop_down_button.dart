import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../res/fonts_manager.dart';

class CustomDropDownButton extends StatefulWidget {
  final int itemsCount;
  final String Function(int index) itemsBuilder;
  final int? initialSelectedIndex;
  final String? hintText;
  final Function(int index) onItemSelected;

  const CustomDropDownButton({
    super.key,
    this.initialSelectedIndex,
    required this.itemsCount,
    required this.itemsBuilder,
    required this.onItemSelected,
    this.hintText,
  });

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState<T> extends State<CustomDropDownButton> {
  int? selectedValue;

  @override
  Widget build(BuildContext context) {
    // handle the initialSelectedIndex
    if (selectedValue == null && widget.initialSelectedIndex != null) {
      selectedValue = widget.initialSelectedIndex;
      widget.onItemSelected(selectedValue!);
    }

    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB), // gray-50
        borderRadius: BorderRadius.circular(8.r), // 8px border radius
        border: Border.all(
          color: const Color(0xFFD1D5DB), // gray-300
          width: 1.w,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w,),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedValue,
          menuMaxHeight: .9.sh,
          menuWidth: 200.w,
          hint: Text(
            widget.hintText ?? "Select",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeightM.regular,
              color: const Color(0xFF9CA3AF), // gray-400
            ),
          ),
          borderRadius: BorderRadius.circular(8.r),
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18.w,
            color: const Color(0xFF9CA3AF), // gray-400
          ),
          dropdownColor: Colors.white,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeightM.regular,
            color: const Color(0xFF111928), // gray-900
          ),
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
            widget.onItemSelected(value!);
          },
          items: List.generate(widget.itemsCount, (index) {
            return DropdownMenuItem<int>(
              value: index,
              child: Text(
                widget.itemsBuilder(index),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeightM.regular,
                  color: const Color(0xFF111928), // gray-900
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
