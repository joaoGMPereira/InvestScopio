
import 'package:invest_scopio/app/app_foundation/core/data/http_request.dart';
import 'package:invest_scopio/app/app_foundation/core/domain/base_usecase.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/data/model/login_response.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/data/model/login_request.dart';
import 'package:invest_scopio/app/app_foundation/core/tools/crypto/crypto_service.dart';
import 'package:invest_scopio/app/app_foundation/core/tools/session.dart';

class LoginUseCase<T> extends BaseUseCase<T> {
  late String _email;
  late String _password;

  LoginUseCase<T> params({required String email, required String password}) {
    _email = email;
    _password = password;
    return this;
  }

  @override
  Future<void> invoke(
      {required Function(T) success, required Function error}) async {
    var response = await super.remote(Request(
        endpoint: "api/v1/auth/login",
        verb: HTTPVerb.post,
        params: HTTPRequesParams(
            data: LoginRequest(_email, CryptoService.instance.sha256(_password),
                Session.instance.getKeyChain()),
            cypherSchema: CypherSchema.rsa)));
    if (response.isSuccessfully) {
      success(LoginResponse.fromJson(response.data) as T);
    } else {
      error(response.exception);
    }
  }
}
