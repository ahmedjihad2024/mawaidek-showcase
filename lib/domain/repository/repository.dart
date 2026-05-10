import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';

import '../../data/request/request.dart';
import '../../data/responses/responses.dart';

abstract class RepositoryAbs {
  Future<Either<Failure, LoginResponse>> login(LoginRequest request);
  Future<Either<Failure, RegisterResponse>> register(RegisterRequest request);
  Future<Either<Failure, CheckCodeResponse>> checkCode(CheckCodeRequest request);
  Future<Either<Failure, ResendCodeResponse>> resendCode(ResendCodeRequest request);
  Future<Either<Failure, LogoutResponse>> logout();
  Future<Either<Failure, RemoveAccountResponse>> removeAccount(RemoveAccountRequest request);
  Future<Either<Failure, RefreshResponse>> refresh();
  Future<Either<Failure, ForgetPasswordResponse>> forgetPassword(ForgetPasswordRequest request);
  Future<Either<Failure, ResetPasswordResponse>> resetPassword(ResetPasswordRequest request);
  Future<Either<Failure, HomeResponse>> getHome(GetHomeRequest request);
  Future<Either<Failure, CategoriesResponse>> getCategories(CategoriesRequest request);
  Future<Either<Failure, AllCategoriesResponse>> getAllCategories();
  Future<Either<Failure, ContactUsResponse>> contactUs(ContactUsRequest request);
  Future<Either<Failure, ProvidersResponse>> getProviders(ProvidersRequest request);
  Future<Either<Failure, ProviderShowResponse>> getProviderShow(int id, ProviderShowRequest request);
  Future<Either<Failure, ProviderRatingsResponse>> getProviderRatings(int id, {int? page});
  Future<Either<Failure, ProviderLikeResponse>> toggleProviderLike(int id);
  Future<Either<Failure, ProvidersResponse>> getLikedProviders(ProviderLikesRequest request);
  Future<Either<Failure, BookingConfirmResponse>> getBookingConfirm(BookingConfirmRequest request);
  Future<Either<Failure, BookingAvailableTimesResponse>> getBookingAvailableTimes(BookingAvailableTimesRequest request);
  Future<Either<Failure, BookingCreateResponse>> createBooking(BookingCreateRequest request);
  Future<Either<Failure, PaymentStatusResponse>> getPaymentStatus(int transactionId);
  Future<Either<Failure, PaymentStatusResponse>> cancelPaymentTransaction(int transactionId);
  Future<Either<Failure, BookingCreateResponse>> retryPaymentTransaction(int transactionId);
  Future<Either<Failure, BookingCreateResponse>> resumeBookingPayment(int bookingId);
  Future<Either<Failure, BookingRateResponse>> rateBooking(BookingRateRequest request);
  Future<Either<Failure, BookingsResponse>> getBookings(BookingsRequest request);
  Future<Either<Failure, BookingShowResponse>> getBooking(int id);
  Future<Either<Failure, ProviderDoctorsResponse>> getProviderDoctors(ProvidersDoctorsRequest request);
  Future<Either<Failure, BookingCancelResponse>> cancelBooking(BookingCancelRequest request);
  Future<Either<Failure, CancellationReasonsResponse>> getCancellationReasons();
  Future<Either<Failure, FAQsResponse>> getFAQs();
  Future<Either<Failure, InfoContentResponse>> getTermsAndConditions();
  Future<Either<Failure, InfoContentResponse>> getPrivacyPolicy();
  Future<Either<Failure, NotificationsResponse>> getNotifications(NotificationsRequest request);
  Future<Either<Failure, ProfileResponse>> getProfile();
  Future<Either<Failure, ProfileResponse>> updateAccount(UpdateAccountRequest request);
  Future<Either<Failure, AiChatResponse>> aiChat(AiChatRequest request);
}
