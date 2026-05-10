part of 'confirm_booking_bloc.dart';

sealed class ConfirmBookingEvent extends Equatable {
  const ConfirmBookingEvent();

  @override
  List<Object> get props => [];
}

class GetBookingConfirmEvent extends ConfirmBookingEvent {
  final int providerId;
  final int? providerDoctorId;

  const GetBookingConfirmEvent({
    required this.providerId,
    this.providerDoctorId,
  });

  @override
  List<Object> get props => [providerId, providerDoctorId ?? 0];
}

class UpdatePaymentMethodEvent extends ConfirmBookingEvent {
  final PaymentMethod paymentMethod;

  const UpdatePaymentMethodEvent({required this.paymentMethod});

  @override
  List<Object> get props => [paymentMethod];
}

class ToggleTermsAcceptedEvent extends ConfirmBookingEvent {}

class CreateBookingEvent extends ConfirmBookingEvent {
  final int providerId;
  final int? providerDoctorId;
  final DateTime date;
  final String time;
  final BookingPeriod period;
  final PaymentMethod paymentMethod;
  final VoidCallback onSuccess;

  const CreateBookingEvent({
    required this.providerId,
    this.providerDoctorId,
    required this.date,
    required this.time,
    required this.period,
    required this.paymentMethod,
    required this.onSuccess,
  });

  @override
  List<Object> get props => [providerId, providerDoctorId ?? 0, date, time, period, paymentMethod];
}
