part of 'home_bloc.dart';

class HomeState extends Equatable {
  // Home
  final ReqState homeReqState;
  final String homeErrorState;
  final String locationCity;
  final HomeData? homeData;

  final ProviderType selectedExploreTap;

  // Doctors
  final ReqState doctorsReqState;
  final String doctorsErrorState;
  final List<Provider> initialDoctorsGroup;
  final List<Provider> searchDoctorsGroup;
  final bool isDoctorsSearch;
  final FilterData doctorsFilter;

  // Clinics
  final ReqState clinicsReqState;
  final String clinicsErrorState;
  final List<Provider> initialClinicsGroup;
  final List<Provider> searchClinicsGroup;
  final bool isClinicsSearch;
  final FilterData clinicsFilter;

  // Hospitals
  final ReqState hospitalsReqState;
  final String hospitalsErrorState;
  final List<Provider> initialHospitalsGroup;
  final List<Provider> searchHospitalsGroup;
  final bool isHospitalsSearch;
  final FilterData hospitalsFilter;

  final List<Booking> upcomingBookings;
  final ReqState upcomingBookingsReqState;
  final String upcomingBookingsErrorState;

  final List<Booking> completedBookings;
  final ReqState completedBookingsReqState;
  final String completedBookingsErrorState;

  final List<Booking> cancelledBookings;
  final ReqState cancelledBookingsReqState;
  final String cancelledBookingsErrorState;

  final bool refresh;

  /// Getters
  List<Provider> get doctorsGroup =>
      isDoctorsSearch ? searchDoctorsGroup : initialDoctorsGroup;

  List<Provider> get clinicsGroup =>
      isClinicsSearch ? searchClinicsGroup : initialClinicsGroup;

  List<Provider> get hospitalsGroup =>
      isHospitalsSearch ? searchHospitalsGroup : initialHospitalsGroup;

  final String? image;
  final String? name;
  final String? phoneNumber;

  const HomeState({
    // Home
    required this.locationCity,
    required this.hospitalsFilter,
    this.homeReqState = ReqState.loading,
    this.homeErrorState = '',
    this.homeData,
    this.selectedExploreTap = ProviderType.Doctor,

    // Doctors
    this.doctorsReqState = ReqState.loading,
    this.doctorsErrorState = '',
    this.initialDoctorsGroup = const [],
    this.searchDoctorsGroup = const [],
    this.isDoctorsSearch = false,
    required this.doctorsFilter,

    // Clinics
    this.clinicsReqState = ReqState.loading,
    this.clinicsErrorState = '',
    this.initialClinicsGroup = const [],
    this.searchClinicsGroup = const [],
    this.isClinicsSearch = false,
    required this.clinicsFilter,

    // Hospitals
    this.hospitalsReqState = ReqState.loading,
    this.hospitalsErrorState = '',
    this.initialHospitalsGroup = const [],
    this.searchHospitalsGroup = const [],
    this.isHospitalsSearch = false,

    // Upcoming Bookings
    this.upcomingBookings = const [],
    this.upcomingBookingsReqState = ReqState.loading,
    this.upcomingBookingsErrorState = '',
    this.completedBookings = const [],
    this.completedBookingsReqState = ReqState.loading,
    this.completedBookingsErrorState = '',
    this.cancelledBookings = const [],
    this.cancelledBookingsReqState = ReqState.loading,
    this.cancelledBookingsErrorState = '',
    this.phoneNumber,
    this.name,
    this.image,
    this.refresh = false,
  });

