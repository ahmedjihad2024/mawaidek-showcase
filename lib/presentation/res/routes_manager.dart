import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mawadk/app/dependency_injection.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/presentation/views/booking_details/bloc/booking_details_bloc.dart';
import 'package:mawadk/presentation/views/categories/bloc/categories_bloc.dart';
import 'package:mawadk/presentation/views/confirm_booking/bloc/confirm_booking_bloc.dart';
import 'package:mawadk/presentation/views/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:mawadk/presentation/views/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';
import 'package:mawadk/presentation/views/home/view/screens/home_view.dart';
import 'package:mawadk/presentation/views/notifications/bloc/notifications_bloc.dart';
import 'package:mawadk/presentation/views/profile_completion/bloc/profile_completion_bloc.dart';
import 'package:mawadk/presentation/views/reset_password/bloc/reset_password_bloc.dart';
import 'package:mawadk/presentation/views/sign_in/bloc/sign_in_bloc.dart';

import '../views/help_and_support/bloc/help_and_support_bloc.dart';
import '../views/help_and_support/screens/view/help_and_support.dart';
import '../views/splash/view/splash_view.dart';
import '../views/onboarding/view/screens/onboarding_view.dart';
import '../views/sign_up/view/sign_up_view.dart';
import '../views/sign_in/view/sign_in_view.dart';
import '../views/forgot_password/view/forgot_password_view.dart';
import '../views/terms_and_conditions/bloc/terms_and_conditions_bloc.dart';
import '../views/terms_and_conditions/screens/views/terms_and_conditions_view.dart';
import '../views/verify_code/view/verify_code_view.dart';
import '../views/verify_code/bloc/verify_code_bloc.dart';
import '../views/reset_password/view/reset_password_view.dart';
import '../views/profile_completion/view/screens/profile_completion_view.dart';
import '../views/categories/view/categories_view.dart';
import '../views/edit_profile/view/screens/edit_profile_view.dart';
import '../views/notifications/view/notifications_view.dart';
import '../views/booking_details/view/screens/booking_details_view.dart';
import '../views/services/view/screens/services_view.dart';
import '../views/services/bloc/services_bloc.dart';
import '../views/appointment_booking/view/screens/appointment_booking_view.dart';
import '../views/appointment_booking/bloc/appointment_booking_bloc.dart';
import '../views/confirm_booking/view/screens/confirm_booking_view.dart';
import '../views/reviews/view/screens/reviews_view.dart';
import '../views/reviews/bloc/reviews_bloc.dart';
import '../views/nearby_medical_centers/view/screens/nearby_medical_centers_view.dart';
import '../views/search/view/screens/search_view.dart';
import '../views/category_providers/view/screens/category_providers_view.dart';
import '../views/review/view/screens/review_view.dart';
import '../views/review/bloc/review_bloc.dart';
import '../views/favorites/view/favorites_view.dart';
import '../views/favorites/bloc/favorites_bloc.dart';

enum RoutesManager {
  splash('splash/'),
  onboarding('onboarding/'),
  signUp('sign-up/'),
  signIn('sign-in/'),
  forgotPassword('forgot-password/'),
  verifyCode('verify-code/'),
  resetPassword('reset-password/'),
  profileCompletion('profile-completion/'),
  home('home/'),
  categories('categories/'),
  favorites('favorites/'),
  editProfile('edit-profile/'),
  notifications('notifications/'),
  bookingDetails('booking-details/'),
  services('services/'),
  appointmentBooking('appointment-booking/'),
  confirmBooking('confirm-booking/'),
  reviews('reviews/'),
  nearbyMedicalCenters('nearby-medical-centers/'),
  search('search/'),
  categoryProviders('category-providers/'),
  review('review/'),
  helpAndSupport('help-and-support/'),
  termsAndConditions('terms-and-conditions/');

  final String route;

  const RoutesManager(this.route);
}

