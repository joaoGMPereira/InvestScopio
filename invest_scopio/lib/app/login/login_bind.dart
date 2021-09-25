import 'package:invest_scopio/app/login/login_controller.dart';
import 'package:invest_scopio/app/login/login_interactor.dart';
import 'package:invest_scopio/app/login/login_repository.dart';
import 'package:get/get.dart';

class LoginBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() {
      final repository = LoginRepository(Get.find());
      final interactor = LoginInteractor(repository);
      return LoginController(interactor);
    });
  }
}