import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/app_module/di/app_module.dart';
import 'package:invest_scopio/app/app_module/domain/app_interactor.dart';
import 'package:mobx/mobx.dart';

part 'app_store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore extends Disposable with Store {
  final AppInteractor _interactor;
  final StreamController<AuthController> _streamAuthController;

  _AppStore(this._interactor, this._streamAuthController);

  @observable
  bool isLoading = false;

  @observable
  AuthController? _authController;

  @observable
  String? showToast;

  @action
  init() async {
    _streamAuthController.stream.listen((controller) async {
      _authController = controller;

      await Future.delayed(Duration(seconds: 2));
      if(_authController?.state == AuthState.Logged) {
        Modular.to.pushReplacementNamed("/home/");
      }
    });
  }

  @override
  dispose() {
    _streamAuthController.close();
  }
}
