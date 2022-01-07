import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:invest_scopio/app/UI/Core/view_state.dart';
import 'package:invest_scopio/app/UI/component/state/view_state_widget.dart';
import 'package:invest_scopio/app/UI/component/ui/bound_widget.dart';
import 'package:invest_scopio/app/UI/component/ui/button_widget.dart';
import 'package:invest_scopio/app/UI/component/ui/text_from_widget.dart';

import '../../login_view_model.dart';
import '../login_flow.dart';

class LoginFormWidget extends StatefulWidget {
  final LoginViewModel viewModel;

  const LoginFormWidget(this.viewModel, {Key? key}) : super(key: key);

  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget>
    implements BaseSateWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    _emailController.text = '';
    _passwordController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      content: content(),
      onBackPressed: _onBackPressed,
      state: widget.viewModel.state,
    );
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
        Form(child: loginForm(), key: _formKey),
        Observer(builder: (_) {
          _emailController.text = widget.viewModel.user?.profile?.email ?? "";
          _passwordController.text = widget.viewModel.user?.auth?.password ?? "";
          return Container();
        }),
      ],
    );
  }

  Widget loginForm() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          TextFormWidget('Email', Icons.mail, _emailController, (value) {
            if (value == null ||
                value.isEmpty == true ||
                !value.contains("@")) {
              return 'valid email needed';
            }
            return null;
          }),
          const BoundWidget(BoundType.medium),
          TextFormWidget('Password', Icons.vpn_key, _passwordController,
              (value) {
            if (value == null || value.isEmpty == true) {
              return 'Password needed';
            }
            if (value.length < 8) {
              return 'Password too short';
            }
            return null;
          }),
          const BoundWidget(BoundType.medium),
          ButtonWidget(
            ButtonType.normal,
            () {
              if (_formKey.currentState?.validate() == true) {
                widget.viewModel
                    .login(_emailController.text, _passwordController.text);
              }
            },
            label: "Entrar",
          ),
          const BoundWidget(BoundType.big),
          ButtonWidget(
            ButtonType.borderless,
            () {
              widget.viewModel.flow = LoginWidgetFlow.resetCode;
            },
            label: "Esqueci a senha",
          ),
        ],
      ),
    );
  }
}
