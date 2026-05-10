part of 'appointment_booking_bloc.dart';

class AppointmentBookingState extends Equatable {
  final ReqState availableTimesReqState;
  final String availableTimesErrorState;
  final BookingAvailableTimesData? availableTimesData;

  final ReqState doctorsReqState;
  final String doctorsErrorState;
  final List<ProviderDoctor> doctors;

  final String? selectedTime;
  final BookingPeriod? selectedPeriod;
  final DateTime selectedDate;
  final bool isThisBookingIsDoctor;

  final ProviderDoctor? selectedProviderDoctor;
  bool get isConfrirmButtonEnabled =>
      (selectedProviderDoctor != null || isThisBookingIsDoctor) &&
      selectedTime != null &&
      selectedPeriod != null;

  AppointmentBookingState({
    this.availableTimesReqState = ReqState.loading,
    this.availableTimesErrorState = '',
    this.availableTimesData,
    this.doctorsReqState = ReqState.idle,
    this.doctorsErrorState = '',
    this.doctors = const [],
    this.selectedTime,
    this.selectedPeriod,
    required this.selectedDate,
    this.selectedProviderDoctor,
    this.isThisBookingIsDoctor = false
  });

  AppointmentBookingState copyWith({
    ReqState? availableTimesReqState,
    String? availableTimesErrorState,
    BookingAvailableTimesData? availableTimesData,
    ReqState? doctorsReqState,
    String? doctorsErrorState,
    List<ProviderDoctor>? doctors,
    String? selectedTime,
    BookingPeriod? selectedPeriod,
    DateTime? selectedDate,
    ProviderDoctor? selectedProviderDoctor,
    bool? isThisBookingIsDoctor
  }) {
    return AppointmentBookingState(
      availableTimesReqState:
          availableTimesReqState ?? this.availableTimesReqState,
      availableTimesErrorState:
          availableTimesErrorState ?? this.availableTimesErrorState,
      availableTimesData: availableTimesData ?? this.availableTimesData,
      doctorsReqState: doctorsReqState ?? this.doctorsReqState,
      doctorsErrorState: doctorsErrorState ?? this.doctorsErrorState,
      doctors: doctors ?? this.doctors,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      selectedDate: selectedDate ?? this.selectedDate,
      isThisBookingIsDoctor: isThisBookingIsDoctor ?? this.isThisBookingIsDoctor,
      selectedProviderDoctor:
          selectedProviderDoctor ?? this.selectedProviderDoctor,
    );
  }

  AppointmentBookingState clearSelections({
      bool clearDoctors = false,
      bool clearSelectedTime = false,
      bool clearSelectedPeriod = false, 
      bool clearSelectedProviderDoctor = false,
  }) {
    return AppointmentBookingState(
      availableTimesReqState: this.availableTimesReqState,
      availableTimesErrorState: this.availableTimesErrorState,
      availableTimesData: this.availableTimesData,
      doctorsReqState: this.doctorsReqState,
      doctorsErrorState: this.doctorsErrorState,
      doctors: clearDoctors ? [] : this.doctors,
      selectedTime: clearSelectedTime ? null : this.selectedTime,
      selectedPeriod: clearSelectedPeriod ? null : this.selectedPeriod,
      selectedDate: this.selectedDate,
      selectedProviderDoctor: clearSelectedProviderDoctor ? null : this.selectedProviderDoctor,
      isThisBookingIsDoctor: this.isThisBookingIsDoctor
    );
  }

  @override
  List<Object?> get props => [
        availableTimesReqState,
        availableTimesErrorState,
        availableTimesData,
        doctorsReqState,
        doctorsErrorState,
        doctors,
        selectedTime,
        selectedPeriod,
        selectedDate,
        selectedProviderDoctor,
        isThisBookingIsDoctor
      ];
}
