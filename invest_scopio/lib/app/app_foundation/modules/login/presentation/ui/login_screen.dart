import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/UI/Core/view_state.dart';
import 'package:invest_scopio/app/UI/component/ui/icon_button_widget.dart';

import '../login_view_model.dart';
import 'login_flow.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements BaseScreen {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final viewModel = Modular.get<LoginViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.getPublickey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: Observer(
            builder: (_) => viewModel.flow.lastFlow == null
                ? IconButtonWidget(
                    icon: Icons.arrow_back_ios_outlined, onPressed: () {
                      viewModel.flow = viewModel.flow.lastFlow ?? LoginWidgetFlow.init;
            })
                : Container(),
          ),
          title: const Text('InvestScopio'),
        ),
        body: Observer(builder: (_) {
          return navigate();
        }));
  }

  @override
  Widget navigate() {
    return LoginNavigation.flow(viewModel);
  }
}
