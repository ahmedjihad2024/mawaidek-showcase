import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/presentation/common/utils/after_layout.dart';
import 'package:mawadk/presentation/views/appointment_booking/bloc/appointment_booking_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/presentation/views/appointment_booking/view/widgets/appointment_app_bar.dart';
import 'package:mawadk/presentation/views/appointment_booking/view/widgets/appointment_info_section.dart';
import 'package:mawadk/presentation/views/appointment_booking/view/widgets/appointment_select_date_section.dart';
import 'package:mawadk/presentation/views/appointment_booking/view/widgets/appointment_select_hour_section.dart';
import 'package:mawadk/presentation/views/appointment_booking/view/widgets/appointment_available_doctors_section.dart';
import 'package:mawadk/presentation/views/appointment_booking/view/widgets/appointment_bottom_bar.dart';

class AppointmentBookingView extends StatefulWidget {
  final Category department;
  final ProviderType providerType;
  final String providerName;
  final int providerId;

  const AppointmentBookingView({
    super.key,
    required this.providerId,
    required this.department,
    required this.providerName,
    required this.providerType,
  });

  @override
  State<AppointmentBookingView> createState() => _AppointmentBookingViewState();
}

class _AppointmentBookingViewState extends State<AppointmentBookingView>
    with AfterLayout {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBookingBloc, AppointmentBookingState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // App Bar
                AppointmentAppBar(
                  onBack: () => Navigator.of(context).pop(),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24.h),

                        // Provider Info
                        AppointmentInfoSection(
                          department: widget.department,
                          providerName: widget.providerName,
                        ),
                        SizedBox(height: 24.h),

                        // Select Date
                        AppointmentSelectDateSection(
                          department: widget.department,
                          providerId: widget.providerId,
                        ),
                        SizedBox(height: 32.h),

                        // Select Hour
                        AppointmentSelectHourSection(
                          state: state,
                          department: widget.department,
                          providerId: widget.providerId,
                        ),

                        // Available Doctors (visible only when time is selected)
                        if (state.selectedTime != null) ...[
                          SizedBox(height: 24.h),
                          AppointmentAvailableDoctorsSection(state: state),
                        ],
                      ],
                    ),
                  ),
                ),

                // Bottom Confirm Bar (visible only when time is selected)
                if (state.selectedTime != null)
                  AppointmentBottomBar(
                    state: state,
                    providerId: widget.providerId,
                    providerType: widget.providerType,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Future<void> afterLayout(BuildContext context) async {
    // Booking type is for a doctor
    if (widget.providerType.isDoctor) {
      context.read<AppointmentBookingBloc>().add(SetIsBookingDoctorEvent());
    }
  }
}
