import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

class ProvidersDoctorsUseCase implements Base<ProvidersDoctorsRequest, ProviderDoctorsResponse> {
  final RepositoryAbs _repository;

  ProvidersDoctorsUseCase(this._repository);

  @override
  Future<Either<Failure, ProviderDoctorsResponse>> execute(ProvidersDoctorsRequest input) async {
    return await _repository.getProviderDoctors(input);
  }
}

