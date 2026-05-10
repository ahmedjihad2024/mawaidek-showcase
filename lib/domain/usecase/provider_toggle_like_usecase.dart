import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

class ProviderToggleLikeUseCase implements Base<int, ProviderLikeResponse> {
  final RepositoryAbs _repository;

  ProviderToggleLikeUseCase(this._repository);

  @override
  Future<Either<Failure, ProviderLikeResponse>> execute(int input) async {
    return await _repository.toggleProviderLike(input);
  }
}