  HomeState copyWith({
    // Home
    String? locationCity,
    ReqState? homeReqState,
    String? homeErrorState,
    HomeData? homeData,
    ProviderType? selectedExploreTap,

    // Doctors
    ReqState? doctorsReqState,
    String? doctorsErrorState,
    List<Provider>? initialDoctorsGroup,
    List<Provider>? searchDoctorsGroup,
    bool? isDoctorsSearch,
    FilterData? doctorsFilter,

    // Clinics
    ReqState? clinicsReqState,
    String? clinicsErrorState,
    List<Provider>? initialClinicsGroup,
    List<Provider>? searchClinicsGroup,
    bool? isClinicsSearch,
    FilterData? clinicsFilter,

    // Hospitals
    ReqState? hospitalsReqState,
    String? hospitalsErrorState,
    List<Provider>? initialHospitalsGroup,
    List<Provider>? searchHospitalsGroup,
    bool? isHospitalsSearch,
    FilterData? hospitalsFilter,
    bool? refresh,
    ReqState? accountActionReqState,
    String? accountActionErrorState,
    List<Booking>? upcomingBookings,
    ReqState? upcomingBookingsReqState,
    String? upcomingBookingsErrorState,
    List<Booking>? completedBookings,
    ReqState? completedBookingsReqState,
    String? completedBookingsErrorState,
    List<Booking>? cancelledBookings,
    ReqState? cancelledBookingsReqState,
    String? cancelledBookingsErrorState,
    String? phoneNumber,
    String? name,
    String? image,
  }) {
    return HomeState(
      locationCity: locationCity ?? this.locationCity,
      homeReqState: homeReqState ?? this.homeReqState,
      homeErrorState: homeErrorState ?? this.homeErrorState,
      homeData: homeData ?? this.homeData,
      selectedExploreTap: selectedExploreTap ?? this.selectedExploreTap,
      doctorsReqState: doctorsReqState ?? this.doctorsReqState,
      doctorsErrorState: doctorsErrorState ?? this.doctorsErrorState,
      initialDoctorsGroup: initialDoctorsGroup ?? this.initialDoctorsGroup,
      searchDoctorsGroup: searchDoctorsGroup ?? this.searchDoctorsGroup,
      isDoctorsSearch: isDoctorsSearch ?? this.isDoctorsSearch,
      doctorsFilter: doctorsFilter ?? this.doctorsFilter,
      clinicsReqState: clinicsReqState ?? this.clinicsReqState,
      clinicsErrorState: clinicsErrorState ?? this.clinicsErrorState,
      initialClinicsGroup: initialClinicsGroup ?? this.initialClinicsGroup,
      searchClinicsGroup: searchClinicsGroup ?? this.searchClinicsGroup,
      isClinicsSearch: isClinicsSearch ?? this.isClinicsSearch,
      clinicsFilter: clinicsFilter ?? this.clinicsFilter,
      hospitalsReqState: hospitalsReqState ?? this.hospitalsReqState,
      hospitalsErrorState: hospitalsErrorState ?? this.hospitalsErrorState,
      initialHospitalsGroup:
          initialHospitalsGroup ?? this.initialHospitalsGroup,
      searchHospitalsGroup: searchHospitalsGroup ?? this.searchHospitalsGroup,
      isHospitalsSearch: isHospitalsSearch ?? this.isHospitalsSearch,
      hospitalsFilter: hospitalsFilter ?? this.hospitalsFilter,
      refresh: refresh ?? this.refresh,
      upcomingBookings: upcomingBookings ?? this.upcomingBookings,
      upcomingBookingsReqState:
          upcomingBookingsReqState ?? this.upcomingBookingsReqState,
      upcomingBookingsErrorState:
          upcomingBookingsErrorState ?? this.upcomingBookingsErrorState,
      completedBookings: completedBookings ?? this.completedBookings,
      completedBookingsReqState:
          completedBookingsReqState ?? this.completedBookingsReqState,
      completedBookingsErrorState:
          completedBookingsErrorState ?? this.completedBookingsErrorState,
      cancelledBookings: cancelledBookings ?? this.cancelledBookings,
      cancelledBookingsReqState:
          cancelledBookingsReqState ?? this.cancelledBookingsReqState,
      cancelledBookingsErrorState:
          cancelledBookingsErrorState ?? this.cancelledBookingsErrorState,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      image: image ?? this.image,

    );
  }

  HomeState get refreshIt => copyWith(refresh: !refresh);

  FilterData get filterDataForType {
    switch (selectedExploreTap) {
      case ProviderType.Doctor:
        return doctorsFilter;
      case ProviderType.Clinic:
        return clinicsFilter;
      case ProviderType.Hospital:
        return hospitalsFilter;
    }
  }

  ReqState get reqStateForType {
    switch (selectedExploreTap) {
      case ProviderType.Doctor:
        return doctorsReqState;
      case ProviderType.Clinic:
        return clinicsReqState;
      case ProviderType.Hospital:
        return hospitalsReqState;
    }
  }

  String get errorForType {
    switch (selectedExploreTap) {
      case ProviderType.Doctor:
        return doctorsErrorState;
      case ProviderType.Clinic:
        return clinicsErrorState;
      case ProviderType.Hospital:
        return hospitalsErrorState;
    }
  }

  List<Provider> providersForType(ProviderType type) {
    switch (type) {
      case ProviderType.Doctor:
        return isDoctorsSearch ? searchDoctorsGroup : initialDoctorsGroup;
      case ProviderType.Clinic:
        return isClinicsSearch ? searchClinicsGroup : initialClinicsGroup;
      case ProviderType.Hospital:
        return isHospitalsSearch ? searchHospitalsGroup : initialHospitalsGroup;
    }
  }

  @override
  List<Object?> get props => [
        locationCity,
        homeReqState,
        homeErrorState,
        homeData,
        selectedExploreTap,
        doctorsReqState,
        doctorsErrorState,
        initialDoctorsGroup,
        searchDoctorsGroup,
        isDoctorsSearch,
        doctorsFilter,
        clinicsReqState,
        clinicsErrorState,
        initialClinicsGroup,
        searchClinicsGroup,
        isClinicsSearch,
        clinicsFilter,
        hospitalsReqState,
        hospitalsErrorState,
        initialHospitalsGroup,
        searchHospitalsGroup,
        isHospitalsSearch,
        hospitalsFilter,
        refresh,
        upcomingBookings,
        upcomingBookingsReqState,
        upcomingBookingsErrorState,
        completedBookings,
        completedBookingsReqState,
        completedBookingsErrorState,
        cancelledBookings,
        cancelledBookingsReqState,
        cancelledBookingsErrorState,
        phoneNumber,
        name,
        image,
      ];
}
