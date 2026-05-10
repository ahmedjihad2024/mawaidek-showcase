import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

class CategoriesUseCase implements Base<CategoriesRequest, CategoriesResponse> {
  final RepositoryAbs _repository;

  CategoriesUseCase(this._repository);

  @override
  Future<Either<Failure, CategoriesResponse>> execute(CategoriesRequest input) async {
    return await _repository.getCategories(input);
  }
}
