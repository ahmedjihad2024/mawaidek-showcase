import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

class GetProfileUseCase implements Base<void, ProfileResponse> {
  final RepositoryAbs _repository;

  GetProfileUseCase(this._repository);

  @override
  Future<Either<Failure, ProfileResponse>> execute(void input) async {
    return await _repository.getProfile();
  }
}
