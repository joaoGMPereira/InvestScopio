import 'package:invest_scopio/app/app_foundation/modules/login/domain/model/bearer_token_model.dart';

class LoginResponse {
  late BearerTokenModel bearerToken;
  late bool required2FA;

  LoginResponse(this.bearerToken, this.required2FA);

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
        BearerTokenModel.fromJson(json['bearerToken']), json['required2FA']);
  }

  mockable() {}

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "bearerToken": bearerToken,
      "required2FA": required2FA
    };
    return json;
  }
}
