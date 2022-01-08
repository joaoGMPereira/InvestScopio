import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:invest_scopio/app/UI/Core/view_state.dart';
import 'package:invest_scopio/app/UI/component/state/view_state_widget.dart';
import 'package:invest_scopio/app/UI/component/text_widget.dart';

import '../../login_view_model.dart';
import '../login_flow.dart';

class LoginToogle2FAWidget extends StatefulWidget {
  final LoginViewModel viewModel;

  const LoginToogle2FAWidget(this.viewModel, {Key? key}) : super(key: key);

  @override
  _LoginToogle2FAWidgetState createState() => _LoginToogle2FAWidgetState();
}

class _LoginToogle2FAWidgetState extends State<LoginToogle2FAWidget>
    implements BaseSateWidget {
  var isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Observer(
          builder: (_) => ViewStateWidget(
                content: content(),
                onBackPressed: _onBackPressed,
                state: widget.viewModel.state,
                onPressed: () {},
              ));
    });
  }

  Future<bool> _onBackPressed() async {
    widget.viewModel.flow = LoginWidgetFlow.init;
    return false;
  }

  @override
  Widget content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const TextWidget(
            text: "Ativar/desativar 2FA", style: Style.description),
        Switch(
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
              widget.viewModel.toogle2fa(!isSwitched);
            });
          },
        ),
      ],
    );
  }
}
