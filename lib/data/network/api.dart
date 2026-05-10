import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';

import 'dio_factory.dart';

abstract class AppServicesClientAbs {
  Future<LoginResponse> login(LoginRequest request);
  Future<RegisterResponse> register(RegisterRequest request);
  Future<CheckCodeResponse> checkCode(CheckCodeRequest request);
  Future<ResendCodeResponse> resendCode(ResendCodeRequest request);
  Future<LogoutResponse> logout();
  Future<RemoveAccountResponse> removeAccount(RemoveAccountRequest request);
  Future<RefreshResponse> refresh();
  Future<ForgetPasswordResponse> forgetPassword(ForgetPasswordRequest request);
  Future<ResetPasswordResponse> resetPassword(ResetPasswordRequest request);
  Future<HomeResponse> getHome(GetHomeRequest request);
  Future<CategoriesResponse> getCategories(CategoriesRequest request);
  Future<AllCategoriesResponse> getAllCategories();
  Future<ContactUsResponse> contactUs(ContactUsRequest request);
  Future<ProvidersResponse> getProviders(ProvidersRequest request);
  Future<ProviderShowResponse> getProviderShow(int id, ProviderShowRequest request);
  Future<ProviderRatingsResponse> getProviderRatings(int id, {int? page});
  Future<ProviderLikeResponse> toggleProviderLike(int id);
  Future<ProvidersResponse> getLikedProviders(ProviderLikesRequest request);
  Future<BookingConfirmResponse> getBookingConfirm(BookingConfirmRequest request);
  Future<BookingAvailableTimesResponse> getBookingAvailableTimes(BookingAvailableTimesRequest request);
  Future<BookingCreateResponse> createBooking(BookingCreateRequest request);
  Future<PaymentStatusResponse> getPaymentStatus(int transactionId);
  Future<PaymentStatusResponse> cancelPaymentTransaction(int transactionId);
  Future<BookingCreateResponse> retryPaymentTransaction(int transactionId);
  Future<BookingCreateResponse> resumeBookingPayment(int bookingId);
  Future<BookingRateResponse> rateBooking(BookingRateRequest request);
  Future<BookingsResponse> getBookings(BookingsRequest request);
  Future<BookingShowResponse> getBooking(int id);
  Future<ProviderDoctorsResponse> getProviderDoctors(ProvidersDoctorsRequest request);
  Future<BookingCancelResponse> cancelBooking(BookingCancelRequest request);
  Future<CancellationReasonsResponse> getCancellationReasons();
  Future<FAQsResponse> getFAQs();
  Future<InfoContentResponse> getTermsAndConditions();
  Future<InfoContentResponse> getPrivacyPolicy();
  Future<NotificationsResponse> getNotifications(NotificationsRequest request);
  Future<ProfileResponse> getProfile();
  Future<ProfileResponse> updateAccount(UpdateAccountRequest request);
  Future<AiChatResponse> aiChat(AiChatRequest request);
}

class AppServices implements AppServicesClientAbs {
  final DioFactory _dio;

