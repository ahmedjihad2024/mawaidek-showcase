part of 'services_bloc.dart';

@immutable
sealed class ServicesEvent {}

class GetProviderShowEvent extends ServicesEvent {
  final int providerId;
  final double? lat;
  final double? lng;

  GetProviderShowEvent({
    required this.providerId,
    this.lat,
    this.lng,
  });
}

class SelectDepartmentEvent extends ServicesEvent {
  final Category? category;

  SelectDepartmentEvent(this.category);
}


class ToggleFavoriteEvent extends ServicesEvent {
  ToggleFavoriteEvent();
}

