import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/presentation/common/ui_components/custom_calendar.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/appointment_booking/bloc/appointment_booking_bloc.dart';

class AppointmentSelectDateSection extends StatelessWidget {
  final Category department;
  final int providerId;

  const AppointmentSelectDateSection({
    super.key,
    required this.department,
    required this.providerId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
          child: Text(
            Translation.select_date.tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeightM.semiBold,
              color: const Color(0xFF1C2A3A),
              height: 1.5,
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Custom Calendar
        InfiniteDateSelector(
          onSelectedDate: (selectedDate) {
            context.read<AppointmentBookingBloc>().add(
                  GetAvailableTimesEvent(
                    date: selectedDate,
                    categoryId: department.id,
                    providerId: providerId,
                  ),
                );
          },
        )
      ],
    );
  }
}
