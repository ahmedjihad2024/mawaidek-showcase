import 'package:get_it/get_it.dart';
import 'package:mawadk/domain/usecase/booking_cancel_usecase.dart';
import 'package:mawadk/domain/usecase/cancellation_reasons_usecase.dart';
import 'package:mawadk/domain/usecase/faqs_usecase.dart';
import 'package:mawadk/domain/usecase/get_profile_usecase.dart';
import 'package:mawadk/domain/usecase/notifications_usecase.dart';
import 'package:mawadk/domain/usecase/privacy_policy_usecase.dart';
import 'package:mawadk/domain/usecase/terms_and_conditions_usecase.dart';
import 'package:mawadk/domain/usecase/update_account_usecase.dart';
import 'package:mawadk/presentation/views/booking_details/bloc/booking_details_bloc.dart';
import 'package:mawadk/presentation/views/cancel_booking/bloc/cancel_booking_bloc.dart';
import 'package:mawadk/presentation/views/categories/bloc/categories_bloc.dart';
import 'package:mawadk/presentation/views/confirm_booking/bloc/confirm_booking_bloc.dart';
import 'package:mawadk/presentation/views/help_and_support/bloc/help_and_support_bloc.dart';
import 'package:mawadk/presentation/views/nearby_medical_centers/bloc/nearby_medical_centers_bloc.dart';
import 'package:mawadk/presentation/views/reviews/bloc/reviews_bloc.dart';
import 'package:mawadk/presentation/views/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';
import 'package:mawadk/presentation/views/profile_completion/bloc/profile_completion_bloc.dart';
import 'package:mawadk/presentation/views/reset_password/bloc/reset_password_bloc.dart';
import 'package:mawadk/presentation/views/search/bloc/search_bloc.dart';
import 'package:mawadk/presentation/views/sign_in/bloc/sign_in_bloc.dart';
import 'package:mawadk/presentation/views/terms_and_conditions/bloc/terms_and_conditions_bloc.dart';
import 'package:mawadk/presentation/views/verify_code/bloc/verify_code_bloc.dart';
import 'package:mawadk/presentation/views/favorites/bloc/favorites_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mawadk/app/services/app_preferences.dart';
import 'package:mawadk/data/data_source/data_source.dart';
import 'package:mawadk/data/network/api.dart';
import 'package:mawadk/data/network/dio_factory.dart';
import 'package:mawadk/data/network/internet_checker.dart';
import 'package:mawadk/data/repository/repository_impl.dart';
import 'package:mawadk/domain/usecase/login_usecase.dart';
import 'package:mawadk/domain/usecase/register_usecase.dart';
import 'package:mawadk/domain/usecase/check_code_usecase.dart';
import 'package:mawadk/domain/usecase/resend_code_usecase.dart';
import 'package:mawadk/domain/usecase/logout_usecase.dart';
import 'package:mawadk/domain/usecase/remove_account_usecase.dart';
import 'package:mawadk/domain/usecase/refresh_usecase.dart';
import 'package:mawadk/domain/usecase/forget_password_usecase.dart';
import 'package:mawadk/domain/usecase/reset_password_usecase.dart';
import 'package:mawadk/domain/usecase/home_usecase.dart';
import 'package:mawadk/domain/usecase/categories_usecase.dart';
import 'package:mawadk/domain/usecase/all_categories_usecase.dart';
import 'package:mawadk/domain/usecase/contact_us_usecase.dart';
import 'package:mawadk/domain/usecase/providers_usecase.dart';
import 'package:mawadk/domain/usecase/provider_show_usecase.dart';
import 'package:mawadk/domain/usecase/provider_ratings_usecase.dart';
import 'package:mawadk/domain/usecase/provider_toggle_like_usecase.dart';
import 'package:mawadk/domain/usecase/provider_liked_list_usecase.dart';
import 'package:mawadk/domain/usecase/booking_confirm_usecase.dart';
import 'package:mawadk/domain/usecase/booking_available_times_usecase.dart';
import 'package:mawadk/domain/usecase/booking_create_usecase.dart';
import 'package:mawadk/domain/usecase/payment_status_usecase.dart';
import 'package:mawadk/domain/usecase/booking_rate_usecase.dart';
import 'package:mawadk/domain/usecase/bookings_usecase.dart';
import 'package:mawadk/domain/usecase/booking_show_usecase.dart';
import 'package:mawadk/domain/usecase/providers_doctors_usecase.dart';
import 'package:mawadk/domain/usecase/ai_chat_usecase.dart';
import 'package:mawadk/presentation/views/ai_chat/bloc/ai_chat_bloc.dart';

