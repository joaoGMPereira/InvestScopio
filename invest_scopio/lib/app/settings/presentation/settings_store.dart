import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/settings/domain/settings_interactor.dart';
import 'package:mobx/mobx.dart';

part 'settings_store.g.dart';

class SettingsStore = _SettingsStore with _$SettingsStore;

abstract class _SettingsStore extends Disposable with Store {
  final SettingsInteractor _interactor;

  _SettingsStore(this._interactor);

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
