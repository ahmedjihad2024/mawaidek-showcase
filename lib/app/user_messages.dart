import 'package:mawadk/data/network/error_handler/error_handler.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';

extension UserMessages on Failure {
  String get userMessage => switch (this) {
        // Dio-specific errors
        DioLocalError(message: final msg) => msg ?? DEFAULT_ERROR_MESSAGE,
        CustomDioLocalError(error: final dioError) =>
          dioError?.message ?? DEFAULT_ERROR_MESSAGE,

        // Server-side errors
        ServerError(message: final msg) => msg ?? Translation.error_server.tr,
        CustomServerError(error: final apiError) => switch (apiError) {
            ApiErrorType.EMAIL_TAKEN => Translation.email_taken.tr,
            ApiErrorType.USER_NOT_CONFIRMED =>
              Translation.user_not_confirmed.tr,
            ApiErrorType.UNAUTHORIZED => Translation.unauthorized.tr,
            ApiErrorType.INCORRECT_PASSWORD_OR_EMAIL =>
              Translation.incorrect_password_or_email.tr,
            ApiErrorType.INVALID_CODE ||
            _ =>
              apiError?.message ?? DEFAULT_ERROR_MESSAGE,
          },

        // Unexpected errors
        UnexpectedError(message: final msg) => msg ?? DEFAULT_ERROR_MESSAGE,

        // No internet connection
        NoInternetConnection() => Translation.error_no_internet.tr,
        _ => DEFAULT_ERROR_MESSAGE
      };
}

final DEFAULT_ERROR_MESSAGE = Translation.error_generic.tr;
