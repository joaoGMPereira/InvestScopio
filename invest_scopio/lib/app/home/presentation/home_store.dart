import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/app_module/domain/app_interactor.dart';
import 'package:invest_scopio/app/home/domain/home_interactor.dart';
import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore extends Disposable with Store {
  final HomeInteractor _interactor;

  _HomeStore(this._interactor);

  @observable
  bool isLoading = false;

  @observable
  String? showToast;

  @observable
  int pageIndex = 0;

  @action
  init() async {
  }

  onBottomNavClick(int index) {
    pageIndex = index;
  }

  @override
  dispose() {}
}
