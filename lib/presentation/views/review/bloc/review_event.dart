part of 'review_bloc.dart';

@immutable
sealed class ReviewEvent {}

class SubmitReviewEvent extends ReviewEvent {
  final int bookingId;
  final ProviderType providerType;
  final double rating;
  final String comment;
  final double? ratingDoctor;
  final String? commentDoctor;
  final VoidCallback? onSuccess;

  SubmitReviewEvent({
    required this.bookingId,
    required this.providerType,
    required this.rating,
    required this.comment,
    this.ratingDoctor,
    this.commentDoctor,
    this.onSuccess,
  });
}