class RoutesGeneratorManager {
  static Widget _getScreen(String? name, RouteSettings settings) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    return switch (RoutesManager.values.firstWhere((t) => t.route == name)) {
      RoutesManager.splash => const SplashView(),
      RoutesManager.onboarding => const OnboardingView(),
      RoutesManager.signUp => const SignUpView(),
      RoutesManager.signIn => BlocProvider(
          create: (context) => instance<SignInBloc>(),
          child: const SignInView(),
        ),
      RoutesManager.forgotPassword => _getForgotPassword(settings),
      RoutesManager.verifyCode => _getVerifyCodeView(settings),
      RoutesManager.resetPassword => _getResetPasswordView(settings),
      RoutesManager.profileCompletion => _getProfileCompletionView(settings),
      RoutesManager.home => _getHomeView(settings),
      RoutesManager.categories => _getCategoriesView(settings),
      RoutesManager.favorites => _getFavoritesView(settings),
      RoutesManager.editProfile => _getEditProfileView(settings),
      RoutesManager.notifications => _getNotificationsView(settings),
      RoutesManager.bookingDetails => _getBookingDetailsView(settings),
      RoutesManager.services => _getServicesView(settings),
      RoutesManager.appointmentBooking => _getAppointmentBookingView(settings),
      RoutesManager.confirmBooking => _getConfirmBookingView(settings),
      RoutesManager.reviews => _getReviewsView(settings),
      RoutesManager.nearbyMedicalCenters => const NearbyMedicalCentersView(),
      RoutesManager.search => _getSearchView(settings),
      RoutesManager.categoryProviders => _getCategoryProvidersView(settings),
      // RoutesManager.helpAndSupport => _getHelpAndSupportView(settings),
      // RoutesManager.termsAndConditions => _getTermsAndConditionsView(settings),
      // RoutesManager.review => _getReviewView(settings),
      default => const Scaffold(body: Center(child: Text("Route Hidden"))),
    };
  }

  // custom navigation animation with iOS back swipe gesture support
  static Route<dynamic> getRoute(RouteSettings settings) {
    final screen = _getScreen(settings.name, settings);

    // On iOS, use CupertinoPageRoute for native back swipe gesture
    if (Platform.isIOS) {
      return CupertinoPageRoute(
        settings: settings,
        builder: (_) => screen,
      );
    }

    // On Android, use a slide + fade transition.
    //
    // What changed (Feb 2026):
    //   - Duration trimmed from 400ms to 280ms — Material 3 spec hovers
    //     around 250-300ms; 400ms felt sluggish on flagship devices.
    //   - The previous fade wrapped Opacity around `curvedAnimation.value`,
    //     which is the SLIDE curve, so the fade tracked the slide instead
    //     of being its own opacity ramp. Replaced with a proper
    //     FadeTransition driven by a CurveTween parallel to the slide.
    //   - Slide direction is RTL-aware: in Arabic the page should enter
    //     from the LEFT (matching the visual reading direction), in
    //     English from the RIGHT.
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final isRTL = Directionality.of(context) == TextDirection.rtl;
        final begin = Offset(isRTL ? -1.0 : 1.0, 0.0);
        const end = Offset.zero;

        return SlideTransition(
          position: Tween(begin: begin, end: end).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            ),
          ),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
              reverseCurve: Curves.easeIn,
            ),
            child: child,
          ),
        );
      },
    );
  }

  // static Route<dynamic> getRoute(RouteSettings settings) => MaterialPageRoute(
  //     builder: _getBuilder(settings.name, settings), settings: settings);
  static Widget _getBookingDetailsView(RouteSettings settings) {
    final arguments = (settings.arguments as Map<String, dynamic>?) ?? {};
    return BlocProvider(
      create: (context) => instance<BookingDetailsBloc>(),
      child: BookingDetailsView(
        bookingId: arguments['booking-id'] as int? ?? 0,
        onReviewSubmitted: arguments['on-review-submitted'] as VoidCallback?,
        onBookingCancelled: arguments['on-booking-cancelled'] as VoidCallback?,
      ),
    );
  }

  static Widget _getServicesView(RouteSettings settings) {
    Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
    return BlocProvider(
      create: (context) => ServicesBloc()
        ..add(GetProviderShowEvent(providerId: args['provider-id'])),
      child: ServicesView(
        providerId: args['provider-id'],
        exploreType: args['exploreType'],
      ),
    );
  }

  static Widget _getSearchView(RouteSettings settings) {
    return SearchView(
        exploreType: (settings.arguments
                as Map<String, dynamic>?)?['exploreType'] as ProviderType? ??
            ProviderType.Doctor);
  }

  static Widget _getProfileCompletionView(RouteSettings settings) {
    Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
    return BlocProvider(
      create: (context) => instance<ProfileCompletionBloc>(),
      child: ProfileCompletionView(
        phoneNumber: arguments['phone-number'],
        password: arguments['password'],
      ),
    );
  }

  static Widget _getVerifyCodeView(RouteSettings settings) {
    Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
    return BlocProvider(
      create: (context) => instance<VerifyCodeBloc>(),
      child: VerifyCodeView(
        verifyOtpType: arguments['verify-otp-type'],
        userId: arguments['user-id'],
      ),
    );
  }

  static Widget _getForgotPassword(RouteSettings settings) {
    return BlocProvider(
      create: (context) => instance<ForgotPasswordBloc>(),
      child: const ForgotPasswordView(),
    );
  }

  static Widget _getResetPasswordView(RouteSettings settings) {
    Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
    return BlocProvider(
      create: (context) => instance<ResetPasswordBloc>(),
      child: ResetPasswordView(type: arguments['reset-password-type']),
    );
  }

  static Widget _getHomeView(RouteSettings settings) {
    return BlocProvider(
      create: (context) => instance<HomeBloc>(),
      child: HomeView(),
    );
  }

  static Widget _getCategoriesView(RouteSettings settings) {
    return BlocProvider(
      create: (context) => instance<CategoriesBloc>(),
      child: const CategoriesView(),
    );
  }

  static Widget _getReviewsView(RouteSettings settings) {
    Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
    final providerId = arguments['provider-id'] as int;

    return BlocProvider(
      create: (context) => instance<ReviewsBloc>()
        ..add(GetProviderRatingsEvent(providerId: providerId)),
      child: ReviewsView(
        providerId: providerId,
      ),
    );
  }

  static Widget _getAppointmentBookingView(RouteSettings settings) {
    Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
    final providerId = arguments['provider-id'] as int;
    final providerType = arguments['provider-type'] as ProviderType;
    final department = arguments['department'] as Category;
    final providerName = arguments['provider-name'] as String;

    return BlocProvider(
      create: (context) => AppointmentBookingBloc(
        providerId: providerId,
        categoryId: department.id,
      )..add(GetAvailableTimesEvent(
          date: DateTime.now(),
          categoryId: department.id,
          providerId: providerId,
        )),
      child: AppointmentBookingView(
        providerId: providerId,
        department: department,
        providerName: providerName,
        providerType: providerType,
      ),
    );
  }

  static Widget _getConfirmBookingView(RouteSettings settings) {
    Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
    final providerId = arguments['provider-id'] as int;
    final providerDoctorId = arguments['provider-doctor-id'] as int?;
    final date = arguments['date'] as DateTime;
    final time = arguments['time'] as String;
    final period = arguments['period'] as BookingPeriod;
    final providerType = arguments['provider-type'] as ProviderType;

    return BlocProvider(
      create: (context) => instance<ConfirmBookingBloc>()
        ..add(GetBookingConfirmEvent(
          providerId: providerId,
          providerDoctorId: providerDoctorId,
        )),
      child: ConfirmBookingView(
        providerId: providerId,
        providerDoctorId: providerDoctorId,
        date: date,
        time: time,
        period: period,
        providerType: providerType,
      ),
    );
  }

  static Widget _getCategoryProvidersView(RouteSettings settings) {
    Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
    final category = arguments['category'] as Category;

    return CategoryProvidersView(
      category: category,
    );
  }

  static Widget _getHelpAndSupportView(RouteSettings settings) {
    return BlocProvider(
      create: (context) => instance<HelpAndSupportBloc>(),
      child: const HelpAndSupportView(),
    );
  }

  static Widget _getTermsAndConditionsView(RouteSettings settings) {
    return BlocProvider(
      create: (context) => instance<TermsAndConditionsBloc>(),
      child: const TermsAndConditionsView(),
    );
  }

  static Widget _getFavoritesView(RouteSettings settings) {
    return BlocProvider(
      create: (context) => instance<FavoritesBloc>()
        ..add(GetFavoritesEvent(
          providerType: ProviderType.Doctor,
          isRefresh: true,
        )),
      child: const FavoritesView(),
    );
  }

  static Widget _getReviewView(RouteSettings settings) {
    Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
    final bookingId = arguments['booking-id'] as int;
    final providerType = arguments['provider-type'] as ProviderType;
    final doctorImage = arguments['doctor-image'] as String;
    final doctorName = arguments['doctor-name'] as String;

    return BlocProvider(
      create: (context) => ReviewBloc(),
      child: ReviewView(
        bookingId: bookingId,
        providerType: providerType,
        doctorImage: doctorImage,
        doctorName: doctorName,
      ),
    );
  }

  static Widget _getEditProfileView(RouteSettings settings) {
    return BlocProvider(
      create: (context) =>
          instance<EditProfileBloc>()..add(GetProfileDetailsEvent()),
      child: const EditProfileView(),
    );
  }

  static Widget _getNotificationsView(RouteSettings settings) {
    Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
    final onReviewSubmitted =
        arguments['on-review-submitted'] as void Function(int bookingId);
    final onBookingCancelled =
        arguments['on-booking-cancelled'] as void Function(int bookingId);

    return BlocProvider(
      create: (context) => instance<NotificationsBloc>(),
      child: NotificationsView(
        onReviewSubmitted: onReviewSubmitted,
        onBookingCancelled: onBookingCancelled,
      ),
    );
  }
}
