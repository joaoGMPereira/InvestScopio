import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invest_scopio/app/UI/Core/view_state.dart';
import 'package:invest_scopio/app/UI/component/ui/icon_button_widget.dart';
import 'package:mobx/mobx.dart';

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
  final List<ReactionDisposer> _disposers = [];

  @override
  void initState() {
    super.initState();
    viewModel.getPublickey();
    _installListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: Observer(
            builder: (_) => viewModel.flow.previous != null
                ? IconButtonWidget(
                    icon: Icons.arrow_back_ios_outlined,
                    onPressed: () {
                      viewModel.state = ViewState.ready;
                      viewModel.flow =
                          viewModel.flow.previous ?? LoginWidgetFlow.init;
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

  _installListeners() {
    _disposers.add(
      reaction((_) => viewModel.state, (ViewState? viewState) {
        if (viewState == ViewState.error) {
          Fluttertoast.showToast(
              msg: "This is Center Short Toast",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              backgroundColor: Theme.of(context).colorScheme.error,
              fontSize: 16.0);
        }
      }),
    );
  }
}