import '../presentation/views/edit_profile/bloc/edit_profile_bloc.dart';
import '../presentation/views/notifications/bloc/notifications_bloc.dart';
import 'enums.dart';

final instance = GetIt.instance;

Future initAppModules() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  instance.registerLazySingleton<AppPreferences>(
      () => AppPreferences(sharedPreferences));
  instance.registerLazySingleton<DioFactory>(
      () => DioFactory(instance<AppPreferences>()));
  instance
      .registerLazySingleton<NetworkConnectivity>(() => NetworkConnectivity());

  // ** Data
  instance.registerLazySingleton<AppServices>(
      () => AppServices(instance<DioFactory>()));
  instance.registerLazySingleton<DataSource>(
      () => DataSource(instance<AppServices>()));
  instance.registerLazySingleton<Repository>(() =>
      Repository(instance<AppServices>(), instance<NetworkConnectivity>()));
  // **

  // ** Blocs
  instance.registerFactory<HomeBloc>(() => HomeBloc());
  instance.registerFactory<VerifyCodeBloc>(() => VerifyCodeBloc());
  instance
      .registerFactory<ProfileCompletionBloc>(() => ProfileCompletionBloc());
  instance.registerFactory<SignInBloc>(() => SignInBloc());
  instance.registerFactory<ForgotPasswordBloc>(() => ForgotPasswordBloc());
  instance.registerFactory<ResetPasswordBloc>(() => ResetPasswordBloc());
  instance.registerFactory<CategoriesBloc>(() => CategoriesBloc());
  instance.registerFactory<ReviewsBloc>(() => ReviewsBloc());
  instance.registerFactory<ConfirmBookingBloc>(() => ConfirmBookingBloc());
  instance.registerFactory<BookingDetailsBloc>(() => BookingDetailsBloc());
  instance.registerFactory<HelpAndSupportBloc>(() => HelpAndSupportBloc());
  instance
      .registerFactory<TermsAndConditionsBloc>(() => TermsAndConditionsBloc());
  instance.registerFactory<FavoritesBloc>(() => FavoritesBloc());
  instance.registerFactory<CancelBookingBloc>(() => CancelBookingBloc());
  instance.registerFactoryParam<SearchBloc, ProviderType, void>((type, _) =>
      SearchBloc(
          providersUseCase: instance<ProvidersUseCase>(),
          allCategoriesUseCase: instance<AllCategoriesUseCase>(),
          exploreType: type));
  instance
      .registerFactory<NearbyMedicalCentersBloc>(() => NearbyMedicalCentersBloc(
            instance<ProvidersUseCase>(),
          ));
  instance.registerFactory<EditProfileBloc>(() => EditProfileBloc(
        instance<GetProfileUseCase>(),
        instance<UpdateAccountUseCase>(),
      ));
  instance.registerFactory<NotificationsBloc>(() => NotificationsBloc(
        instance<NotificationsUseCase>(),
      ));
  // **

  // ** Usecases
  instance.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(instance<Repository>()));
  instance.registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(instance<Repository>()));
  instance.registerLazySingleton<CheckCodeUseCase>(
      () => CheckCodeUseCase(instance<Repository>()));
  instance.registerLazySingleton<ResendCodeUseCase>(
      () => ResendCodeUseCase(instance<Repository>()));
  instance.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(instance<Repository>()));
  instance.registerLazySingleton<RemoveAccountUseCase>(
      () => RemoveAccountUseCase(instance<Repository>()));
  instance.registerLazySingleton<RefreshUseCase>(
      () => RefreshUseCase(instance<Repository>()));
  instance.registerLazySingleton<ForgetPasswordUseCase>(
      () => ForgetPasswordUseCase(instance<Repository>()));
  instance.registerLazySingleton<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(instance<Repository>()));

  instance.registerLazySingleton<HomeUseCase>(
      () => HomeUseCase(instance<Repository>()));
  instance.registerLazySingleton<CategoriesUseCase>(
      () => CategoriesUseCase(instance<Repository>()));
  instance.registerLazySingleton<AllCategoriesUseCase>(
      () => AllCategoriesUseCase(instance<Repository>()));
  instance.registerLazySingleton<ContactUsUseCase>(
      () => ContactUsUseCase(instance<Repository>()));
  instance.registerLazySingleton<ProvidersUseCase>(
      () => ProvidersUseCase(instance<Repository>()));
  instance.registerLazySingleton<ProviderShowUseCase>(
      () => ProviderShowUseCase(instance<Repository>()));

  instance.registerLazySingleton<ProviderRatingsUseCase>(
      () => ProviderRatingsUseCase(instance<Repository>()));
  instance.registerLazySingleton<ProviderToggleLikeUseCase>(
      () => ProviderToggleLikeUseCase(instance<Repository>()));
  instance.registerLazySingleton<ProviderLikedListUseCase>(
      () => ProviderLikedListUseCase(instance<Repository>()));

  instance.registerLazySingleton<BookingConfirmUseCase>(
      () => BookingConfirmUseCase(instance<Repository>()));
  instance.registerLazySingleton<BookingAvailableTimesUseCase>(
      () => BookingAvailableTimesUseCase(instance<Repository>()));
  instance.registerLazySingleton<BookingCreateUseCase>(
      () => BookingCreateUseCase(instance<Repository>()));
  instance.registerLazySingleton<PaymentStatusUseCase>(
      () => PaymentStatusUseCase(instance<Repository>()));
  instance.registerLazySingleton<PaymentCancelUseCase>(
      () => PaymentCancelUseCase(instance<Repository>()));
  instance.registerLazySingleton<PaymentRetryUseCase>(
      () => PaymentRetryUseCase(instance<Repository>()));
  instance.registerLazySingleton<PaymentResumeUseCase>(
      () => PaymentResumeUseCase(instance<Repository>()));
  instance.registerLazySingleton<BookingRateUseCase>(
      () => BookingRateUseCase(instance<Repository>()));
  instance.registerLazySingleton<BookingsUseCase>(
      () => BookingsUseCase(instance<Repository>()));
  instance.registerLazySingleton<BookingShowUseCase>(
      () => BookingShowUseCase(instance<Repository>()));
  instance.registerLazySingleton<ProvidersDoctorsUseCase>(
      () => ProvidersDoctorsUseCase(instance<Repository>()));

  instance.registerLazySingleton<BookingCancelUseCase>(
      () => BookingCancelUseCase(instance<Repository>()));
  instance.registerLazySingleton<CancellationReasonsUseCase>(
      () => CancellationReasonsUseCase(instance<Repository>()));
  instance.registerLazySingleton<FAQsUseCase>(
      () => FAQsUseCase(instance<Repository>()));
  instance.registerLazySingleton<NotificationsUseCase>(
      () => NotificationsUseCase(instance<Repository>()));
  instance.registerLazySingleton<PrivacyPolicyUseCase>(
      () => PrivacyPolicyUseCase(instance<Repository>()));
  instance.registerLazySingleton<TermsAndConditionsUseCase>(
      () => TermsAndConditionsUseCase(instance<Repository>()));
  instance.registerLazySingleton<GetProfileUseCase>(
      () => GetProfileUseCase(instance<Repository>()));
  instance.registerLazySingleton<UpdateAccountUseCase>(
      () => UpdateAccountUseCase(instance<Repository>()));
  instance.registerLazySingleton<AiChatUseCase>(
      () => AiChatUseCase(instance<Repository>()));
  // **

  // ** AI Chat Bloc
  instance
      .registerFactory<AiChatBloc>(() => AiChatBloc(instance<AiChatUseCase>()));
  // **
}
