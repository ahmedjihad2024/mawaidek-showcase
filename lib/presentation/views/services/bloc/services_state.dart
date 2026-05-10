part of 'services_bloc.dart';

class ServicesState extends Equatable {
  final ReqState reqState;
  final String errorState;
  final ProviderShowData? providerData;
  final Category? selectedCategory;

  final bool refresh;

  const ServicesState(
      {this.reqState = ReqState.loading,
      this.errorState = '',
      this.providerData,
      this.selectedCategory,
      this.refresh = false});

  ServicesState copyWith(
      {ReqState? reqState,
      String? errorState,
      ProviderShowData? providerData,
      Category? selectedCategory,
      bool? refresh}) {
    return ServicesState(
        reqState: reqState ?? this.reqState,
        errorState: errorState ?? this.errorState,
        providerData: providerData ?? this.providerData,
        selectedCategory: selectedCategory,
        refresh: refresh ?? this.refresh);
  }

  ServicesState get refreshIt => copyWith(refresh: !refresh);

  @override
  List<Object?> get props =>
      [reqState, errorState, providerData, selectedCategory, refresh];
}
