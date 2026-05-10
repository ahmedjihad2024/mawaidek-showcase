import 'package:mawadk/presentation/res/translations_manager.dart';

enum ShopItemType { orderDetails, mostSales, none }

// error message
enum ErrorMessage { snackBar, toast }

extension IsErrorMessage on ErrorMessage {
  bool get isSnackBar => this == ErrorMessage.snackBar;

  bool get isToast => this == ErrorMessage.toast;
}

class ErrorData {
  final String message;
  final ErrorMessage type;

  ErrorData(this.type, this.message);
}

enum VerifyOtpType {
  forgotPassword,
  register;

  bool get isForgotPassword => this == VerifyOtpType.forgotPassword;
  bool get isRegister => this == VerifyOtpType.register;
}

enum BookingType {
  upcoming,
  completed,
  cancelled;

  BookingStatusApp get bookingStatusApp => switch (this) {
        BookingType.upcoming => BookingStatusApp.pending,
        BookingType.completed => BookingStatusApp.completed,
        BookingType.cancelled => BookingStatusApp.cancelled
      };
}

enum BookingStatus {
  upcoming,
  completed,
  cancelled,
}

enum Gender {
  male,
  female;
}

enum ResetPasswordType {
  forgotPassword,
  changePassword;

  bool get isForgotPassword => this == ResetPasswordType.forgotPassword;
  bool get isChangePassword => this == ResetPasswordType.changePassword;
}

enum ProviderType {
  Doctor,
  Hospital,
  Clinic;

  // Static method to convert a string to ProviderType (case-insensitive)
  static ProviderType? fromString(String? value) {
    if (value == null) return null;
    return switch(value){
      "Doctor" => ProviderType.Doctor,
      "Hospital" => ProviderType.Hospital,
      "Clinic" => ProviderType.Clinic,
      _ => null,
    };
  }

  // Boolean getters to check the current type
  bool get isDoctor => this == ProviderType.Doctor;
  bool get isHospital => this == ProviderType.Hospital;
  bool get isClinic => this == ProviderType.Clinic;

  String get tr => switch (this) {
        ProviderType.Doctor => Translation.doctors.tr,
        ProviderType.Hospital => Translation.hospitals.tr,
        ProviderType.Clinic => Translation.clinics.tr,
      };
}

enum ProviderSortBy {
  latest,
  oldest,
  top_rated,
  name_asc,
  name_desc,
  distance;
}

enum BookingPeriod {
  morning,
  evening;

  String get name => toString().split('.').last;
}

enum PaymentMethod {
  cash,
  online;

  String get name => toString().split('.').last;
  bool get isCash => this == PaymentMethod.cash;
  bool get isOnline => this == PaymentMethod.online;

  static PaymentMethod? fromString(String? value) {
    if (value == null) return null;
    return switch(value){
      "cash" => PaymentMethod.cash,
      "online" => PaymentMethod.online,
      _ => null,
    };
  }
}

enum BookingStatusApp {
  pending,
  confirmed,
  completed,
  cancelled,
  // Negative-scenario statuses introduced server-side. Older app builds may
  // still receive `cancelled` because the API returns status_bucket on the
  // patient surface; new builds get the precise value via status_raw.
  expired,
  noShow,
  providerNoShow;

  // Server uses snake_case. We can't put 'no_show' as a Dart identifier so
  // map it manually.
  String get serverValue => switch (this) {
        BookingStatusApp.noShow => 'no_show',
        BookingStatusApp.providerNoShow => 'provider_no_show',
        _ => name,
      };

  String get name => toString().split('.').last;

  static BookingStatusApp? fromString(String? value) {
    if (value == null) return null;
    final normalised = value.toLowerCase();
    return switch (normalised) {
      'pending' => BookingStatusApp.pending,
      'confirmed' => BookingStatusApp.confirmed,
      'completed' => BookingStatusApp.completed,
      'cancelled' || 'canceled' => BookingStatusApp.cancelled,
      'expired' => BookingStatusApp.expired,
      'no_show' || 'noshow' => BookingStatusApp.noShow,
      'provider_no_show' || 'providernoshow' => BookingStatusApp.providerNoShow,
      _ => null,
    };
  }

  // The "Upcoming" tab shows pending + confirmed (active bookings).
  bool get isPending => this == BookingStatusApp.pending || this == BookingStatusApp.confirmed;
  bool get isConfirmed => this == BookingStatusApp.confirmed;
  bool get isCompleted => this == BookingStatusApp.completed;
  // Anything that ended without the patient being seen is treated as
  // "Cancelled" on the patient list — the legacy mobile UX has 3 tabs only.
  bool get isCancelled =>
      this == BookingStatusApp.cancelled ||
      this == BookingStatusApp.expired ||
      this == BookingStatusApp.noShow ||
      this == BookingStatusApp.providerNoShow;
  bool get isExpired => this == BookingStatusApp.expired;
  bool get isNoShow => this == BookingStatusApp.noShow;
  bool get isProviderNoShow => this == BookingStatusApp.providerNoShow;
}

enum BookingSortBy {
  latest,
  oldest;

  String get name => toString().split('.').last;
}

enum AccountActionType {
  logout,
  deleteAccount;

  bool get isLogout => this == AccountActionType.logout;
  bool get isDeleteAccount => this == AccountActionType.deleteAccount;
}

enum DoctorSortBy {
  latest,
  oldest,
  top_rated,
  name_asc,
  name_desc;

  String get name => toString().split('.').last;
}

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded;

  bool get isPending => this == PaymentStatus.pending;
  bool get isPaid => this == PaymentStatus.paid;
  bool get isFailed => this == PaymentStatus.failed;
  bool get isRefunded => this == PaymentStatus.refunded;

  static PaymentStatus fromString(String? value) {
    if (value == null) return PaymentStatus.pending;
    return switch (value.toLowerCase()) {
      'pending' => PaymentStatus.pending,
      'paid' => PaymentStatus.paid,
      'failed' => PaymentStatus.failed,
      'refunded' => PaymentStatus.refunded,
      _ => PaymentStatus.pending,
    };
  }
}
