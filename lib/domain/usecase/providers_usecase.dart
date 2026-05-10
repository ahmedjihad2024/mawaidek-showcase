import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

class ProvidersUseCase implements Base<ProvidersRequest, ProvidersResponse> {
  final RepositoryAbs _repository;

  ProvidersUseCase(this._repository);

  @override
  Future<Either<Failure, ProvidersResponse>> execute(ProvidersRequest input) async {
    return await _repository.getProviders(input);
  }
}
