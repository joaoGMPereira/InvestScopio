import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/app_module/domain/app_interactor.dart';
import 'package:mobx/mobx.dart';

part 'app_store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore extends Disposable with Store {
  final AppInteractor _interactor;

  _AppStore(this._interactor);

  @observable
  bool isLoading = false;

  @observable
  String? showToast;

  @action
  init() async {
  }

  @override
  dispose() {}
}
