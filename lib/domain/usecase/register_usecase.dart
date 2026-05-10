import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

class RegisterUseCase implements Base<RegisterRequest, RegisterResponse> {
  final RepositoryAbs _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, RegisterResponse>> execute(RegisterRequest request) async {
    return await _repository.register(request);
  }
}

