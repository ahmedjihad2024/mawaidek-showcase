import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/confirm_booking/bloc/confirm_booking_bloc.dart';

class ConfirmBookingTermsAndConditions extends StatelessWidget {
  final ConfirmBookingState state;

  const ConfirmBookingTermsAndConditions({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              context
                  .read<ConfirmBookingBloc>()
                  .add(ToggleTermsAcceptedEvent());
            },
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: state.termsAccepted
                    ? const Color(0xFF1C2A3A)
                    : Colors.white,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: const Color(0xFF1C2A3A),
                  width: 1,
                ),
              ),
              child: state.termsAccepted
                  ? Icon(
                      Icons.check,
                      size: 14.w,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              '${Translation.i_agree_to.tr} ${Translation.terms_and_conditions.tr} ${Translation.and.tr} ${Translation.cancellation_policy.tr}',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeightM.medium,
                color: const Color(0xFF0B0B0B),
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
