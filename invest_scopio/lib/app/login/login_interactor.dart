import 'package:invest_scopio/app/login/login_repository.dart';

abstract class LoginInteractorProtocol {}

class LoginInteractor extends LoginInteractorProtocol {
  final LoginRepositoryProtocol _repository;

  LoginInteractor(this._repository);
}
