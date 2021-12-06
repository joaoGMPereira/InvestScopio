import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/app_module/di/app_module.dart';

class LoginWidget extends StatelessWidget {
  final StreamController<AuthController> _streamAuthController;

  LoginWidget(this._streamAuthController);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
              child: Text("Logar"),
              onPressed: () {
                AuthController authController = Modular.get();
                authController.state = AuthState.Logged;
                _streamAuthController.add(authController);
              })),
    );
  }
}