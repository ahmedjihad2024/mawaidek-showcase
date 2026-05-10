import 'package:dartz/dartz.dart';
import 'package:mawadk/data/network/error_handler/failure.dart';
import 'package:mawadk/data/request/request.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/domain/repository/repository.dart';
import 'package:mawadk/domain/usecase/base.dart';

class ContactUsUseCase implements Base<ContactUsRequest, ContactUsResponse> {
  final RepositoryAbs _repository;

  ContactUsUseCase(this._repository);

  @override
  Future<Either<Failure, ContactUsResponse>> execute(ContactUsRequest input) async {
    return await _repository.contactUs(input);
  }
}
