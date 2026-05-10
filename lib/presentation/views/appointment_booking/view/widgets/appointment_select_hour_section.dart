import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/presentation/common/ui_components/circular_progress_indicator.dart';
import 'package:mawadk/presentation/common/ui_components/error_widget.dart';
import 'package:mawadk/presentation/common/utils/state_render.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/appointment_booking/bloc/appointment_booking_bloc.dart';
import 'package:mawadk/presentation/views/appointment_booking/view/widgets/time_slot_chip.dart';

class TimeSlotWithPeriod {
  final TimeSlot slot;
  final BookingPeriod period;

  TimeSlotWithPeriod({
    required this.slot,
    required this.period,
  });
}

class AppointmentSelectHourSection extends StatelessWidget {
  final AppointmentBookingState state;
  final Category department;
  final int providerId;

  const AppointmentSelectHourSection({
    super.key,
    required this.state,
    required this.department,
    required this.providerId,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenState.setState(
      reqState: state.availableTimesReqState,
      loading: () => Padding(
        padding: EdgeInsets.all(24.w),
        child: const MyCircularProgressIndicator(),
      ),
      error: () => Padding(
        padding: EdgeInsets.all(24.w),
        child: MyErrorWidget(
          onRetry: () {
            context.read<AppointmentBookingBloc>().add(
                  GetAvailableTimesEvent(
                    date: state.selectedDate,
                    categoryId: department.id,
                    providerId: providerId,
                  ),
                );
          },
          errorMessage: state.availableTimesErrorState,
        ),
      ),
      online: () {
        final timesData = state.availableTimesData;
        if (timesData == null ||
            (!timesData.isAvailable &&
                timesData.morning.isEmpty &&
                timesData.evening.isEmpty)) {
          return _noTimesWidget();
        }

        // Combine morning and evening into one list
        final allTimeSlots = <TimeSlotWithPeriod>[];
        for (var slot in timesData.morning) {
          allTimeSlots.add(
              TimeSlotWithPeriod(slot: slot, period: BookingPeriod.morning));
        }
        for (var slot in timesData.evening) {
          allTimeSlots.add(
              TimeSlotWithPeriod(slot: slot, period: BookingPeriod.evening));
        }

        // Filter out past time slots if selected date is today
        final now = DateTime.now();
        final isToday = state.selectedDate.year == now.year &&
            state.selectedDate.month == now.month &&
            state.selectedDate.day == now.day;
        if (isToday) {
          allTimeSlots.removeWhere((item) {
            try {
              final slotTime =
                  DateFormat('hh:mm a', 'en').parse(item.slot.time);
              final slotDateTime = DateTime(
                now.year, now.month, now.day,
                slotTime.hour, slotTime.minute,
              );
              return slotDateTime.isBefore(now);
            } catch (_) {
              return false;
            }
          });
        }

        if (allTimeSlots.isEmpty) return _noTimesWidget();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
              child: Text(
                Translation.select_hour.tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeightM.semiBold,
                  color: const Color(0xFF1C2A3A),
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // All time slots in one horizontal row
            AppointmentTimeSlotsGrid(
              timeSlots: allTimeSlots,
              state: state,
            ),
          ],
        );
      },
    );
  }

  Widget _noTimesWidget() {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Text(
        Translation.no_available_times.tr,
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF6B7280),
        ),
      ),
    );
  }
}

class AppointmentTimeSlotsGrid extends StatelessWidget {
  final List<TimeSlotWithPeriod> timeSlots;
  final AppointmentBookingState state;

  const AppointmentTimeSlotsGrid({
    super.key,
    required this.timeSlots,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      child: Row(
        spacing: 11.w,
        children: timeSlots.map((item) {
          final slot = item.slot;
          final period = item.period;
          final isSelected = state.selectedTime == slot.time;
          return GestureDetector(
            onTap: slot.available
                ? () {
                    context.read<AppointmentBookingBloc>().add(
                          SelectTimeSlotEvent(
                            time: slot.time,
                            period: period,
                          ),
                        );
                  }
                : null,
            child: Opacity(
              opacity: slot.available ? 1.0 : 0.5,
              child: TimeSlotChip(
                time: slot.time,
                isSelected: isSelected,
                isAvailable: slot.available,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
