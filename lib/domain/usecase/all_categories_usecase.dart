import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

class AllCategoriesUseCase implements Base<void, AllCategoriesResponse> {
  final RepositoryAbs _repository;

  AllCategoriesUseCase(this._repository);

  @override
  Future<Either<Failure, AllCategoriesResponse>> execute(void input) async {
    return await _repository.getAllCategories();
  }
}
