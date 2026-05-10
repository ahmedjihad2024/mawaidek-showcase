import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

class BookingRateUseCase implements Base<BookingRateRequest, BookingRateResponse> {
  final RepositoryAbs _repository;

  BookingRateUseCase(this._repository);

  @override
  Future<Either<Failure, BookingRateResponse>> execute(BookingRateRequest input) async {
    return await _repository.rateBooking(input);
  }
}

