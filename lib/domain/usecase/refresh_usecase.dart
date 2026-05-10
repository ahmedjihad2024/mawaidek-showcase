import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';

class RefreshUseCase {
  final RepositoryAbs _repository;

  RefreshUseCase(this._repository);

  Future<Either<Failure, RefreshResponse>> execute() async {
    return await _repository.refresh();
  }
}

