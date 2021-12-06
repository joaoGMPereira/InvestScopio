import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/simulation_creation/domain/simulation_creation_interactor.dart';
import 'package:mobx/mobx.dart';

part 'simulation_creation_store.g.dart';

class SimulationCreationStore = _SimulationCreationStore with _$SimulationCreationStore;

abstract class _SimulationCreationStore extends Disposable with Store {
  final SimulationCreationInteractor _interactor;

  _SimulationCreationStore(this._interactor);

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
