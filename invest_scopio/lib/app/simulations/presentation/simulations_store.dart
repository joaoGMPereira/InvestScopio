import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/simulations/domain/simulations_interactor.dart';

import 'package:mobx/mobx.dart';

part 'simulations_store.g.dart';

class SimulationsStore = _SimulationsStore with _$SimulationsStore;

abstract class _SimulationsStore extends Disposable with Store {
  final SimulationsInteractor _interactor;

  _SimulationsStore(this._interactor);

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
