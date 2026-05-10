part of 'booking_details_bloc.dart';

class BookingDetailsState extends Equatable {
  final ReqState reqState;
  final String errorMessage;
  final Booking? booking;
  const BookingDetailsState({
    this.reqState = ReqState.loading,
    this.errorMessage = '',
    this.booking,
  });

  @override
  List<Object?> get props => [reqState, errorMessage, booking];

  BookingDetailsState copyWith({
    ReqState? reqState,
    String? errorMessage,
    Booking? booking,
  }) {
    return BookingDetailsState(
        reqState: reqState ?? this.reqState,
        errorMessage: errorMessage ?? this.errorMessage,
        booking: booking ?? this.booking);
  }
}
