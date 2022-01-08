import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:invest_scopio/app/UI/Core/view_state.dart';
import 'package:invest_scopio/app/UI/component/state/view_state_widget.dart';
import 'package:invest_scopio/app/UI/component/text_widget.dart';
import 'package:invest_scopio/app/UI/component/ui/bound_widget.dart';
import 'package:invest_scopio/app/UI/component/ui/button_widget.dart';
import 'package:invest_scopio/app/UI/component/ui/text_from_widget.dart';

import '../../login_view_model.dart';
import '../login_flow.dart';

class LoginSigninWidget extends StatefulWidget {
  final LoginViewModel viewModel;

  const LoginSigninWidget(this.viewModel, {Key? key}) : super(key: key);

  @override
  _LoginSigninWidgetState createState() => _LoginSigninWidgetState();
}

class _LoginSigninWidgetState extends State<LoginSigninWidget>
    implements BaseSateWidget {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _mailController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  late bool _passwordVisible;
  late String password = "";

  @override
  void initState() {
    _passwordVisible = true;
    _nameController.text = '';
    _mailController.text = '';
    _passwordController.text = '';
    _surnameController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (_) => ViewStateWidget(
            content: content(),
            state: widget.viewModel.state,
            onBackPressed: _onBackPressed,
            onPressed: () {
              _signin();
            }));
  }

  Widget content() {
    return Form(
      child: signinForm(),
      key: _formKey,
    );
  }

  Widget signinForm() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const TextWidget(text: "Create Account", style: Style.description),
          const BoundWidget(BoundType.medium),
          TextFormWidget('Name', Icons.person, _nameController, (value) {
            if (value == null || value.isEmpty == true) {
              return 'valid name needed';
            }
            return null;
          }),
          const BoundWidget(BoundType.medium),
          TextFormWidget('Surname', Icons.person, _surnameController, (value) {
            if (value == null || value.isEmpty == true) {
              return 'valid surname needed';
            }
            return null;
          }),
          const BoundWidget(BoundType.medium),
          TextFormWidget('Email', Icons.mail, _mailController, (value) {
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
            } else {
              password = value;
            }
            return null;
          }, obscure: _passwordVisible),
          const BoundWidget(BoundType.medium),
          TextFormWidget('Confirm password', Icons.vpn_key, _passwordController,
              (value) {
            if (value == null || value.isEmpty == true) {
              return 'Password needed';
            } else if (value != password) {
              return 'Password not the same';
            }
            return null;
          }, obscure: _passwordVisible),
          const BoundWidget(BoundType.medium),
          ButtonWidget(
            ButtonType.normal,
            () {
              _signin();
            },
            label: "Create account",
          )
        ],
      ),
    );
  }

  _signin() {
    if (_formKey.currentState?.validate() == true) {
      widget.viewModel.signin(
          _nameController.text,
          _surnameController.text,
          _mailController.text,
          _passwordController.text);
    }
  }

  Future<bool> _onBackPressed() async {
    widget.viewModel.flow = LoginWidgetFlow.init;
    return false;
  }
}