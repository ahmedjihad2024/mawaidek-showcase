part of 'appointment_booking_bloc.dart';

sealed class AppointmentBookingEvent {
  const AppointmentBookingEvent();
}

class GetAvailableTimesEvent extends AppointmentBookingEvent {
  final DateTime date;
  final int categoryId;
  final int providerId;

  const GetAvailableTimesEvent({
    required this.date,
    required this.categoryId,
    required this.providerId,
  });
}

class GetAvailableDoctorsEvent extends AppointmentBookingEvent {
  final String? time;
  final bool refresh;

  const GetAvailableDoctorsEvent({
    this.time,
    this.refresh = true,
  });
}

class SelectTimeSlotEvent extends AppointmentBookingEvent {
  final String time;
  final BookingPeriod period;

  const SelectTimeSlotEvent({
    required this.time,
    required this.period,
  });
}

class SelectProviderDoctorEvent extends AppointmentBookingEvent {
  final ProviderDoctor providerDoctor;

  const SelectProviderDoctorEvent({
    required this.providerDoctor,
  });
}

class SetIsBookingDoctorEvent extends AppointmentBookingEvent {}
