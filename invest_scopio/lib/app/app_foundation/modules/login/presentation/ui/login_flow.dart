
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/presentation/ui/widget/login_2fa_otp_qr_widget.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/presentation/ui/widget/login_2fa_otp_widget.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/presentation/ui/widget/login_2fa_toogle_widget.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/presentation/ui/widget/login_forgot_widget.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/presentation/ui/widget/login_form_widget.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/presentation/ui/widget/login_initial_widget.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/presentation/ui/widget/login_reset_widget.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/presentation/ui/widget/login_signin_widget.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/presentation/ui/widget/login_status_widget.dart';

import '../login_view_model.dart';

enum LoginWidgetFlow {
  init,
  login,
  signin,
  login2fa,
  toogle2fa,
  otpQr,
  forgot,
  registration,
  reset,
  resetCode,
  status
}

extension LoginNavigation on LoginWidgetFlow {
  static Widget flow(LoginViewModel vm) {
    switch (vm.flow) {
      case LoginWidgetFlow.init:
        return LoginInitialWidget(vm);
      case LoginWidgetFlow.login:
        return LoginFormWidget(vm);
      case LoginWidgetFlow.signin:
        return LoginSigninWidget(vm);
      case LoginWidgetFlow.login2fa:
        return Login2FAWidget(vm);
      case LoginWidgetFlow.toogle2fa:
        return LoginToogle2FAWidget(vm);
      case LoginWidgetFlow.otpQr:
        return LoginOtpQRWidget(vm);
      case LoginWidgetFlow.forgot:
        return LoginForgotWidget(vm);
      case LoginWidgetFlow.registration:
        return LoginStatusWidget(vm);
      case LoginWidgetFlow.reset:
        return LoginResetWidget(vm);
      case LoginWidgetFlow.resetCode:
        return LoginForgotWidget(vm);
      case LoginWidgetFlow.status:
        return LoginStatusWidget(vm);
    }
  }

  LoginWidgetFlow? get lastFlow {
    switch(this) {
      case LoginWidgetFlow.init:
        return LoginWidgetFlow.init;
      case LoginWidgetFlow.login:
        return LoginWidgetFlow.init;
      case LoginWidgetFlow.signin:
        return LoginWidgetFlow.init;
      case LoginWidgetFlow.login2fa:
        return LoginWidgetFlow.signin;
      case LoginWidgetFlow.toogle2fa:
        return LoginWidgetFlow.login2fa;
      case LoginWidgetFlow.otpQr:
        return LoginWidgetFlow.login2fa;
      case LoginWidgetFlow.forgot:
        return LoginWidgetFlow.login;
      case LoginWidgetFlow.registration:
        return LoginWidgetFlow.forgot;
      case LoginWidgetFlow.reset:
        return LoginWidgetFlow.forgot;
      case LoginWidgetFlow.resetCode:
        return LoginWidgetFlow.login;
      case LoginWidgetFlow.status:
        return null;
    }
  }
}
