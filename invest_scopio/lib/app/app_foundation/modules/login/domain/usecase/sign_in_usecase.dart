import 'package:invest_scopio/app/app_foundation/core/data/http_request.dart';
import 'package:invest_scopio/app/app_foundation/core/domain/base_usecase.dart';
import 'package:invest_scopio/app/app_foundation/core/model/status_model.dart';
import 'package:invest_scopio/app/app_foundation/core/tools/crypto/crypto_service.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/data/model/signin_request.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/presentation/ui/login_flow.dart';

import '../model/auth_model.dart';
import '../model/profile_model.dart';
import '../model/user_model.dart';

class SignInUseCase<T> extends BaseUseCase<T> {
  late String _name;
  late String _surname;
  late String _email;
  late String _password;

  SignInUseCase<T> params(
      {required String name,
      required String surname,
      required String email,
      required String password}) {
    _name = name;
    _surname = surname;
    _email = email;
    _password = password;
    return this;
  }

  @override
  Future<void> invoke(
      {required Function(T) success, required Function error}) async {
    var user = UserModel(
        auth: AuthModel(password: CryptoService.instance.sha256(_password)),
        profile: ProfileModel(name: _name, surname: _surname, email: _email));
    var response = await super.remote(Request(
        endpoint: "api/v1/auth/signin",
        verb: HTTPVerb.post,
        params: HTTPRequesParams(
            data: SigninRequest(user), cypherSchema: CypherSchema.rsa)));
    if (response.isSuccessfully) {
      success(StatusModel(
          message: "Conta criada com sucesso",
          action: "Ok",
          next: LoginWidgetFlow.login) as T);
    } else {
      error(response.response);
    }
  }
}
