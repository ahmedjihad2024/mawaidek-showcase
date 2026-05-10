part of 'booking_details_bloc.dart';

sealed class BookingDetailsEvent {
  const BookingDetailsEvent();
}

class GetBookingDetailsEvent extends BookingDetailsEvent {
  final int bookingId;
  const GetBookingDetailsEvent({required this.bookingId});
}

class UpdateBookingRatedEvent extends BookingDetailsEvent {
  final int bookingId;
  const UpdateBookingRatedEvent({required this.bookingId});
}
