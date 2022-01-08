import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/UI/Core/view_state.dart';
import 'package:invest_scopio/app/app_foundation/core/data/local_exception.dart';
import 'package:invest_scopio/app/app_foundation/core/model/pair_model.dart';
import 'package:invest_scopio/app/app_foundation/core/model/status_model.dart';
import 'package:invest_scopio/app/app_foundation/core/service/api_exception.dart';
import 'package:invest_scopio/app/app_foundation/core/tools/crypto/crypto_service.dart';
import 'package:invest_scopio/app/app_foundation/core/tools/routes.dart';
import 'package:invest_scopio/app/app_foundation/core/tools/session.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/data/model/login_response.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/domain/model/public_key_model.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/domain/model/user_model.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/domain/usecase/forgot_password_usecase.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/domain/usecase/get_public_key_usecase.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/domain/usecase/get_user_usecase.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/domain/usecase/login_2fa_usecase.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/domain/usecase/login_usecase.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/domain/usecase/reset_password_usecase.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/domain/usecase/save_user_usecase.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/domain/usecase/sign_in_usecase.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/domain/usecase/toogle_2fa_usecase.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/presentation/ui/login_flow.dart';
import 'package:mobx/mobx.dart';

part 'login_view_model.g.dart';

class LoginViewModel = _LoginViewModel with _$LoginViewModel;

abstract class _LoginViewModel with Store {
  _LoginViewModel();

  @observable
  ViewState state = ViewState.loading;

  @observable
  LoginWidgetFlow flow = LoginWidgetFlow.init;

  @observable
  UserModel? user;

  @observable
  StatusModel? status;

  @observable
  String? otpQR;

  @observable
  bool loginAutomatically = true;

  final publicKeyUseCase = Modular.get<GetPublicKeyUseCase<PublicKeyModel>>();
  final loginUseCase = Modular.get<LoginUseCase<LoginResponse>>();
  final toogleUseCase =
      Modular.get<Toogle2FAUseCase<Pair<StatusModel, String>>>();
  final login2FAUseCase = Modular.get<Login2FAUseCase<StatusModel>>();
  final signInUseCase = Modular.get<SignInUseCase<StatusModel>>();
  final forgotPasswordUseCase =
      Modular.get<ForgotPasswordUseCase<StatusModel>>();
  final resetPasswordUseCase = Modular.get<ResetPasswordUseCase<StatusModel>>();
  final getUserUseCase = Modular.get<GetUserUseCase<UserModel?>>();
  final saveUserUseCase = Modular.get<SaveUserUseCase>();

  void getPublickey() async {
    state = ViewState.loading;
    await publicKeyUseCase.invoke(success: (response) {
      Session.instance.setKeyChain(CryptoService.instance.generateAESKeys());
      Session.instance.setRSAKey(response);
      getUser();
    }, error: (ApiException error) {
      state = ViewState.error;
    });
  }

  void login(String email, String password) async {
    state = ViewState.loading;
    await loginUseCase.params(email: email, password: password).invoke(
        success: (data) {
          Session.instance.setBearerToken(data.bearerToken);
          saveUser(email, password);
          if (data.required2FA) {
            flow = LoginWidgetFlow.login2fa;
          } else {
            Modular.to.navigate(Routes.leagues);
          }
        },
        error: onApiError);
  }

  void toogle2fa(bool value) async {
    state = ViewState.loading;
    toogleUseCase.invoke(
        success: (data) {
          otpQR = data.second;
          status = data.first;
          state = ViewState.ready;
          flow = LoginWidgetFlow.status;
        },
        error: onApiError);
  }

  void login2fa(String code) async {
    state = ViewState.loading;
    await login2FAUseCase
        .params(
            code: code, token: Session.instance.getBearerToken()?.token ?? '')
        .invoke(
            success: (data) {
              status = data;
            },
            error: onApiError);
  }

  void signin(String name, String surname, String mail, String password) async {
    state = ViewState.loading;
    await signInUseCase
        .params(name: name, surname: surname, email: mail, password: password)
        .invoke(
            success: (data) {
              status = data;
              state = ViewState.ready;
              flow = LoginWidgetFlow.status;
            },
            error: onApiError);
  }

  void forgot(String mail) async {
    state = ViewState.loading;
    await forgotPasswordUseCase.params(email: mail).invoke(
        success: (data) {
          status = data;
          flow = LoginWidgetFlow.status;
          state = ViewState.ready;
        },
        error: onApiError);
  }

  void reset(String mail, String password, String code) async {
    state = ViewState.loading;
    await resetPasswordUseCase
        .params(code: code, email: code, password: password)
        .invoke(
            success: (data) {
              state = ViewState.ready;
              status = data;
              flow = LoginWidgetFlow.status;
            },
            error: onApiError);
  }

  void getUser() async {
    state = ViewState.loading;
    await getUserUseCase.invoke(
        success: (data) {
          state = ViewState.ready;
          if (data != null) {
            user = data;
            if (loginAutomatically) {
              login(data.profile?.email ?? '', data.auth?.password ?? '');
            }
          }
        },
        error: onApiError);
  }

  void saveUser(String email, String password) async {
    await saveUserUseCase
        .params(email: email, password: password)
        .invoke(success: (data) {}, error: onLocalError);
  }

  void onApiError(ApiException error) {
    status = StatusModel(
        message: error.message,
        action: "Ok",
        next: LoginWidgetFlow.init,
        previous: flow);

    if (error.isBusiness()) {
      state = ViewState.ready;
      flow = LoginWidgetFlow.status;
    } else {
      state = ViewState.error;
    }
  }

  void onLocalError(LocalException error) {
    status = StatusModel(
        message: error.message,
        action: "Ok",
        next: LoginWidgetFlow.init,
        previous: flow);

    state = ViewState.error;
  }

  void retry() {
    state = ViewState.ready;
    flow = status?.previous ?? LoginWidgetFlow.init;
  }
}
