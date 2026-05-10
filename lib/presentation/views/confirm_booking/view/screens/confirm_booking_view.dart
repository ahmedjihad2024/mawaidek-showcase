import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/presentation/common/ui_components/default_app_bar.dart';
import 'package:mawadk/presentation/common/ui_components/circular_progress_indicator.dart';
import 'package:mawadk/presentation/common/ui_components/error_widget.dart';
import 'package:mawadk/presentation/common/utils/state_render.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/confirm_booking/bloc/confirm_booking_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mawadk/presentation/views/confirm_booking/view/widgets/confirm_booking_bottom_bar.dart';
import 'package:mawadk/presentation/views/confirm_booking/view/widgets/confirm_booking_doctor_card.dart';
import 'package:mawadk/presentation/views/confirm_booking/view/widgets/confirm_booking_fees_summary.dart';
import 'package:mawadk/presentation/views/confirm_booking/view/widgets/confirm_booking_payment_section.dart';
import 'package:mawadk/presentation/views/confirm_booking/view/widgets/confirm_booking_terms_and_conditions.dart';

class ConfirmBookingView extends StatefulWidget {
  final int providerId;
  final int? providerDoctorId;
  final DateTime date;
  final String time;
  final BookingPeriod period;
  final ProviderType providerType;
  const ConfirmBookingView(
      {super.key,
      required this.providerId,
      this.providerDoctorId,
      required this.date,
      required this.time,
      required this.period,
      required this.providerType});

  @override
  State<ConfirmBookingView> createState() => _ConfirmBookingViewState();
}

class _ConfirmBookingViewState extends State<ConfirmBookingView> {
  ConfirmBookingState get state => context.read<ConfirmBookingBloc>().state;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfirmBookingBloc, ConfirmBookingState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                DefaultAppBar(
                  title: Translation.confirm_booking.tr,
                  backFunction: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: ScreenState.setState(
                    reqState: state.reqState,
                    loading: () => const Center(
                      child: MyCircularProgressIndicator(),
                    ),
                    error: () => Center(
                      child: MyErrorWidget(
                        onRetry: () {
                          context.read<ConfirmBookingBloc>().add(
                                GetBookingConfirmEvent(
                                  providerId: widget.providerId,
                                  providerDoctorId: widget.providerDoctorId,
                                ),
                              );
                        },
                        errorMessage: state.errorState,
                      ),
                    ),
                    online: () {
                      final confirmData = state.confirmData;
                      if (confirmData == null) {
                        return Center(
                          child: Text(
                            Translation.no_result_available.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: SizeM.pagePadding.dg,
                            right: SizeM.pagePadding.dg,
                            bottom: 24.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16.h),
                              ConfirmBookingDoctorCard(
                                confirmData: confirmData,
                                providerType: widget.providerType,
                                date: widget.date,
                                time: widget.time,
                              ),
                              SizedBox(height: 24.h),
                              ConfirmBookingPaymentSection(state: state),
                              SizedBox(height: 16.h),
                              ConfirmBookingFeesSummary(confirmData: confirmData),
                              SizedBox(height: 16.h),
                              ConfirmBookingTermsAndConditions(state: state),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (state.reqState == ReqState.success)
                  ConfirmBookingBottomBar(
                    state: state,
                    providerId: widget.providerId,
                    providerDoctorId: widget.providerDoctorId,
                    date: widget.date,
                    time: widget.time,
                    period: widget.period,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

