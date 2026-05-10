import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

class LoginUseCase implements Base<LoginRequest, LoginResponse> {
  final RepositoryAbs _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, LoginResponse>> execute(LoginRequest request) async {
    return await _repository.login(request);
  }
}

