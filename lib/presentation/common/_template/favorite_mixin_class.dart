import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:mawadk/app/dependency_injection.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/app/services/app_preferences.dart';
import 'package:mawadk/app/user_messages.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/usecase/provider_toggle_like_usecase.dart';
import 'package:mawadk/presentation/common/utils/snackbar_helper.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';

import '../utils/favorite_observer.dart';

// a common mixin to handle favorite toggling
mixin FavoritesMixin<E, S> on Bloc<E, S> {
  Future<void> handleToggleFavorite({
    S Function()? loadingState,
    required int id,
    required Emitter<S> emit,
    S Function()? errorState,
    S Function()? successState,
  }) async {
    if (!instance<AppPreferences>().isUserRegistered) {
      SnackbarHelper.showMessage(
          Translation.please_login_first.tr, ErrorMessage.snackBar);
      return;
    }

    if (loadingState != null) {
      emit(loadingState());
    }

    // product favorite
    Either<Failure, ProviderLikeResponse> response =
        await instance<ProviderToggleLikeUseCase>().execute(id);

    response.fold((failure) {
      SnackbarHelper.showMessage(
          failure.userMessage, ErrorMessage.snackBar);
      if (errorState != null) emit(errorState());
    }, (data) {
      if (data.data ?? false) {
        FavoritesManager.instance.add(id);
      } else {
        FavoritesManager.instance.remove(id);
      }
      if (successState != null) emit(successState());
    });
  }
}
