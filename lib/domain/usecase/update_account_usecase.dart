import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

class UpdateAccountUseCase implements Base<UpdateAccountRequest, ProfileResponse> {
  final RepositoryAbs _repository;

  UpdateAccountUseCase(this._repository);

  @override
  Future<Either<Failure, ProfileResponse>> execute(UpdateAccountRequest request) async {
    return await _repository.updateAccount(request);
  }
}
