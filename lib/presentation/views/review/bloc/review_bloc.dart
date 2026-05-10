import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mawadk/app/dependency_injection.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/app/user_messages.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/domain/usecase/booking_rate_usecase.dart';
import 'package:mawadk/presentation/common/utils/overlay_loading.dart';
import 'package:mawadk/presentation/common/utils/snackbar_helper.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc() : super(const ReviewState()) {
    on<SubmitReviewEvent>(_onSubmitReviewEvent);
  }

  Future<void> _onSubmitReviewEvent(
      SubmitReviewEvent event, Emitter<ReviewState> emit) async {
    OverlayLoading.instance.show();

    final request = BookingRateRequest(
      bookingId: event.bookingId,
      rating: event.rating,
      comment: event.comment,
      ratingDoctor: event.providerType.isDoctor ? null : event.ratingDoctor,
      commentDoctor: event.providerType.isDoctor ? null : event.commentDoctor,
    );

    final result = await instance<BookingRateUseCase>().execute(request);

    result.fold(
      (failure) {
        OverlayLoading.instance.hide();
        SnackbarHelper.showMessage(failure.userMessage, ErrorMessage.snackBar);
      },
      (response) {
        OverlayLoading.instance.hide();
        event.onSuccess?.call();
      },
    );
  }
}
