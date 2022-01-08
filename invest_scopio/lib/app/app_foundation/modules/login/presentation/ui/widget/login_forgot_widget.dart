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

class LoginForgotWidget extends StatefulWidget {
  final LoginViewModel viewModel;

  const LoginForgotWidget(this.viewModel, {Key? key}) : super(key: key);

  @override
  _LoginForgotWidgetState createState() => _LoginForgotWidgetState();
}

class _LoginForgotWidgetState extends State<LoginForgotWidget>
    implements BaseSateWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    _emailController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (_) => ViewStateWidget(
              content: content(),
              onBackPressed: _onBackPressed,
              state: widget.viewModel.state,
              onPressed: () {},
            ));
  }

  Future<bool> _onBackPressed() async {
    widget.viewModel.flow = LoginWidgetFlow.init;
    return false;
  }

  @override
  Widget content() {
    return Observer(builder: (_) {
      _emailController.text = widget.viewModel.user?.profile?.email ?? "";
      return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  child: Column(
                    children: [
                      const TextWidget(
                          text: "Recuperação de senha",
                          style: Style.description),
                      const BoundWidget(BoundType.big),
                      TextFormWidget("Email", Icons.mail, _emailController,
                          (value) {
                        if (value == null ||
                            value.isEmpty == true ||
                            !value.contains("@")) {
                          return 'valid email needed';
                        }
                        return null;
                      }),
                      const BoundWidget(BoundType.big),
                      ButtonWidget(
                        ButtonType.normal,
                        () {
                          if (_formKey.currentState?.validate() == true) {
                            widget.viewModel.forgot(_emailController.text);
                          }
                        },
                        label: "Recuperar",
                      ),
                      const BoundWidget(BoundType.big),
                      ButtonWidget(
                        ButtonType.borderless,
                        () {
                          widget.viewModel.flow = LoginWidgetFlow.reset;
                        },
                        label: "Já tenho o código",
                      ),
                    ],
                  ),
                  key: _formKey),
            ],
          ));
    });
  }
}