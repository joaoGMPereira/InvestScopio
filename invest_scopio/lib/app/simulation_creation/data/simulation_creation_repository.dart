import 'simulation_creation_service.dart';

abstract class SimulationCreationRepository {

}

class SimulationCreationRepositoryImpl implements SimulationCreationRepository {
  final SimulationCreationService _service;

  SimulationCreationRepositoryImpl(this._service);
}