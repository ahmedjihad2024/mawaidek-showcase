part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class InitHomeTabEvent extends HomeEvent {}

class SetLocationCityEvent extends HomeEvent {
  final String? locationAddress;
  final Position? position;
  SetLocationCityEvent({this.locationAddress, this.position});
}

class HomeDataEvent extends HomeEvent {}

class ApplyFilterEvent extends HomeEvent {
  final FilterData filterData;
  final bool? isSearch;
  ApplyFilterEvent({required this.filterData, this.isSearch});
}

class GetProvidersEvent extends HomeEvent {
  final String? search;
  final FilterData filter;
  final bool isRefresh;
  final ProviderType providerType;
  GetProvidersEvent(
      {this.search,
      required this.filter,
      this.isRefresh = false,
      required this.providerType});
}

class NavExploreTapEvent extends HomeEvent {
  ProviderType type;
  NavExploreTapEvent({required this.type});
}

class LogoutEvent extends HomeEvent {
  final VoidCallback? onSuccess;
  LogoutEvent({this.onSuccess});
}

class DeleteAccountEvent extends HomeEvent {
  // final String password;
  final VoidCallback? onSuccess;
  DeleteAccountEvent(
      {
      // required this.password,
      this.onSuccess});
}

class GetBookingsEvent extends HomeEvent {
  final BookingStatusApp statusApp;
  final bool isRefresh;
  GetBookingsEvent({required this.statusApp, this.isRefresh = false});
}

class HandleUserDateEvent extends HomeEvent{}

class UpdateBookingRatedEvent extends HomeEvent {
  final int bookingId;
  UpdateBookingRatedEvent({required this.bookingId});
}

class RefreshHomeEvent extends HomeEvent{}
class ToggleFavoriteEvent extends HomeEvent {
  final Provider provider;
  ToggleFavoriteEvent({required this.provider});
}

class CancelBookingUpdateEvent extends HomeEvent {
  final int bookingId;
  CancelBookingUpdateEvent({required this.bookingId});
}

class GetProfileEvent extends HomeEvent {}
