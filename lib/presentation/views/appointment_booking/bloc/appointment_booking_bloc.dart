import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/app/user_messages.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/usecase/booking_available_times_usecase.dart';
import 'package:mawadk/domain/usecase/providers_doctors_usecase.dart';
import 'package:mawadk/presentation/common/_template/pagination_mixin_class.dart';
import 'package:mawadk/presentation/common/utils/state_render.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../app/dependency_injection.dart';

part 'appointment_booking_event.dart';
part 'appointment_booking_state.dart';

class AppointmentBookingBloc
    extends Bloc<AppointmentBookingEvent, AppointmentBookingState>
    with PaginationMixin {
  AppointmentBookingBloc({
    required this.providerId,
    required this.categoryId,
  }) : super(AppointmentBookingState(selectedDate: DateTime.now())) {
    on<GetAvailableTimesEvent>(_onGetAvailableTimesEvent);
    on<GetAvailableDoctorsEvent>(_onGetAvailableDoctorsEvent);
    on<SelectTimeSlotEvent>(_onSelectTimeSlotEvent);
    on<SelectProviderDoctorEvent>(_onSelectProviderDoctorEvent);
    on<SetIsBookingDoctorEvent>(_onSetIsBookingDoctorEvent);
  }

  final int providerId;
  final int categoryId;
  final RefreshController refreshController = RefreshController();

  Future<void> _onSetIsBookingDoctorEvent(
    SetIsBookingDoctorEvent event,
    Emitter<AppointmentBookingState> emit,
  ) async {
    emit(state.copyWith(isThisBookingIsDoctor: true));
  }

  Future<void> _onGetAvailableTimesEvent(
    GetAvailableTimesEvent event,
    Emitter<AppointmentBookingState> emit,
  ) async {
    emit(state.copyWith(
      availableTimesReqState: ReqState.loading,
      // doctorsReqState: ReqState.idle
    ));

    emit(state.clearSelections(
        clearSelectedTime: true,
        clearSelectedPeriod: true,
        clearSelectedProviderDoctor: true));

    final result = await instance<BookingAvailableTimesUseCase>().execute(
      BookingAvailableTimesRequest(
        date: event.date,
        categoryId: event.categoryId,
        providerId: event.providerId,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          availableTimesReqState: ReqState.error,
          availableTimesErrorState: failure.userMessage,
        ));
      },
      (response) {
        if (response.data != null) {
          emit(state.copyWith(
            availableTimesReqState: ReqState.success,
            availableTimesData: response.data!,
            selectedDate: event.date,
            selectedTime: null, // Clear selected time when date changes
            selectedPeriod: null,
            doctors: [], // Clear doctors list
            doctorsReqState: ReqState.idle,
          ));
        } else {
          emit(state.copyWith(
            availableTimesReqState: ReqState.error,
            availableTimesErrorState: Translation.no_result_available.tr,
          ));
        }
      },
    );
  }

  Future<void> _onSelectTimeSlotEvent(
    SelectTimeSlotEvent event,
    Emitter<AppointmentBookingState> emit,
  ) async {
    emit(state.copyWith(
      selectedTime: event.time,
      selectedPeriod: event.period,
      doctorsReqState: state.isThisBookingIsDoctor ? ReqState.idle : ReqState.loading,
      doctors: [], // Clear previous doctors
    ));

    // if isThisBookingIsDoctor with false so that means he does not selected the doctors
    // so lets get the doctores at this time
    if (!state.isThisBookingIsDoctor) {
      // Load doctors for selected time
      add(GetAvailableDoctorsEvent(time: event.time, refresh: true));
    }
  }

  Future<void> _onGetAvailableDoctorsEvent(
    GetAvailableDoctorsEvent event,
    Emitter<AppointmentBookingState> emit,
  ) async {
    if (event.time == null) {
      emit(state.copyWith(doctorsReqState: ReqState.idle, doctors: []));
      return;
    }

    if (event.refresh)
      emit(state.clearSelections(clearSelectedProviderDoctor: true));

    await handlePagination<ProviderDoctor>(
      key: 'doctors',
      controller: refreshController,
      isRefresh: event.refresh,
      emit: emit,
      loadingState: () => state.copyWith(doctorsReqState: ReqState.loading),
      errorState: (errorMessage, reqState) => state.copyWith(
          doctorsReqState: reqState, doctorsErrorState: errorMessage),
      successState: (items, isRefresh) {
        return state.copyWith(
          doctors: items,
          doctorsReqState: items.isEmpty ? ReqState.empty : ReqState.success,
          doctorsErrorState: '',
        );
      },
      currentItems: state.doctors,
      fetchData: (page) async {
        final response = await instance<ProvidersDoctorsUseCase>().execute(
          ProvidersDoctorsRequest(
            providerId: providerId,
            categoryId: categoryId,
            date: state.selectedDate,
            time: event.time == null
                ? null
                : DateFormat('HH:mm', 'en').format(
                    DateFormat('hh:mm a', 'en').parse(event.time!.trim())),
            page: page,
          ),
        );
        return response.fold(
          (failure) => Left(failure),
          (data) => Right(PaginatedResponse<ProviderDoctor>(
            items: data.data?.items ?? [],
            meta: PaginationMeta(
              currentPage: data.data?.meta.currentPage ?? 1,
              lastPage: data.data?.meta.lastPage ?? 1,
              total: data.data?.meta.total ?? 0,
            ),
          )),
        );
      },
    );
  }

  Future<void> _onSelectProviderDoctorEvent(
    SelectProviderDoctorEvent event,
    Emitter<AppointmentBookingState> emit,
  ) async {
    emit(state.copyWith(selectedProviderDoctor: event.providerDoctor));
  }

  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }
}
