import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mawadk/presentation/common/ui_components/circular_progress_indicator.dart';
import 'package:mawadk/presentation/common/ui_components/customized_smart_refresh.dart';
import 'package:mawadk/presentation/common/ui_components/error_widget.dart';
import 'package:mawadk/presentation/common/utils/state_render.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/appointment_booking/bloc/appointment_booking_bloc.dart';
import 'package:mawadk/presentation/views/appointment_booking/view/widgets/available_doctor_card.dart';

class AppointmentAvailableDoctorsSection extends StatelessWidget {
  final AppointmentBookingState state;

  const AppointmentAvailableDoctorsSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ScreenState.setState(
      reqState: state.doctorsReqState,
      loading: () => Padding(
        padding: EdgeInsets.all(24.w),
        child: const MyCircularProgressIndicator(),
      ),
      error: () => Padding(
        padding: EdgeInsets.all(24.w),
        child: MyErrorWidget(
          onRetry: () {
            context.read<AppointmentBookingBloc>().add(
                  GetAvailableDoctorsEvent(
                      time: state.selectedTime, refresh: true),
                );
          },
          errorMessage: state.doctorsErrorState,
        ),
      ),
      empty: () => Padding(
        padding: EdgeInsets.all(24.w),
        child: Text(
          Translation.no_doctors_available.tr,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF6B7280),
          ),
        ),
      ),
      online: () {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Translation.available_doctors.tr,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeightM.semiBold,
                      color: const Color(0xFF1C2A3A),
                      height: 1.5,
                    ),
                  ),
                  Text(
                    Translation.doctors_available
                        .trNamed({'count': state.doctors.length.toString()}),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeightM.semiBold,
                      color: const Color.fromRGBO(36, 101, 101, 176),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            SizedBox(
              height: .4.sh,
              child: CustomizedSmartRefresh(
                controller:
                    context.read<AppointmentBookingBloc>().refreshController,
                enableLoading: true,
                onRefresh: () {
                  context.read<AppointmentBookingBloc>().add(
                        GetAvailableDoctorsEvent(
                          time: state.selectedTime,
                          refresh: true,
                        ),
                      );
                },
                onLoading: () {
                  context.read<AppointmentBookingBloc>().add(
                        GetAvailableDoctorsEvent(
                          time: state.selectedTime,
                          refresh: false,
                        ),
                      );
                },
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeM.pagePadding.dg,
                    vertical: SizeM.pagePadding.dg,
                  ),
                  itemCount: state.doctors.length,
                  itemBuilder: (con, index) {
                    final doctor = state.doctors[index];
                    return AvailableDoctorsCard(
                      onTap: () {
                        context.read<AppointmentBookingBloc>().add(
                              SelectProviderDoctorEvent(
                                providerDoctor: doctor,
                              ),
                            );
                      },
                      imageUrl: doctor.image,
                      name: doctor.name,
                      specialty: doctor.category.name,
                      rating: doctor.rating,
                      price: double.parse(doctor.priceAfterDiscount),
                      experienceInYears: doctor.experienceYears,
                      isSelected: state.selectedProviderDoctor == doctor,
                    );
                  },
                  separatorBuilder: (con, index) {
                    return SizedBox(height: 10.w);
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
