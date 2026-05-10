import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mawadk/app/dependency_injection.dart';
import 'package:mawadk/app/services/app_preferences.dart';
import 'package:mawadk/app/user_messages.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/usecase/booking_show_usecase.dart';
import 'package:mawadk/presentation/common/utils/state_render.dart';

part 'booking_details_event.dart';
part 'booking_details_state.dart';

class BookingDetailsBloc
    extends Bloc<BookingDetailsEvent, BookingDetailsState> {
  BookingDetailsBloc() : super(BookingDetailsState()) {
    on<GetBookingDetailsEvent>(_onGetBookingDetailsEvent);
    on<UpdateBookingRatedEvent>(_onUpdateBookingRatedEvent);
  }

  Future<void> _onGetBookingDetailsEvent(
    GetBookingDetailsEvent event,
    Emitter<BookingDetailsState> emit,
  ) async {
    emit(state.copyWith(reqState: ReqState.loading));

    var addressDetails = await instance<AppPreferences>().getLocationData();

    final result = await instance<BookingShowUseCase>().execute(
        BookingShowUseCaseInput(
            id: event.bookingId,
            lat: addressDetails.latitude,
            lng: addressDetails.longitude));

    result.fold(
      (failure) {
        emit(state.copyWith(
            reqState: ReqState.error, errorMessage: failure.userMessage));
      },
      (response) {
        emit(
            state.copyWith(reqState: ReqState.success, booking: response.data));
      },
    );
  }

  Future<void> _onUpdateBookingRatedEvent(
    UpdateBookingRatedEvent event,
    Emitter<BookingDetailsState> emit,
  ) async {
    if (state.booking != null && state.booking!.id == event.bookingId) {
      // Create a new Booking object with isRated = true
      final updatedBooking = Booking(
        id: state.booking!.id,
        invoiceNumber: state.booking!.invoiceNumber,
        isRated: true, // Update isRated
        provider: state.booking!.provider,
        subtotal: state.booking!.subtotal,
        total: state.booking!.total,
        status: state.booking!.status,
        date: state.booking!.date,
        time: state.booking!.time,
        period: state.booking!.period,
        paymentMethod: state.booking!.paymentMethod,
        providerDoctor: state.booking!.providerDoctor,
        createdAt: state.booking!.createdAt,
        feeServices: state.booking!.feeServices,
      );
      emit(state.copyWith(booking: updatedBooking));
    }
  }

}
