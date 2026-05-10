import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

class PaymentStatusUseCase implements Base<int, PaymentStatusResponse> {
  final RepositoryAbs _repository;

  PaymentStatusUseCase(this._repository);

  @override
  Future<Either<Failure, PaymentStatusResponse>> execute(int input) async {
    return await _repository.getPaymentStatus(input);
  }
}

/// Releases a slot held by a non-terminal payment_transaction (e.g.
/// when the user backs out of the Sadad PaymentScreen). Idempotent:
/// calling this on an already-paid or already-cancelled transaction
/// returns the current state without changing anything.
class PaymentCancelUseCase implements Base<int, PaymentStatusResponse> {
  final RepositoryAbs _repository;

  PaymentCancelUseCase(this._repository);

  @override
  Future<Either<Failure, PaymentStatusResponse>> execute(int input) async {
    return await _repository.cancelPaymentTransaction(input);
  }
}


/// Re-mints a fresh Sadad SDK token for an in-flight (non-terminal)
/// payment_transaction. Used by the "Try again" path after the user
/// backed out of PaymentScreen.
class PaymentRetryUseCase implements Base<int, BookingCreateResponse> {
  final RepositoryAbs _repository;

  PaymentRetryUseCase(this._repository);

  @override
  Future<Either<Failure, BookingCreateResponse>> execute(int input) async {
    return await _repository.retryPaymentTransaction(input);
  }
}


/// Wakes up a half-finished online payment from a previously-created
/// booking (e.g. when the user backed out of the Sadad sheet or the OS
/// killed the app). Server-side this finds the latest non-terminal
/// payment_transaction for the booking and mints a fresh SDK token.
class PaymentResumeUseCase implements Base<int, BookingCreateResponse> {
  final RepositoryAbs _repository;

  PaymentResumeUseCase(this._repository);

  @override
  Future<Either<Failure, BookingCreateResponse>> execute(int input) async {
    return await _repository.resumeBookingPayment(input);
  }
}
