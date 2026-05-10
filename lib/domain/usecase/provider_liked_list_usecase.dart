import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

class ProviderLikedListUseCase implements Base<ProviderLikesRequest, ProvidersResponse> {
  final RepositoryAbs _repository;

  ProviderLikedListUseCase(this._repository);

  @override
  Future<Either<Failure, ProvidersResponse>> execute(ProviderLikesRequest input) async {
    return await _repository.getLikedProviders(input);
  }
}
