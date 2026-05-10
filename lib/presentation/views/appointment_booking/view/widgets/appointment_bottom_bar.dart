import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/routes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/appointment_booking/bloc/appointment_booking_bloc.dart';

class AppointmentBottomBar extends StatelessWidget {
  final AppointmentBookingState state;
  final int providerId;
  final ProviderType providerType;

  const AppointmentBottomBar({
    super.key,
    required this.state,
    required this.providerId,
    required this.providerType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(15, 23, 42, 0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: CustomInkButton(
        onTap: state.isConfrirmButtonEnabled
            ? () {
                Navigator.of(context).pushNamed(
                    RoutesManager.confirmBooking.route,
                    arguments: {
                      'provider-id': providerId,
                      'provider-doctor-id': providerType.isDoctor
                          ? null
                          : state.selectedProviderDoctor?.id,
                      'date': state.selectedDate,
                      'time': state.selectedTime,
                      'period': state.selectedPeriod,
                      'provider-type': providerType,
                    });
              }
            : null,
        backgroundColor: state.isConfrirmButtonEnabled
            ? const Color(0xFF1C2A3A)
            : const Color(0xFF1C2A3A).withValues(alpha: 0.5),
        borderRadius: 50.r,
        height: 48.h,
        alignment: Alignment.center,
        child: Text(
          Translation.confirm.tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeightM.medium,
            color: Colors.white,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
