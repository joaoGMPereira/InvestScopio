import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/app_foundation/core/model/pair_model.dart';
import 'package:invest_scopio/app/app_foundation/core/model/status_model.dart';
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
import 'package:invest_scopio/app/app_foundation/modules/login/presentation/login_view_model.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/presentation/ui/login_screen.dart';

class LoginModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        Bind.factory((i) => LoginViewModel()),
        Bind.factory((i) => GetPublicKeyUseCase<PublicKeyModel>()),
        Bind.factory((i) => LoginUseCase<LoginResponse>()),
        Bind.factory((i) => Toogle2FAUseCase<Pair<StatusModel, String>>()),
        Bind.factory((i) => Login2FAUseCase<StatusModel>()),
        Bind.factory((i) => SignInUseCase<StatusModel>()),
        Bind.factory((i) => ForgotPasswordUseCase<StatusModel>()),
        Bind.factory((i) => ResetPasswordUseCase<StatusModel>()),
        Bind.factory((i) => GetUserUseCase<UserModel?>()),
        Bind.factory((i) => SaveUserUseCase()),
      ];

  @override
  Widget get view => LoginScreen();
}
