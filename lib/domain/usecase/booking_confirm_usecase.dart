import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

class BookingConfirmUseCase implements Base<BookingConfirmRequest, BookingConfirmResponse> {
  final RepositoryAbs _repository;

  BookingConfirmUseCase(this._repository);

  @override
  Future<Either<Failure, BookingConfirmResponse>> execute(BookingConfirmRequest input) async {
    return await _repository.getBookingConfirm(input);
  }
}

