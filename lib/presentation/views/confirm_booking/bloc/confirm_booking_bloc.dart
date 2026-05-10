import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/app/user_messages.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/usecase/booking_confirm_usecase.dart';
import 'package:mawadk/domain/usecase/booking_create_usecase.dart';
import 'package:mawadk/presentation/common/utils/overlay_loading.dart';
import 'package:mawadk/presentation/common/utils/snackbar_helper.dart';
import 'package:mawadk/presentation/common/utils/state_render.dart';
import '../../../../app/dependency_injection.dart';

part 'confirm_booking_event.dart';
part 'confirm_booking_state.dart';

class ConfirmBookingBloc
    extends Bloc<ConfirmBookingEvent, ConfirmBookingState> {
  ConfirmBookingBloc() : super(const ConfirmBookingState()) {
    on<GetBookingConfirmEvent>(_onGetBookingConfirmEvent);
    on<UpdatePaymentMethodEvent>(_onUpdatePaymentMethodEvent);
    on<ToggleTermsAcceptedEvent>(_onToggleTermsAcceptedEvent);
    on<CreateBookingEvent>(_onCreateBookingEvent);
  }

  Future<void> _onToggleTermsAcceptedEvent(
    ToggleTermsAcceptedEvent event,
    Emitter<ConfirmBookingState> emit,
  ) async {
    emit(state.copyWith(termsAccepted: !state.termsAccepted));
  }

  Future<void> _onUpdatePaymentMethodEvent(
    UpdatePaymentMethodEvent event,
    Emitter<ConfirmBookingState> emit,
  ) async {
    if (state.paymentMethod.isCash != event.paymentMethod.isCash)
      emit(state.copyWith(paymentMethod: event.paymentMethod));
  }

  Future<void> _onGetBookingConfirmEvent(
    GetBookingConfirmEvent event,
    Emitter<ConfirmBookingState> emit,
  ) async {
    emit(state.copyWith(reqState: ReqState.loading));

    final request = BookingConfirmRequest(
      providerId: event.providerId,
      providerDoctorId: event.providerDoctorId,
    );

    final result = await instance<BookingConfirmUseCase>().execute(request);

    result.fold(
      (failure) {
        emit(state.copyWith(
          reqState: ReqState.error,
          errorState: failure.userMessage,
        ));
      },
      (response) {
        if (response.data != null) {
          emit(state.copyWith(
            reqState: ReqState.success,
            confirmData: response.data!,
          ));
        } else {
          emit(state.copyWith(
            reqState: ReqState.error,
            errorState: 'No data available',
          ));
        }
      },
    );
  }

  Future<void> _onCreateBookingEvent(
    CreateBookingEvent event,
    Emitter<ConfirmBookingState> emit,
  ) async {
    OverlayLoading.instance.show();

    // Convert time from "12:00 PM" format to "HH:mm" format
    final parsed = DateFormat('hh:mm a', 'en').parse(event.time.trim());
    final time24Hour = DateFormat('HH:mm', 'en').format(parsed);

    final request = BookingCreateRequest(
      providerId: event.providerId,
      providerDoctorId: event.providerDoctorId,
      date: event.date,
      time: time24Hour,
      period: event.period,
      paymentMethod: event.paymentMethod,
    );

    final result = await instance<BookingCreateUseCase>().execute(request);

    result.fold(
      (failure) {
        print(failure);
        OverlayLoading.instance.hide();
        SnackbarHelper.showMessage(failure.userMessage, ErrorMessage.snackBar);
      },
      (response) {
        OverlayLoading.instance.hide();
        event.onSuccess();
      },
    );
  }
}
