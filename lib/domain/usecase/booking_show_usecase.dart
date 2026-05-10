import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';



class BookingShowUseCase implements Base<BookingShowUseCaseInput, BookingShowResponse> {
  final RepositoryAbs _repository;

  BookingShowUseCase(this._repository);

  @override
  Future<Either<Failure, BookingShowResponse>> execute(BookingShowUseCaseInput input) async {
    return await _repository.getBooking(input.id);
  }
}

