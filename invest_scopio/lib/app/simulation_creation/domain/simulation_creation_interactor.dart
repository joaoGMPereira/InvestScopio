import 'package:invest_scopio/app/simulation_creation/data/simulation_creation_repository.dart';

abstract class SimulationCreationInteractor {

}

class SimulationCreationInteractorImpl extends SimulationCreationInteractor {
  final SimulationCreationRepository _repository;

  SimulationCreationInteractorImpl(this._repository);
}
