import 'package:invest_scopio/app/app_foundation/core/data/http_request.dart';
import 'package:invest_scopio/app/app_foundation/core/domain/base_usecase.dart';
import 'package:invest_scopio/app/app_foundation/core/model/pair_model.dart';
import 'package:invest_scopio/app/app_foundation/core/model/status_model.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/presentation/ui/login_flow.dart';

class Toogle2FAUseCase<T> extends BaseUseCase<T> {
  @override
  Future<void> invoke(
      {required Function(T) success, required Function error}) async {
    var response = await super.remote(
        Request(endpoint: "api/v1/auth/2fa/toogle", verb: HTTPVerb.get));
    if (response.isSuccessfully) {
      var message = '';
      if (response.data) {
        message = "2FA habilitado";
      } else {
        message = "2FA desabilitado";
      }
      success(Pair<StatusModel, bool>(
          StatusModel(
              message: message, action: "Ok", next: LoginWidgetFlow.otpQr),
          response.data) as T);
    } else {
      error(response.exception);
    }
  }
}
