import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:invest_scopio/app/UI/Core/view_state.dart';
import 'package:invest_scopio/app/UI/component/state/view_state_widget.dart';
import 'package:invest_scopio/app/UI/component/ui/bound_widget.dart';
import 'package:invest_scopio/app/UI/component/ui/button_widget.dart';

import '../../login_view_model.dart';
import '../login_flow.dart';

class LoginInitialWidget extends StatefulWidget {
  final LoginViewModel viewModel;

  const LoginInitialWidget(this.viewModel, {Key? key}) : super(key: key);

  @override
  _LoginInitialWidgetState createState() => _LoginInitialWidgetState();
}

class _LoginInitialWidgetState extends State<LoginInitialWidget>
    implements BaseSateWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => ViewStateWidget(
        content: content(),
        state: widget.viewModel.state,
        onBackPressed: _onBackPressed,
        onPressed: () {}),
    );
  }

  Future<bool> _onBackPressed() async {
    widget.viewModel.flow = LoginWidgetFlow.init;
    return false;
  }

  @override
  Widget content() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonWidget(
            ButtonType.normal,
            () {
              widget.viewModel.flow = LoginWidgetFlow.login;
            },
            label: "Já tenho uma conta",
          ),
          const BoundWidget(BoundType.huge),
          ButtonWidget(
            ButtonType.normal,
            () {
              widget.viewModel.flow = LoginWidgetFlow.signin;
            },
            label: "Criar uma conta",
          ),
        ],
      ),
    );
  }
}
