import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:invest_scopio/app/UI/Core/view_state.dart';
import 'package:invest_scopio/app/UI/component/state/view_state_widget.dart';
import 'package:invest_scopio/app/UI/component/text_widget.dart';
import 'package:invest_scopio/app/UI/component/ui/bound_widget.dart';
import 'package:invest_scopio/app/UI/component/ui/button_widget.dart';

import '../../login_view_model.dart';
import '../login_flow.dart';

class Login2FAWidget extends StatefulWidget {
  final LoginViewModel viewModel;

  const Login2FAWidget(this.viewModel, {Key? key}) : super(key: key);

  @override
  _Login2FAWidgetState createState() => _Login2FAWidgetState();
}

class _Login2FAWidgetState extends State<Login2FAWidget>
    implements BaseSateWidget {
  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      content: content(),
      onBackPressed: _onBackPressed,
      state: widget.viewModel.state,
    );
  }

  Future<bool> _onBackPressed() async {
    widget.viewModel.loginAutomatically = false;
    widget.viewModel.flow = LoginWidgetFlow.login;
    return false;
  }

  @override
  Widget content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const TextWidget(
            text: "Second Step Verification", style: Style.description),
        const BoundWidget(BoundType.medium),
        OtpTextField(
          autoFocus: true,
          numberOfFields: 6,
          showFieldAsBox: true,
          onCodeChanged: (String code) {},
          onSubmit: (String code) {
            widget.viewModel.login2fa(code);
          },
        ),
        const BoundWidget(BoundType.huge),
        ButtonWidget(
          ButtonType.borderless,
          () {
            widget.viewModel.flow = LoginWidgetFlow.resetCode;
          },
          label: "I can't access",
        ),
      ],
    );
  }
}
