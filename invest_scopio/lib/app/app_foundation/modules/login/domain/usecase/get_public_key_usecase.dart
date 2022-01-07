import 'package:invest_scopio/app/app_foundation/core/data/http_request.dart';
import 'package:invest_scopio/app/app_foundation/core/domain/base_usecase.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/domain/model/public_key_model.dart';

class GetPublicKeyUseCase<T> extends BaseUseCase<T> {
  @override
  Future<void> invoke(
      {required Function(T) success, required Function error}) async {
    var response = await super.remote(
        Request(endpoint: "api/v1/auth/rsa/public-key", verb: HTTPVerb.get));
    if (response.isSuccessfully) {
      var data = response.data == null
          ? error()
          : PublicKeyModel.fromJson(response.data) as T;
      success(data);
    } else {
      error(response.exception);
    }
  }
}
