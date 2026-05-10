import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/common/utils/fast_function.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/routes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';
import 'package:mawadk/presentation/views/home/view/screens/home_view.dart';
import 'package:mawadk/presentation/views/home/view/widgets/upcoming_appointment_card.dart';

class HomeUpcomingAppointmentsSection extends StatelessWidget {
  const HomeUpcomingAppointmentsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.read<HomeBloc>().state;
    final bookings = state.upcomingBookings
        .where((booking) => booking.paymentMethod.isOnline && booking.paymentStatus.isPending);

    // Don't show section if no bookings
    if (bookings.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayBookings = bookings.take(2).toList();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 16.h),

          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Translation.upcoming_appointments.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeightM.bold,
                  color: const Color(0xFF1C2A3A),
                ),
              ),
              CustomInkButton(
                onTap: () {
                  // Navigate to Bookings tab
                  HomeTapsControllers.BOTTOM_NAV_BAR_SELECTED_TAB.value = 2;
                  HomeTapsControllers.BOTTOM_NAV_BAR_SLIDER_CONTROLLER
                      .animateToPage(
                    2,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.fastLinearToSlowEaseIn,
                  );
                },
                child: Text(
                  Translation.see_all.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeightM.medium,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Vertical list of appointment cards
          ...List.generate(displayBookings.length, (index) {
            final booking = displayBookings[index];
            final bool isDoctor = booking.provider.type.isDoctor;
            final String doctorName = isDoctor
                ? booking.provider.name
                : booking.providerDoctor?.name ?? '';
            final String specialty = isDoctor
                ? booking.provider.category?.name ?? ''
                : booking.providerDoctor?.category.name ?? '';
            final String location = isDoctor
                ? booking.provider.address
                : booking.providerDoctor?.provider.address ?? '';
            final String imageUrl = isDoctor
                ? booking.provider.image
                : booking.providerDoctor?.image ?? '';
            final DateTime date =
                parseDateAndTime(date: booking.date, time: booking.time);

            return Padding(
              padding: EdgeInsets.only(
                  bottom: index < displayBookings.length - 1 ? 8.h : 0),
              child: UpcomingAppointmentCard(
                imageUrl: imageUrl,
                doctorName: doctorName,
                specialty: specialty,
                location: location,
                date: date,
                isFirst: index == 0,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    RoutesManager.bookingDetails.route,
                    arguments: {
                      'booking-id': booking.id,
                    },
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
