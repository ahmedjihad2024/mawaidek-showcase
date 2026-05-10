import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

import '../../data/request/request.dart';

class HomeUseCase implements Base<GetHomeRequest, HomeResponse> {
  final RepositoryAbs _repository;

  HomeUseCase(this._repository);

  @override
  Future<Either<Failure, HomeResponse>> execute(GetHomeRequest request) async {
    return await _repository.getHome(request);
  }
}
