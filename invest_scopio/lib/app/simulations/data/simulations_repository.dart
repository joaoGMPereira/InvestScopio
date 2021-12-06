import 'simulations_service.dart';

abstract class SimulationsRepository {

}

class SimulationsRepositoryImpl implements SimulationsRepository {
  final SimulationsService _service;

  SimulationsRepositoryImpl(this._service);
}