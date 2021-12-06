import 'package:invest_scopio/app/simulations/data/simulations_repository.dart';


abstract class SimulationsInteractor {

}

class SimulationsInteractorImpl extends SimulationsInteractor {
  final SimulationsRepository _repository;

  SimulationsInteractorImpl(this._repository);
}
