import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

class BookingCreateUseCase implements Base<BookingCreateRequest, BookingCreateResponse> {
  final RepositoryAbs _repository;

  BookingCreateUseCase(this._repository);

  @override
  Future<Either<Failure, BookingCreateResponse>> execute(BookingCreateRequest input) async {
    return await _repository.createBooking(input);
  }
}

