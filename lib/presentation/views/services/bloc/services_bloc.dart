import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mawadk/app/services/app_preferences.dart';
import 'package:mawadk/app/user_messages.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/usecase/provider_show_usecase.dart';
import 'package:mawadk/presentation/common/utils/state_render.dart';
import '../../../../app/dependency_injection.dart';
import '../../../common/_template/favorite_mixin_class.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState>
    with FavoritesMixin {
  ServicesBloc() : super(const ServicesState()) {
    on<GetProviderShowEvent>(_onGetProviderShowEvent);
    on<SelectDepartmentEvent>(_onSelectDepartmentEvent);
    on<ToggleFavoriteEvent>(_onToggleFavoriteEvent);
  }

  Future<void> _onGetProviderShowEvent(
    GetProviderShowEvent event,
    Emitter<ServicesState> emit,
  ) async {
    emit(state.copyWith(reqState: ReqState.loading));

    var addressDetails = await instance<AppPreferences>().getLocationData();

    final request = ProviderShowRequest(
      id: event.providerId,
      lat: event.lat ?? addressDetails.latitude,
      lng: event.lng ?? addressDetails.longitude,
    );

    final result = await instance<ProviderShowUseCase>().execute(
      ProviderShowUseCaseInput(event.providerId, request),
    );

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
            providerData: response.data!,
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

  Future<void> _onToggleFavoriteEvent(
    ToggleFavoriteEvent event,
    Emitter<ServicesState> emit,
  ) async {
    ServicesState toggleState() {
      state.providerData!.provider.isFavorite =
          !state.providerData!.provider.isFavorite;
      return state.refreshIt;
    }

    await handleToggleFavorite(
        id: state.providerData!.provider.id,
        emit: emit,
        loadingState: toggleState,
        errorState: toggleState);
  }

  Future<void> _onSelectDepartmentEvent(
    SelectDepartmentEvent event,
    Emitter<ServicesState> emit,
  ) async {
    // Toggle selection: if the same category is selected, deselect it
    final newSelectedCategory = state.selectedCategory?.id == event.category?.id
        ? null
        : event.category;

    emit(state.copyWith(selectedCategory: newSelectedCategory));
  }
}
