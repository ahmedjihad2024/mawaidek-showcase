import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/presentation/common/ui_components/custom_check_box.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';

class FilterData {
  final int? rating;
  final bool nearestToMe;

  FilterData({
    this.rating,
    this.nearestToMe = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'nearestToMe': nearestToMe,
    };
  }
}

class FilterBottomSheet extends StatefulWidget {
  final Function(FilterData)? onFilterApplied;
  final FilterData? initialData;

  const FilterBottomSheet({
    super.key,
    this.onFilterApplied,
    this.initialData,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();

  static Future<void> show(
    BuildContext context, {
    Function(FilterData)? onFilterApplied,
    FilterData? initialData,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        onFilterApplied: onFilterApplied,
        initialData: initialData,
      ),
    );
  }
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late int? _selectedRating;
  late bool _nearestToMe;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.initialData?.rating;
    _nearestToMe = widget.initialData?.nearestToMe ?? false;
  }

  void _resetFilters() {
    setState(() {
      _selectedRating = null;
      _nearestToMe = false;
    });
    widget.onFilterApplied?.call(FilterData());
    Navigator.of(context).pop();
  }

  void _applyFilters() {
    final filterData = FilterData(
      rating: _selectedRating,
      nearestToMe: _nearestToMe,
    );
    widget.onFilterApplied?.call(filterData);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(34.r),
          topRight: Radius.circular(34.r),
        ),
      ),
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 24.h,
        bottom: View.of(context).viewInsets.bottom + 24.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            Translation.filter.tr,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeightM.semiBold,
              color: const Color(0xFF3879D4),
            ),
          ),
          SizedBox(height: 24.h),

          // Rating Section
          Text(
            Translation.select_rating.tr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeightM.semiBold,
              color: const Color(0xFF262626),
            ),
          ),
          SizedBox(height: 16.h),
          _buildRatingSelector(),
          SizedBox(height: 32.h),

          // // Filter Options Section
          // // Highest Discounts
          // _buildFilterOption(
          //   title: Translation.highest_discounts.tr,
          //   value: _highestDiscounts,
          //   onChanged: (value) {
          //     setState(() {
          //       _highestDiscounts = value;
          //     });
          //   },
          // ),
          // SizedBox(height: 20.h),

          // Nearest to Me
          _buildFilterOption(
            title: Translation.nearest_to_me.tr,
            value: _nearestToMe,
            onChanged: (value) {
              setState(() {
                _nearestToMe = value;
              });
            },
          ),
          SizedBox(height: 32.h),

          // Buttons
          Row(
            children: [
              // Reset Button
              Expanded(
                child: CustomInkButton(
                  onTap: _resetFilters,
                  backgroundColor: const Color(0xFFE5E7EB),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  borderRadius: 12.r,
                  alignment: Alignment.center,
                  child: Text(
                    Translation.reset_filter.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeightM.bold,
                      color: const Color(0xFF3879D4),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // Apply Button
              Expanded(
                child: CustomInkButton(
                  onTap: _applyFilters,
                  backgroundColor: const Color(0xFF3879D4),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  borderRadius: 12.r,
                  alignment: Alignment.center,
                  child: Text(
                    Translation.apply_filter.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeightM.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildRatingSelector() {
    return Row(
      children: List.generate(5, (index) {
        final rating = index + 1;
        final isSelected =
            _selectedRating != null && rating <= _selectedRating!;
        return GestureDetector(
          onTap: () {
            setState(() {
              // If clicking the same rating, deselect it
              if (_selectedRating == rating) {
                _selectedRating = null;
              } else {
                _selectedRating = rating;
              }
            });
          },
          child: Padding(
            padding: EdgeInsets.only(right: index < 4 ? 8.w : 0),
            child: Icon(
              Icons.star,
              size: 32.w,
              color: isSelected
                  ? const Color(0xFFFFD700) // Gold color
                  : const Color(0xFFE5E7EB), // Gray color
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFilterOption({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        CustomCheckBox(
          value: value,
          onChange: onChanged,
          width: 24.w,
          height: 24.w,
          borderRadius: 6.r,
          fillColor: const Color(0xFF3879D4),
          borderColor: const Color(0xFF3879D4),
          checkColor: Colors.white,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeightM.medium,
              color: const Color(0xFF262626),
            ),
          ),
        ),
      ],
    );
  }
}
