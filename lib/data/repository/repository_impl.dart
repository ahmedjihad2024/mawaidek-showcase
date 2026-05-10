import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/error_handler.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/network/internet_checker.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';

import '../network/api.dart';
import '../request/request.dart';

class Repository implements RepositoryAbs {
  final AppServices _appServices;
  final NetworkConnectivity _networkConnectivity;

  Repository(this._appServices, this._networkConnectivity);

  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequest request) async {
    return fastHandler<LoginResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.login(request),
    );
  }

  @override
  Future<Either<Failure, RegisterResponse>> register(RegisterRequest request) async {
    return fastHandler<RegisterResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.register(request),
    );
  }

  @override
  Future<Either<Failure, CheckCodeResponse>> checkCode(CheckCodeRequest request) async {
    return fastHandler<CheckCodeResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.checkCode(request),
    );
  }

  @override
  Future<Either<Failure, ResendCodeResponse>> resendCode(ResendCodeRequest request) async {
    return fastHandler<ResendCodeResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.resendCode(request),
    );
  }

  @override
  Future<Either<Failure, LogoutResponse>> logout() async {
    return fastHandler<LogoutResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.logout(),
    );
  }

  @override
  Future<Either<Failure, RemoveAccountResponse>> removeAccount(RemoveAccountRequest request) async {
    return fastHandler<RemoveAccountResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.removeAccount(request),
    );
  }

  @override
  Future<Either<Failure, RefreshResponse>> refresh() async {
    return fastHandler<RefreshResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.refresh(),
    );
  }

  @override
  Future<Either<Failure, ForgetPasswordResponse>> forgetPassword(ForgetPasswordRequest request) async {
    return fastHandler<ForgetPasswordResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.forgetPassword(request),
    );
  }

  @override
  Future<Either<Failure, ResetPasswordResponse>> resetPassword(ResetPasswordRequest request) async {
    return fastHandler<ResetPasswordResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.resetPassword(request),
    );
  }

  @override
  Future<Either<Failure, HomeResponse>> getHome(GetHomeRequest request) async {
    return await fastHandler<HomeResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getHome(request),
    );
  }

  @override
  Future<Either<Failure, CategoriesResponse>> getCategories(CategoriesRequest request) async {
    return fastHandler<CategoriesResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getCategories(request),
    );
  }

  @override
  Future<Either<Failure, AllCategoriesResponse>> getAllCategories() async {
    return fastHandler<AllCategoriesResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getAllCategories(),
    );
  }

  @override
  Future<Either<Failure, ContactUsResponse>> contactUs(ContactUsRequest request) async {
    return fastHandler<ContactUsResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.contactUs(request),
    );
  }

  @override
  Future<Either<Failure, ProvidersResponse>> getProviders(ProvidersRequest request) async {
    return fastHandler<ProvidersResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getProviders(request),
    );
  }

  @override
  Future<Either<Failure, ProviderShowResponse>> getProviderShow(int id, ProviderShowRequest request) async {
    return fastHandler<ProviderShowResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getProviderShow(id, request),
    );
  }

  @override
  Future<Either<Failure, ProviderRatingsResponse>> getProviderRatings(int id, {int? page}) async {
    return fastHandler<ProviderRatingsResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getProviderRatings(id, page: page),
    );
  }

  @override
  Future<Either<Failure, ProviderLikeResponse>> toggleProviderLike(int id) async {
    return fastHandler<ProviderLikeResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.toggleProviderLike(id),
    );
  }

  @override
  Future<Either<Failure, ProvidersResponse>> getLikedProviders(ProviderLikesRequest request) async {
    return fastHandler<ProvidersResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getLikedProviders(request),
    );
  }

  @override
  Future<Either<Failure, BookingConfirmResponse>> getBookingConfirm(BookingConfirmRequest request) async {
    return fastHandler<BookingConfirmResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getBookingConfirm(request),
    );
  }

  @override
  Future<Either<Failure, BookingAvailableTimesResponse>> getBookingAvailableTimes(BookingAvailableTimesRequest request) async {
    return fastHandler<BookingAvailableTimesResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getBookingAvailableTimes(request),
    );
  }

  @override
  Future<Either<Failure, BookingCreateResponse>> createBooking(BookingCreateRequest request) async {
    return fastHandler<BookingCreateResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.createBooking(request),
    );
  }

  @override
  Future<Either<Failure, PaymentStatusResponse>> getPaymentStatus(int transactionId) async {
    return fastHandler<PaymentStatusResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getPaymentStatus(transactionId),
    );
  }

  @override
  Future<Either<Failure, PaymentStatusResponse>> cancelPaymentTransaction(int transactionId) async {
    return fastHandler<PaymentStatusResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.cancelPaymentTransaction(transactionId),
    );
  }

  @override
  Future<Either<Failure, BookingCreateResponse>> retryPaymentTransaction(int transactionId) async {
    return fastHandler<BookingCreateResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.retryPaymentTransaction(transactionId),
    );
  }

  @override
  Future<Either<Failure, BookingCreateResponse>> resumeBookingPayment(int bookingId) async {
    return fastHandler<BookingCreateResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.resumeBookingPayment(bookingId),
    );
  }

  @override
  Future<Either<Failure, BookingRateResponse>> rateBooking(BookingRateRequest request) async {
    return fastHandler<BookingRateResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.rateBooking(request),
    );
  }

  @override
  Future<Either<Failure, BookingsResponse>> getBookings(BookingsRequest request) async {
    return fastHandler<BookingsResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getBookings(request),
    );
  }

  @override
  Future<Either<Failure, BookingShowResponse>> getBooking(int id) async {
    return fastHandler<BookingShowResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getBooking(id),
    );
  }

  @override
  Future<Either<Failure, ProviderDoctorsResponse>> getProviderDoctors(ProvidersDoctorsRequest request) async {
    return fastHandler<ProviderDoctorsResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getProviderDoctors(request),
    );
  }

  @override
  Future<Either<Failure, BookingCancelResponse>> cancelBooking(BookingCancelRequest request) async {
    return fastHandler<BookingCancelResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.cancelBooking(request),
    );
  }

  @override
  Future<Either<Failure, CancellationReasonsResponse>> getCancellationReasons() async {
    return fastHandler<CancellationReasonsResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getCancellationReasons(),
    );
  }

  @override
  Future<Either<Failure, FAQsResponse>> getFAQs() async {
    return fastHandler<FAQsResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getFAQs(),
    );
  }

  @override
  Future<Either<Failure, InfoContentResponse>> getTermsAndConditions() async {
    return fastHandler<InfoContentResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getTermsAndConditions(),
    );
  }

  @override
  Future<Either<Failure, InfoContentResponse>> getPrivacyPolicy() async {
    return fastHandler<InfoContentResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getPrivacyPolicy(),
    );
  }

  @override
  Future<Either<Failure, NotificationsResponse>> getNotifications(NotificationsRequest request) async {
    return fastHandler<NotificationsResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getNotifications(request),
    );
  }

  @override
  Future<Either<Failure, ProfileResponse>> getProfile() async {
    return fastHandler<ProfileResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.getProfile(),
    );
  }

  @override
  Future<Either<Failure, ProfileResponse>> updateAccount(UpdateAccountRequest request) async {
    return fastHandler<ProfileResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.updateAccount(request),
    );
  }

  @override
  Future<Either<Failure, AiChatResponse>> aiChat(AiChatRequest request) async {
    return fastHandler<AiChatResponse>(
      connectivity: _networkConnectivity,
      request: () async => await _appServices.aiChat(request),
    );
  }
}
