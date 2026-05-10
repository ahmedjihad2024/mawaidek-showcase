import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

class ProviderShowUseCaseInput {
  final int id;
  final ProviderShowRequest request;

  ProviderShowUseCaseInput(this.id, this.request);
}

class ProviderShowUseCase implements Base<ProviderShowUseCaseInput, ProviderShowResponse> {
  final RepositoryAbs _repository;

  ProviderShowUseCase(this._repository);

  @override
  Future<Either<Failure, ProviderShowResponse>> execute(ProviderShowUseCaseInput input) async {
    return await _repository.getProviderShow(input.id, input.request);
  }
}
