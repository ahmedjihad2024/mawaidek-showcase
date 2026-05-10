import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/app/extensions.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/presentation/common/ui_components/circular_progress_indicator.dart';
import 'package:mawadk/presentation/common/ui_components/customized_smart_refresh.dart';
import 'package:mawadk/presentation/common/ui_components/error_widget.dart';
import 'package:mawadk/presentation/common/utils/after_layout.dart';
import 'package:mawadk/presentation/common/utils/fast_function.dart';
import 'package:mawadk/presentation/common/utils/state_render.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';
import 'package:mawadk/presentation/views/home/view/widgets/booking_card.dart';
import 'package:mawadk/presentation/res/routes_manager.dart';
import 'package:mawadk/presentation/views/cancel_booking/view/cancel_booking_bottom_sheet.dart';
import 'package:mawadk/app/services/sadad_payment_runner.dart';

class SubBookingsTapView extends StatefulWidget {
  final BookingType bookingType;
  const SubBookingsTapView({super.key, required this.bookingType});

  @override
  State<SubBookingsTapView> createState() => _SubBookingsTapViewState();
}

class _SubBookingsTapViewState extends State<SubBookingsTapView>
    with AutomaticKeepAliveClientMixin, AfterLayout {
  BookingType get bookingType => widget.bookingType;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return ScreenState.setState(
            reqState: switch (bookingType) {
              BookingType.upcoming => state.upcomingBookingsReqState,
              BookingType.completed => state.completedBookingsReqState,
              BookingType.cancelled => state.cancelledBookingsReqState,
            },
            loading: () {
              return MyCircularProgressIndicator();
            },
            empty: () {
              return InkWell(
                onTap: () {
                  context.read<HomeBloc>().add(GetBookingsEvent(
                        statusApp: bookingType.bookingStatusApp,
                        isRefresh: true,
                      ));
                },
                child: Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
                    child: Text(
                      Translation.no_result_available.tr,
                      textAlign: TextAlign.center,
                      style: context.labelMedium.copyWith(
                        fontWeight: FontWeightM.medium,
                      ),
                    ),
                  ),
                ),
              );
            },
            error: () {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
                child: MyErrorWidget(
                    onRetry: () {
                      context.read<HomeBloc>().add(GetBookingsEvent(
                            statusApp: bookingType.bookingStatusApp,
                            isRefresh: true,
                          ));
                    },
                    errorMessage: switch (bookingType) {
                      BookingType.upcoming => state.upcomingBookingsErrorState,
                      BookingType.completed =>
                        state.completedBookingsErrorState,
                      BookingType.cancelled =>
                        state.cancelledBookingsErrorState,
                    }),
              );
            },
            online: () {
              return CustomizedSmartRefresh(
                controller: context
                    .read<HomeBloc>()
                    .getBookingsController(bookingType.bookingStatusApp),
                enableLoading: true,
                onRefresh: () {
                  context.read<HomeBloc>().add(GetBookingsEvent(
                        statusApp: bookingType.bookingStatusApp,
                        isRefresh: true,
                      ));
                },
                onLoading: () {
                  context.read<HomeBloc>().add(GetBookingsEvent(
                        statusApp: bookingType.bookingStatusApp,
                        isRefresh: false,
                      ));
                },
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                          horizontal: SizeM.pagePadding.dg) +
                      EdgeInsets.only(bottom: SizeM.pagePadding.dg, top: 5.h),
                  itemCount: switch (bookingType) {
                    BookingType.upcoming => state.upcomingBookings.length,
                    BookingType.completed => state.completedBookings.length,
                    BookingType.cancelled => state.cancelledBookings.length,
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    Booking booking = switch (bookingType) {
                      BookingType.upcoming => state.upcomingBookings[index],
                      BookingType.completed => state.completedBookings[index],
                      BookingType.cancelled => state.cancelledBookings[index],
                    };

                    bool isDoctor = booking.provider.type.isDoctor;
                    String doctorName = isDoctor
                        ? booking.provider.name
                        : booking.providerDoctor?.name ?? '';
                    String specialty = isDoctor
                        ? booking.provider.category?.name ?? ''
                        : booking.providerDoctor?.category.name ?? '';
                    String location = isDoctor
                        ? booking.provider.address
                        : booking.providerDoctor?.provider.address ?? '';
                    String imageUrl = isDoctor
                        ? booking.provider.image
                        : booking.providerDoctor?.image ?? '';
                    DateTime date = parseDateAndTime(
                        date: booking.date, time: booking.time);
                    var status = switch (bookingType) {
                      BookingType.upcoming => BookingStatus.upcoming,
                      BookingType.completed => BookingStatus.completed,
                      BookingType.cancelled => BookingStatus.cancelled,
                    };
                    return switch (bookingType) {
                      BookingType.upcoming => BookingCard(
                          imageUrl: imageUrl,
                          doctorName: doctorName,
                          specialty: specialty,
                          date: date,
                          location: location,
                          status: status,
                          isRated: booking.isRated,
                          total: booking.total,
                          invoiceNumber: booking.invoiceNumber,
                          paymentMethod: booking.paymentMethod,
                          paymentStatus: booking.paymentStatus,
                          // Surface the Resume-Payment CTA at list level
                          // so the user can recover from a half-finished
                          // Sadad session without opening the booking.
                          canResumePayment: booking.canResumeOnlinePayment,
                          onResumePayment: () {
                            _resumeOnlinePayment(booking);
                          },
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                RoutesManager.bookingDetails.route,
                                arguments: {
                                  'booking-id': booking.id,
                                  'on-review-submitted': () {
                                    context.read<HomeBloc>().add(
                                          UpdateBookingRatedEvent(
                                            bookingId: booking.id,
                                          ),
                                        );
                                  },
                                  'on-booking-cancelled': () {
                                    context.read<HomeBloc>().add(
                                          CancelBookingUpdateEvent(
                                            bookingId: booking.id,
                                          ),
                                        );
                                  },
                                });
                          },
                          onCancel: () {
                            CancelBookingBottomSheet.show(context, booking.id)
                                .then((result) {
                              if (result == true && mounted) {
                                context.read<HomeBloc>().add(
                                      CancelBookingUpdateEvent(
                                        bookingId: booking.id,
                                      ),
                                    );
                              }
                            });
                          },
                        ),
                      BookingType.completed => BookingCard(
                          imageUrl: imageUrl,
                          doctorName: doctorName,
                          specialty: specialty,
                          date: date,
                          location: location,
                          status: status,
                          isRated: booking.isRated,
                          total: booking.total,
                          invoiceNumber: booking.invoiceNumber,
                          paymentMethod: booking.paymentMethod,
                          paymentStatus: booking.paymentStatus,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                RoutesManager.bookingDetails.route,
                                arguments: {
                                  'booking-id': booking.id,
                                  'on-review-submitted': () {
                                    context.read<HomeBloc>().add(
                                          UpdateBookingRatedEvent(
                                            bookingId: booking.id,
                                          ),
                                        );
                                  },
                                });
                          },
                          onReBook: () {
                            Category category = booking.provider.type.isDoctor
                                ? (booking.provider.category ??
                                    booking.provider.categories!.first)
                                : booking.providerDoctor!.category;
                            Navigator.of(context).pushNamed(
                              RoutesManager.appointmentBooking.route,
                              arguments: {
                                'provider-id': booking.provider.id,
                                'provider-name': booking.provider.name,
                                'department': category,
                                'provider-type': booking.provider.type,
                              },
                            );
                          },
                          onAddReview: () {
                            Navigator.of(context).pushNamed(
                              RoutesManager.review.route,
                              arguments: {
                                'booking-id': booking.id,
                                'provider-type': booking.provider.type,
                                'doctor-image': imageUrl,
                                'doctor-name': doctorName,
                              },
                            ).then((result) {
                              if (result == true && mounted) {
                                // Update booking state in HomeBloc
                                context.read<HomeBloc>().add(
                                      UpdateBookingRatedEvent(
                                        bookingId: booking.id,
                                      ),
                                    );
                              }
                            });
                          },
                        ),
                      BookingType.cancelled => BookingCard(
                          imageUrl: imageUrl,
                          doctorName: doctorName,
                          specialty: specialty,
                          date: date,
                          location: location,
                          status: status,
                          isRated: booking.isRated,
                          total: booking.total,
                          invoiceNumber: booking.invoiceNumber,
                          paymentMethod: booking.paymentMethod,
                          paymentStatus: booking.paymentStatus,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                RoutesManager.bookingDetails.route,
                                arguments: {
                                  'status': BookingStatus.cancelled,
                                  'booking-id': booking.id,
                                });
                          },
                        ),
                    };
                  },
                ),
              );
            });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> afterLayout(BuildContext context) async {
    context.read<HomeBloc>().add(GetBookingsEvent(
          statusApp: bookingType.bookingStatusApp,
          isRefresh: true,
        ));
  }

  /// Resume a half-finished online payment for the given booking.
  /// Routes through SadadPaymentRunner.resume() so the SDK loop, retry
  /// dialog, and status-poll handshake all match the initial-booking
  /// path.
  ///
  /// Outcome handling:
  ///   - success    → refresh the bookings list so the card flips from
  ///                  pending → paid without a manual pull-to-refresh
  ///   - cancelled / failed / pendingVerify → push booking-details so
  ///                  the user sees the explanation banner
  ///   - dismissed  → stay on the list (booking still pending; the
  ///                  Resume CTA on the card stays visible)
  Future<void> _resumeOnlinePayment(Booking booking) async {
    final isDoctor = booking.provider.type.isDoctor;
    final doctorName = isDoctor
        ? booking.provider.name
        : booking.providerDoctor?.name ?? '';

    final runner = SadadPaymentRunner(
      context: context,
      providerId: booking.provider.id,
      providerDoctorId: booking.providerDoctor?.id,
      // Informational only — runner.resume() doesn't re-create the booking.
      date: parseDateAndTime(date: booking.date, time: booking.time),
      time: booking.time,
      period: booking.period == 'morning'
          ? BookingPeriod.morning
          : BookingPeriod.evening,
      doctorName: doctorName,
      onSuccess: () {
        if (!mounted) return;
        context.read<HomeBloc>().add(GetBookingsEvent(
              statusApp: bookingType.bookingStatusApp,
              isRefresh: true,
            ));
      },
    );
    final result = await runner.resume(booking.id);
    if (!mounted) return;

    switch (result.outcome) {
      case PaymentRunnerOutcome.success:
        // Already handled by onSuccess above (list refresh).
        return;
      case PaymentRunnerOutcome.cancelled:
      case PaymentRunnerOutcome.failed:
      case PaymentRunnerOutcome.pendingVerify:
        // Push booking-details so the user sees the system explanation
        // banner. We don't replace because the bookings list IS the
        // home root.
        await Navigator.of(context).pushNamed(
          RoutesManager.bookingDetails.route,
          arguments: {'booking-id': booking.id},
        );
        // After they come back from booking-details, refresh the list.
        if (!mounted) return;
        context.read<HomeBloc>().add(GetBookingsEvent(
              statusApp: bookingType.bookingStatusApp,
              isRefresh: true,
            ));
        return;
      case PaymentRunnerOutcome.dismissed:
      case PaymentRunnerOutcome.gatewayUnavailable:
      case PaymentRunnerOutcome.bookingCreateFailed:
        // Stay on the list — Resume CTA stays visible so the user can
        // try again whenever they want.
        return;
    }
  }
}
