import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/color_manager.dart';

class MyCircularProgressIndicator extends StatelessWidget {
  const MyCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 35.w,
        height: 35.w,
        child: CircularProgressIndicator(
          color: ColorM.primary,
          backgroundColor: ColorM.transparent,
          strokeCap: StrokeCap.round,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
