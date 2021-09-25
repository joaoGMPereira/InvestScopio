import 'package:invest_scopio/app/login/login_interactor.dart';
import 'package:kotlin_flavor/scope_functions.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var teste = 0.obs;

  final LoginInteractor _interactor;

  LoginController(this._interactor);

  bump() {
    teste += 1;
  }
}
