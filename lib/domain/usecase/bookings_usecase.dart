import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

class BookingsUseCase implements Base<BookingsRequest, BookingsResponse> {
  final RepositoryAbs _repository;

  BookingsUseCase(this._repository);

  @override
  Future<Either<Failure, BookingsResponse>> execute(BookingsRequest input) async {
    return await _repository.getBookings(input);
  }
}

