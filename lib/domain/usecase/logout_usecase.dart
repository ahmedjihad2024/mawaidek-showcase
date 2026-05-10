import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';

class LogoutUseCase {
  final RepositoryAbs _repository;

  LogoutUseCase(this._repository);

  Future<Either<Failure, LogoutResponse>> execute() async {
    return await _repository.logout();
  }
}

