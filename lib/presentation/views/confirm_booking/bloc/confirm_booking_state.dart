part of 'confirm_booking_bloc.dart';

class ConfirmBookingState extends Equatable {
  final ReqState reqState;
  final String errorState;
  final BookingConfirmData? confirmData;
  final PaymentMethod paymentMethod;
  final bool termsAccepted;

  bool get isConfrirmButtonEnabled => termsAccepted;

  const ConfirmBookingState({
    this.reqState = ReqState.loading,
    this.errorState = '',
    this.confirmData,
    this.paymentMethod = PaymentMethod.cash,
    this.termsAccepted = false,
  });

  ConfirmBookingState copyWith({
    ReqState? reqState,
    String? errorState,
    BookingConfirmData? confirmData,
    PaymentMethod? paymentMethod,
    bool? termsAccepted,
  }) {
    return ConfirmBookingState(
      reqState: reqState ?? this.reqState,
      errorState: errorState ?? this.errorState,
      confirmData: confirmData ?? this.confirmData,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      termsAccepted: termsAccepted ?? this.termsAccepted,
    );
  }

  @override
  List<Object?> get props =>
      [reqState, errorState, confirmData, paymentMethod, termsAccepted];
}
