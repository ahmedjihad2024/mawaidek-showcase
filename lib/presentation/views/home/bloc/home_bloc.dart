import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/app/services/app_preferences.dart';
import 'package:mawadk/app/services/firebase_messeging_services.dart';
import 'package:mawadk/app/user_messages.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/usecase/bookings_usecase.dart';
import 'package:mawadk/domain/usecase/get_profile_usecase.dart';
import 'package:mawadk/domain/usecase/home_usecase.dart';
import 'package:mawadk/domain/usecase/logout_usecase.dart';
import 'package:mawadk/domain/usecase/providers_usecase.dart';
import 'package:mawadk/domain/usecase/remove_account_usecase.dart';
import 'package:mawadk/presentation/common/_template/pagination_mixin_class.dart';
import 'package:mawadk/presentation/common/utils/overlay_loading.dart';
import 'package:mawadk/presentation/common/utils/snackbar_helper.dart';
import 'package:mawadk/presentation/common/utils/state_render.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/home/view/widgets/filter_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../app/dependency_injection.dart';
import '../../../common/_template/favorite_mixin_class.dart';
import '../../../common/utils/favorite_observer.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>
    with PaginationMixin, FavoritesMixin<HomeEvent, HomeState>
    implements FavoritesObserver {
  HomeBloc()
      : super(HomeState(
          clinicsFilter: FilterData(),
          hospitalsFilter: FilterData(),
          doctorsFilter: FilterData(),
          locationCity: Translation.select_your_location.tr,
        )) {
    FavoritesManager.instance.addObserver(this);
    on<SetLocationCityEvent>(_onSetLocationCityEvent);
    on<HomeDataEvent>(_onHomeDataEvent);
    on<ApplyFilterEvent>(_onApplyFilterEvent);
    on<GetProvidersEvent>(_onGetProvidersEvent);
    on<NavExploreTapEvent>(_onNavExploreTapEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<DeleteAccountEvent>(_onDeleteAccountEvent);
    on<GetBookingsEvent>(_onGetBookingsEvent);
    on<HandleUserDateEvent>(_onHandleUserDateEvent);
    on<UpdateBookingRatedEvent>(_onUpdateBookingRatedEvent);
    on<RefreshHomeEvent>((event, emit) => emit(state.refreshIt));
    on<ToggleFavoriteEvent>(_onToggleFavoriteEvent);
    on<CancelBookingUpdateEvent>(_onCancelBookingUpdateEvent);
    on<GetProfileEvent>(_onGetProfileEvent);
    add(HandleUserDateEvent());
  }

  RefreshController refreshHomeController = RefreshController();
  RefreshController profileRefreshController = RefreshController();
  String? oldDoctorsSearch;
  String? oldHospitalsSearch;
  String? oldClinicsSearch;
  RefreshController doctorsController = RefreshController();
  RefreshController hospitalsController = RefreshController();
  RefreshController clinicsController = RefreshController();
  TextEditingController exploreSearchEditingController =
      TextEditingController();

  RefreshController upcomingBookingsController = RefreshController();
  RefreshController completedBookingsController = RefreshController();
  RefreshController cancelledBookingsController = RefreshController();

  RefreshController getBookingsController(BookingStatusApp statusApp) {
    return switch (statusApp) {
      BookingStatusApp.pending || BookingStatusApp.confirmed => upcomingBookingsController,
      BookingStatusApp.completed => completedBookingsController,
      // The 3 negative-scenario buckets all live under the "Cancelled" tab —
      // mirrors BookingStatusApp.isCancelled and the 3-tab UX.
      BookingStatusApp.cancelled ||
      BookingStatusApp.expired ||
      BookingStatusApp.noShow ||
      BookingStatusApp.providerNoShow =>
        cancelledBookingsController,
    };
  }

  RefreshController getTypeController(ProviderType type) {
    return switch (type) {
      ProviderType.Doctor => doctorsController,
      ProviderType.Hospital => hospitalsController,
      ProviderType.Clinic => clinicsController,
    };
  }

  void updateOldSearch(ProviderType type, String? text) {
    switch (type) {
      case ProviderType.Doctor:
        oldDoctorsSearch = text;
        break;
      case ProviderType.Hospital:
        oldHospitalsSearch = text;
        break;
      case ProviderType.Clinic:
        oldClinicsSearch = text;
        break;
    }
  }

  String? get oldSearch => switch (state.selectedExploreTap) {
        ProviderType.Doctor => oldDoctorsSearch,
        ProviderType.Hospital => oldHospitalsSearch,
        ProviderType.Clinic => oldClinicsSearch,
      };

  HomeState updateFilter(ProviderType type, FilterData filter) {
    switch (type) {
      case ProviderType.Doctor:
        return state.copyWith(doctorsFilter: filter);
      case ProviderType.Clinic:
        return state.copyWith(clinicsFilter: filter);
      case ProviderType.Hospital:
        return state.copyWith(hospitalsFilter: filter);
    }
  }

  Future<void> _onNavExploreTapEvent(
    NavExploreTapEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(selectedExploreTap: event.type));
    exploreSearchEditingController.text = oldSearch ?? '';
  }

  Future<void> _onHandleUserDateEvent(
    HandleUserDateEvent event,
    Emitter<HomeState> emit,
  ) async {
    var userDetails = await instance<AppPreferences>().userData;
    if (userDetails != null) {
      emit(state.copyWith(
          phoneNumber: userDetails.phone,
          name: userDetails.name,
          image: userDetails.image));
    }
  }

  Future<void> _onApplyFilterEvent(
    ApplyFilterEvent event,
    Emitter<HomeState> emit,
  ) async {
    getTypeController(state.selectedExploreTap).loadComplete();
    updateOldSearch(state.selectedExploreTap, null);
    switch (state.selectedExploreTap) {
      case ProviderType.Doctor:
        emit(
          state.copyWith(
              doctorsFilter: event.filterData,
              isDoctorsSearch: event.isSearch,
              doctorsReqState: ReqState.success),
        );

        print(state.doctorsGroup.where((i) => i.id == 3).first.isFavorite);
        break;

      case ProviderType.Clinic:
        emit(
          state.copyWith(
              clinicsFilter: event.filterData,
              isClinicsSearch: event.isSearch,
              clinicsReqState: ReqState.success),
        );
        break;

      case ProviderType.Hospital:
        emit(
          state.copyWith(
              hospitalsFilter: event.filterData,
              isHospitalsSearch: event.isSearch,
              hospitalsReqState: ReqState.success),
        );
        break;
    }
  }

  Future<void> _onToggleFavoriteEvent(
    ToggleFavoriteEvent event,
    Emitter<HomeState> emit,
  ) async {
    HomeState toggleState() {
      event.provider.isFavorite = !event.provider.isFavorite;
      return state.refreshIt;
    }

    await handleToggleFavorite(
        id: event.provider.id,
        emit: emit,
        loadingState: toggleState,
        errorState: toggleState);
  }

  Future<void> _onGetProvidersEvent(
      GetProvidersEvent event, Emitter<HomeState> emit) async {
    ProviderType selectedTap = event.providerType;
    updateOldSearch(state.selectedExploreTap, event.search);
    getTypeController(state.selectedExploreTap).loadComplete();
    emit(updateFilter(state.selectedExploreTap, event.filter));
    bool isSearching = oldSearch != null;
    exploreSearchEditingController.text = oldSearch ?? '';
    await handlePagination<Provider>(
      key: "${selectedTap.name}-${isSearching}",
      controller: getTypeController(selectedTap),
      isRefresh: event.isRefresh,
      emit: emit,
      loadingState: () => changeTypeState(
          type: selectedTap, reqState: ReqState.loading, isSearch: isSearching),
      errorState: (errorMessage, reqState) => changeTypeState(
          type: selectedTap,
          reqState: reqState,
          errorMessage: errorMessage,
          isSearch: isSearching),
      successState: (items, isRefresh) {
        return changeTypeState(
            type: selectedTap,
            isSearch: isSearching,
            providers: items,
            reqState: ReqState.success);
      },
      currentItems:
          getProvidersByType(type: selectedTap, isSearchResult: isSearching),
      fetchData: (page) async {
        var addressDetails = await instance<AppPreferences>().getLocationData();
        final response = await instance<ProvidersUseCase>().execute(
            ProvidersRequest(
                page: page,
                lat: addressDetails.latitude,
                lng: addressDetails.longitude,
                type: selectedTap,
                search: oldSearch,
                ratings: event.filter.rating,
                sortBy: event.filter.nearestToMe
                    ? ProviderSortBy.distance
                    : ProviderSortBy.latest));
        return response.fold(
          (failure) => Left(failure),
          (data) => Right(PaginatedResponse<Provider>(
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

  Future<void> _onGetBookingsEvent(
      GetBookingsEvent event, Emitter<HomeState> emit) async {
    await handlePagination<Booking>(
      key: event.statusApp.name,
      controller: getBookingsController(event.statusApp),
      isRefresh: event.isRefresh,
      emit: emit,
      loadingState: () => changeBookingsState(
          statusApp: event.statusApp, reqState: ReqState.loading),
      errorState: (errorMessage, reqState) => changeBookingsState(
          statusApp: event.statusApp,
          reqState: reqState,
          errorMessage: errorMessage),
      successState: (items, isRefresh) {
        return changeBookingsState(
            statusApp: event.statusApp,
            bookings: items,
            reqState: ReqState.success);
      },
      currentItems: getBookingsByStatus(status: event.statusApp),
      fetchData: (page) async {
        final response = await instance<BookingsUseCase>().execute(
            BookingsRequest(
                page: page,
                statusApp: event.statusApp,
                sortBy: BookingSortBy.latest));
        return response.fold(
          (failure) => Left(failure),
          (data) => Right(PaginatedResponse<Booking>(
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

  List<Provider> getProvidersByType({
    required ProviderType type,
    required bool isSearchResult,
  }) {
    switch (type) {
      case ProviderType.Doctor:
        return isSearchResult
            ? state.searchDoctorsGroup
            : state.initialDoctorsGroup;

      case ProviderType.Clinic:
        return isSearchResult
            ? state.searchClinicsGroup
            : state.initialClinicsGroup;

      case ProviderType.Hospital:
        return isSearchResult
            ? state.searchHospitalsGroup
            : state.initialHospitalsGroup;
    }
  }

  List<Booking> getBookingsByStatus({
    required BookingStatusApp status,
  }) {
    switch (status) {
      case BookingStatusApp.pending:
      case BookingStatusApp.confirmed:
        return state.upcomingBookings;
      case BookingStatusApp.completed:
        return state.completedBookings;
      // The 3 negative-scenario buckets all live under the Cancelled tab.
      case BookingStatusApp.cancelled:
      case BookingStatusApp.expired:
      case BookingStatusApp.noShow:
      case BookingStatusApp.providerNoShow:
        return state.cancelledBookings;
    }
  }

  HomeState changeTypeState({
    required ProviderType type,
    ReqState? reqState,
    String? errorMessage,
    List<Provider>? providers,
    bool isSearch = false,
  }) {
    switch (type) {
      case ProviderType.Doctor:
        return state.copyWith(
          doctorsReqState: reqState,
          doctorsErrorState: errorMessage,
          initialDoctorsGroup: isSearch ? null : providers,
          searchDoctorsGroup: isSearch ? providers : null,
          isDoctorsSearch: isSearch,
        );

      case ProviderType.Hospital:
        return state.copyWith(
          hospitalsReqState: reqState,
          hospitalsErrorState: errorMessage,
          initialHospitalsGroup: isSearch ? null : providers,
          searchHospitalsGroup: isSearch ? providers : null,
          isHospitalsSearch: isSearch,
        );

      case ProviderType.Clinic:
        return state.copyWith(
          clinicsReqState: reqState,
          clinicsErrorState: errorMessage,
          initialClinicsGroup: isSearch ? null : providers,
          searchClinicsGroup: isSearch ? providers : null,
          isClinicsSearch: isSearch,
        );
    }
  }

  HomeState changeBookingsState({
    required BookingStatusApp statusApp,
    ReqState? reqState,
    String? errorMessage,
    List<Booking>? bookings,
  }) {
    List<Booking>? bookingsGroup;
    if(reqState?.isEmpty == true) {
      bookingsGroup = [];
    }else{
      bookingsGroup = bookings;
    }
    switch (statusApp) {
      case BookingStatusApp.pending:
      case BookingStatusApp.confirmed:
        return state.copyWith(
          upcomingBookingsReqState: reqState,
          upcomingBookingsErrorState: errorMessage,
          upcomingBookings: bookingsGroup,
        );

      case BookingStatusApp.completed:
        return state.copyWith(
          completedBookingsReqState: reqState,
          completedBookingsErrorState: errorMessage,
          completedBookings: bookingsGroup,
        );

      case BookingStatusApp.cancelled:
      case BookingStatusApp.expired:
      case BookingStatusApp.noShow:
      case BookingStatusApp.providerNoShow:
        return state.copyWith(
          cancelledBookingsReqState: reqState,
          cancelledBookingsErrorState: errorMessage,
          cancelledBookings: bookingsGroup,
        );
    }
  }

  Future<Position?> determinePosition() async {
    LocationPermission permission;
    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        SnackbarHelper.showMessage(
            Translation.location_permissions_permanently_denied.tr,
            ErrorMessage.snackBar);
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 100,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  Future<String?> getAddressFromLatLng(Position latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

      Placemark placemark =
          placemarks.length > 1 ? placemarks[1] : placemarks.first;

      String cityName = placemark.locality ??
          placemark.subAdministrativeArea ??
          placemark.administrativeArea ??
          placemark.thoroughfare ??
          placemark.name ??
          Translation.unknown_location.tr;

      return cityName;
    } catch (e) {
      SnackbarHelper.showMessage(
          Translation.something_is_wrong.tr, ErrorMessage.snackBar);
      return null;
    }
  }

  Future<void> _onSetLocationCityEvent(
      SetLocationCityEvent event, Emitter<HomeState> emit) async {
    if (event.locationAddress == null || event.position == null) {
      String address =
          (await instance<AppPreferences>().getLocationData()).address!;
      emit(state.copyWith(locationCity: address));
    } else {
      emit(state.copyWith(locationCity: event.locationAddress));

      await instance<AppPreferences>().saveLocationData(
          latitude: event.position!.latitude,
          longitude: event.position!.longitude,
          address: event.locationAddress!);
    }
  }

  Future<void> _onHomeDataEvent(
      HomeDataEvent event, Emitter<HomeState> emit) async {
    if (state.homeReqState.isSuccess) {
      await refreshHomeController.requestLoading();
    }

    var addressDetails = await instance<AppPreferences>().getLocationData();
    var result = await instance<HomeUseCase>().execute(GetHomeRequest(
        lat: addressDetails.latitude, lng: addressDetails.longitude));

    result.fold((failure) {
      refreshHomeController.refreshFailed();
      emit(state.copyWith(
          homeReqState: ReqState.error, homeErrorState: failure.userMessage));
    }, (data) {
      refreshHomeController.refreshCompleted();
      emit(
          state.copyWith(homeReqState: ReqState.success, homeData: data.data!));
    });
  }

  Future<void> _onLogoutEvent(
    LogoutEvent event,
    Emitter<HomeState> emit,
  ) async {
    OverlayLoading.instance.show();

    await FirebaseMessegingServices.instance.deleteFCMToken();

    final result = await instance<LogoutUseCase>().execute();

    result.fold(
      (failure) {
        OverlayLoading.instance.hide();
        SnackbarHelper.showMessage(
          failure.userMessage,
          ErrorMessage.snackBar,
        );
      },
      (response) async {
        await instance<AppPreferences>().clearUserAndAccessToken();
        OverlayLoading.instance.hide();
        event.onSuccess?.call();
      },
    );
  }

  Future<void> _onDeleteAccountEvent(
    DeleteAccountEvent event,
    Emitter<HomeState> emit,
  ) async {
    OverlayLoading.instance.show();

    await FirebaseMessegingServices.instance.deleteFCMToken();

    final result =
        await instance<RemoveAccountUseCase>().execute(RemoveAccountRequest());
    result.fold(
      (failure) {
        OverlayLoading.instance.hide();
        SnackbarHelper.showMessage(
          failure.userMessage,
          ErrorMessage.snackBar,
        );
      },
      (response) async {
        await instance<AppPreferences>().clearUserAndAccessToken();
        OverlayLoading.instance.hide();
        event.onSuccess?.call();
      },
    );
  }

  Future<void> _onUpdateBookingRatedEvent(
    UpdateBookingRatedEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Update booking in all booking lists (upcoming, completed, cancelled)
    List<Booking> updateBookingInList(List<Booking> bookings) {
      return bookings.map((booking) {
        if (booking.id == event.bookingId) {
          return Booking(
            id: booking.id,
            invoiceNumber: booking.invoiceNumber,
            isRated: true, // Update isRated
            provider: booking.provider,
            subtotal: booking.subtotal,
            total: booking.total,
            status: booking.status,
            date: booking.date,
            time: booking.time,
            period: booking.period,
            paymentMethod: booking.paymentMethod,
            providerDoctor: booking.providerDoctor,
            createdAt: booking.createdAt,
            feeServices: booking.feeServices,
          );
        }
        return booking;
      }).toList();
    }

    emit(state.copyWith(
      upcomingBookings: updateBookingInList(state.upcomingBookings),
      completedBookings: updateBookingInList(state.completedBookings),
      cancelledBookings: updateBookingInList(state.cancelledBookings),
    ));
  }

  Future<void> _onCancelBookingUpdateEvent(
    CancelBookingUpdateEvent event,
    Emitter<HomeState> emit,
  ) async {
    Booking? cancelledBooking;
    List<Booking> upcoming = List.from(state.upcomingBookings);

    int index = upcoming.indexWhere((b) => b.id == event.bookingId);
    if (index != -1) {
      cancelledBooking = upcoming.removeAt(index);
    }

    if (cancelledBooking != null) {
      // Create a new booking object with cancelled status if needed,
      // though typically we'd just refresh the cancelled list or add it.
      final newCancelledBooking = Booking(
        id: cancelledBooking.id,
        invoiceNumber: cancelledBooking.invoiceNumber,
        isRated: cancelledBooking.isRated,
        provider: cancelledBooking.provider,
        subtotal: cancelledBooking.subtotal,
        total: cancelledBooking.total,
        status: BookingStatusApp.cancelled,
        date: cancelledBooking.date,
        time: cancelledBooking.time,
        period: cancelledBooking.period,
        paymentMethod: cancelledBooking.paymentMethod,
        providerDoctor: cancelledBooking.providerDoctor,
        createdAt: cancelledBooking.createdAt,
        feeServices: cancelledBooking.feeServices,
      );

      List<Booking> cancelled = [
        newCancelledBooking,
        ...state.cancelledBookings
      ];

      emit(state.copyWith(
        upcomingBookings: upcoming,
        cancelledBookings: cancelled,
      ));
    }
  }

  Future<void> _onGetProfileEvent(
    GetProfileEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await instance<GetProfileUseCase>().execute(null);

    result.fold(
      (failure) {
        profileRefreshController.refreshFailed();
        SnackbarHelper.showMessage(failure.userMessage, ErrorMessage.snackBar);
      },
      (response) async {
        profileRefreshController.refreshCompleted();
        if (response.data != null) {
          // Save updated user data to AppPreferences
          await instance<AppPreferences>().setUserData(response.data!);

          add(HandleUserDateEvent());
        }
      },
    );
  }

  @override
  Future<void> close() async {
    refreshHomeController.dispose();
    profileRefreshController.dispose();
    doctorsController.dispose();
    hospitalsController.dispose();
    clinicsController.dispose();
    FavoritesManager.instance.removeObserver(this);
    return super.close();
  }

  @override
  void onFavoritesChanged(Map<int, bool> items) {
    List<Provider> allProviders = [
      ...(state.homeData?.nearby ?? []),
      ...state.initialDoctorsGroup,
      ...state.initialClinicsGroup,
      ...state.initialHospitalsGroup,
      ...state.searchClinicsGroup,
      ...state.searchDoctorsGroup,
      ...state.searchHospitalsGroup,
    ];
    for (var item in items.entries) {
      for (Provider provider in allProviders) {
        if (provider.id == item.key) {
          provider.isFavorite = item.value;
          print("Found -> ${provider.name} -- ${provider.isFavorite}");
        }
      }
    }

    add(RefreshHomeEvent());
  }
}