  AppServices(this._dio);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.request(
      '/login',
      method: RequestMethod.POST,
      body: request.toJson(),
    );
    return LoginResponse.fromJson(response.data);
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    final isFormData = request.image != null;
    final body = isFormData ? request.toFormData() : request.toJson();
    final response = await _dio.request(
      '/register',
      method: RequestMethod.POST,
      body: body,
    );
    return RegisterResponse.fromJson(response.data);
  }

  @override
  Future<CheckCodeResponse> checkCode(CheckCodeRequest request) async {
    final response = await _dio.request(
      '/check-code',
      method: RequestMethod.POST,
      body: request.toJson(),
    );
    return CheckCodeResponse.fromJson(response.data);
  }

  @override
  Future<ResendCodeResponse> resendCode(ResendCodeRequest request) async {
    final response = await _dio.request(
      '/resend-code',
      method: RequestMethod.POST,
      body: request.toJson(),
    );
    return ResendCodeResponse.fromJson(response.data);
  }

  @override
  Future<LogoutResponse> logout() async {
    final response = await _dio.request(
      '/logout',
      method: RequestMethod.GET,
    );
    return LogoutResponse.fromJson(response.data);
  }

  @override
  Future<RemoveAccountResponse> removeAccount(RemoveAccountRequest request) async {
    final response = await _dio.request(
      '/remove-account',
      method: RequestMethod.DELETE,
      queryParameters: request.toJson(),
    );
    return RemoveAccountResponse.fromJson(response.data);
  }

  @override
  Future<RefreshResponse> refresh() async {
    final response = await _dio.request(
      '/refresh',
      method: RequestMethod.GET,
    );
    return RefreshResponse.fromJson(response.data);
  }

  @override
  Future<ForgetPasswordResponse> forgetPassword(ForgetPasswordRequest request) async {
    final response = await _dio.request(
      '/forget-password',
      method: RequestMethod.POST,
      body: request.toJson(),
    );
    return ForgetPasswordResponse.fromJson(response.data);
  }

  @override
  Future<ResetPasswordResponse> resetPassword(ResetPasswordRequest request) async {
    final response = await _dio.request(
      '/reset-password',
      method: RequestMethod.POST,
      body: request.toJson(),
    );
    return ResetPasswordResponse.fromJson(response.data);
  }

  @override
  Future<HomeResponse> getHome(GetHomeRequest request) async {
    final response = await _dio.request(
      '/get-home',
      queryParameters: request.toJson(),
      method: RequestMethod.GET,
    );
    return HomeResponse.fromJson(response.data);
  }

  @override
  Future<CategoriesResponse> getCategories(CategoriesRequest request) async {
    final response = await _dio.request(
      '/categories',
      method: RequestMethod.GET,
      queryParameters: request.toJson(),
    );
    return CategoriesResponse.fromJson(response.data);
  }

  @override
  Future<AllCategoriesResponse> getAllCategories() async {
    final response = await _dio.request(
      '/all-categories',
      method: RequestMethod.GET,
    );
    return AllCategoriesResponse.fromJson(response.data);
  }

  @override
  Future<ContactUsResponse> contactUs(ContactUsRequest request) async {
    final response = await _dio.request(
      '/contact-us',
      method: RequestMethod.POST,
      body: request.toJson(),
    );
    return ContactUsResponse.fromJson(response.data);
  }

  @override
  Future<ProvidersResponse> getProviders(ProvidersRequest request) async {
    final response = await _dio.request(
      '/providers',
      method: RequestMethod.GET,
      queryParameters: request.toJson(),
    );
    return ProvidersResponse.fromJson(response.data);
  }

  @override
  Future<ProviderShowResponse> getProviderShow(int id, ProviderShowRequest request) async {
    final response = await _dio.request(
      '/providers/$id/show',
      method: RequestMethod.GET,
      queryParameters: request.toJson(),
    );
    return ProviderShowResponse.fromJson(response.data);
  }

  @override
  Future<ProviderRatingsResponse> getProviderRatings(int id, {int? page}) async {
    final response = await _dio.request(
      '/providers/$id/ratings',
      method: RequestMethod.GET,
      queryParameters: {if (page != null) 'page': page},
    );
    return ProviderRatingsResponse.fromJson(response.data);
  }

  @override
  Future<ProviderLikeResponse> toggleProviderLike(int id) async {
    final response = await _dio.request(
      '/providers/$id/like',
      method: RequestMethod.POST,
    );
    return ProviderLikeResponse.fromJson(response.data);
  }

  @override
  Future<ProvidersResponse> getLikedProviders(ProviderLikesRequest request) async {
    final response = await _dio.request(
      '/providers/likes',
      method: RequestMethod.GET,
      queryParameters: request.toJson(),
    );
    return ProvidersResponse.fromJson(response.data);
  }

  @override
  Future<BookingConfirmResponse> getBookingConfirm(BookingConfirmRequest request) async {
    final response = await _dio.request(
      '/bookings/get-confirm',
      method: RequestMethod.POST,
      body: request.toJson(),
    );
    return BookingConfirmResponse.fromJson(response.data);
  }

  @override
  Future<BookingAvailableTimesResponse> getBookingAvailableTimes(BookingAvailableTimesRequest request) async {
    final response = await _dio.request(
      '/bookings/get-available-times',
      method: RequestMethod.POST,
      body: request.toJson(),
    );
    return BookingAvailableTimesResponse.fromJson(response.data);
  }

  @override
  Future<BookingCreateResponse> createBooking(BookingCreateRequest request) async {
    final response = await _dio.request(
      '/bookings',
      method: RequestMethod.POST,
      body: request.toJson(),
      headers: request.idempotencyKey != null && request.idempotencyKey!.isNotEmpty
          ? {'Idempotency-Key': request.idempotencyKey}
          : null,
    );
    return BookingCreateResponse.fromJson(response.data);
  }

  @override
  Future<PaymentStatusResponse> getPaymentStatus(int transactionId) async {
    final response = await _dio.request(
      '/payments/$transactionId/status',
      method: RequestMethod.GET,
    );
    return PaymentStatusResponse.fromJson(response.data);
  }

  @override
  Future<PaymentStatusResponse> cancelPaymentTransaction(int transactionId) async {
    final response = await _dio.request(
      '/payments/$transactionId/cancel',
      method: RequestMethod.POST,
    );
    return PaymentStatusResponse.fromJson(response.data);
  }

  @override
  Future<BookingCreateResponse> retryPaymentTransaction(int transactionId) async {
    final response = await _dio.request(
      '/payments/$transactionId/retry',
      method: RequestMethod.POST,
    );
    return BookingCreateResponse.fromJson(response.data);
  }

  @override
  Future<BookingCreateResponse> resumeBookingPayment(int bookingId) async {
    final response = await _dio.request(
      '/bookings/$bookingId/resume-payment',
      method: RequestMethod.POST,
    );
    return BookingCreateResponse.fromJson(response.data);
  }

  @override
  Future<BookingRateResponse> rateBooking(BookingRateRequest request) async {
    final response = await _dio.request(
      '/bookings/rate',
      method: RequestMethod.POST,
      body: request.toJson(),
    );
    return BookingRateResponse.fromJson(response.data);
  }

  @override
  Future<BookingsResponse> getBookings(BookingsRequest request) async {
    final response = await _dio.request(
      '/bookings',
      method: RequestMethod.GET,
      queryParameters: request.toJson(),
    );
    return BookingsResponse.fromJson(response.data);
  }

  @override
  Future<BookingShowResponse> getBooking(int id) async {
    final response = await _dio.request(
      '/bookings/$id',
      method: RequestMethod.GET,
    );
    return BookingShowResponse.fromJson(response.data);
  }

  @override
  Future<ProviderDoctorsResponse> getProviderDoctors(ProvidersDoctorsRequest request) async {
    final response = await _dio.request(
      '/providers/doctors',
      method: RequestMethod.GET,
      queryParameters: request.toJson(),
    );
    return ProviderDoctorsResponse.fromJson(response.data);
  }

  @override
  Future<BookingCancelResponse> cancelBooking(BookingCancelRequest request) async {
    final response = await _dio.request(
      '/bookings/canceled',
      method: RequestMethod.POST,
      body: request.toJson(),
    );
    return BookingCancelResponse.fromJson(response.data);
  }

  @override
  Future<CancellationReasonsResponse> getCancellationReasons() async {
    final response = await _dio.request(
      '/bookings/canceled/reasons',
      method: RequestMethod.GET,
    );
    return CancellationReasonsResponse.fromJson(response.data);
  }

  @override
  Future<FAQsResponse> getFAQs() async {
    final response = await _dio.request(
      '/info/fqa',
      method: RequestMethod.GET,
    );
    return FAQsResponse.fromJson(response.data);
  }

  @override
  Future<InfoContentResponse> getTermsAndConditions() async {
    final response = await _dio.request(
      '/info/terms-and-conditions',
      method: RequestMethod.GET,
    );
    return InfoContentResponse.fromJson(response.data);
  }

  @override
  Future<InfoContentResponse> getPrivacyPolicy() async {
    final response = await _dio.request(
      '/info/privacy-policy',
      method: RequestMethod.GET,
    );
    return InfoContentResponse.fromJson(response.data);
  }

  @override
  Future<NotificationsResponse> getNotifications(NotificationsRequest request) async {
    final response = await _dio.request(
      '/notifications',
      method: RequestMethod.GET,
      queryParameters: request.toJson(),
    );
    return NotificationsResponse.fromJson(response.data);
  }

  @override
  Future<ProfileResponse> getProfile() async {
    final response = await _dio.request(
      '/get-profile',
      method: RequestMethod.GET,
    );
    return ProfileResponse.fromJson(response.data);
  }

  @override
  Future<ProfileResponse> updateAccount(UpdateAccountRequest request) async {
    final isFormData = request.image != null;
    final body = isFormData ? request.toFormData() : request.toJson();
    final response = await _dio.request(
      '/update-account',
      method: RequestMethod.POST,
      body: body,
    );
    return ProfileResponse.fromJson(response.data);
  }

  @override
  Future<AiChatResponse> aiChat(AiChatRequest request) async {
    final response = await _dio.request(
      '/ai/chat',
      method: RequestMethod.POST,
      body: request.toJson(),
    );
    return AiChatResponse.fromJson(response.data);
  }
}
