import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/routes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/home/view/widgets/categories_grid.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 16.h),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Translation.categories.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeightM.bold,
                  color: const Color(0xFF1C2A3A), // Dark Teal
                ),
              ),
              CustomInkButton(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(RoutesManager.categories.route);
                },
                child: Text(
                  Translation.see_all.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeightM.medium,
                    color: const Color(0xFF6B7280), // gray-500
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Categories Grid
          CategoriesGrid(),
        ],
      ),
    );
  }
}
