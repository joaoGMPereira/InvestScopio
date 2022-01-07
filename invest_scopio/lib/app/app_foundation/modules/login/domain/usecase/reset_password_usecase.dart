import 'package:invest_scopio/app/app_foundation/core/data/http_request.dart';
import 'package:invest_scopio/app/app_foundation/core/domain/base_usecase.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/data/model/reset_request.dart';
import 'package:invest_scopio/app/app_foundation/core/model/status_model.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/presentation/ui/login_flow.dart';

class ResetPasswordUseCase<T> extends BaseUseCase<T> {
  late String _code;
  late String _email;
  late String _password;

  ResetPasswordUseCase<T> params(
      {required String code, required String email, required String password}) {
    _code = code;
    _email = email;
    _password = password;
    return this;
  }

  @override
  Future<void> invoke(
      {required Function(T) success, required Function error}) async {
    var response = await super.remote(Request(
        endpoint: "api/v1/auth/password/reset",
        verb: HTTPVerb.post,
        params: HTTPRequesParams(
            data: ResetRequest(_email, _password, _code),
            cypherSchema: CypherSchema.rsa)));
    if (response.isSuccessfully) {
      var status = StatusModel(
          message: "Senha resetada", action: "Ok", next: LoginWidgetFlow.login);
      success(status as T);
    } else {
      error(response.exception);
    }
  }
}
