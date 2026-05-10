import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

class ProviderRatingsUseCaseInput {
  final int id;
  final int? page;

  ProviderRatingsUseCaseInput(this.id, {this.page});
}

class ProviderRatingsUseCase implements Base<ProviderRatingsUseCaseInput, ProviderRatingsResponse> {
  final RepositoryAbs _repository;

  ProviderRatingsUseCase(this._repository);

  @override
  Future<Either<Failure, ProviderRatingsResponse>> execute(ProviderRatingsUseCaseInput input) async {
    return await _repository.getProviderRatings(input.id, page: input.page);
  }
}
