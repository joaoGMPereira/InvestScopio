import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/simulation_creation/data/simulation_creation_repository.dart';
import 'package:invest_scopio/app/simulation_creation/data/simulation_creation_service.dart';
import 'package:invest_scopio/app/simulation_creation/domain/simulation_creation_interactor.dart';
import 'package:invest_scopio/app/simulation_creation/presentation/simulation_creation_screen.dart';
import 'package:invest_scopio/app/simulation_creation/presentation/simulation_creation_store.dart';


class SimulationCreationModule extends WidgetModule {

  @override
  List<Bind> get binds => [
    Bind<SimulationCreationService>((_) => SimulationCreationService(Modular.get())),
    Bind<SimulationCreationRepository>((_) => SimulationCreationRepositoryImpl(Modular.get())),
    Bind<SimulationCreationInteractor>((_) => SimulationCreationInteractorImpl(Modular.get())),
    Bind<SimulationCreationStore>((_) => SimulationCreationStore(Modular.get())),
  ];

    @override
  Widget get view => SimulationCreationScreen();
}

