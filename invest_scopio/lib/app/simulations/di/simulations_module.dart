import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/simulations/data/simulations_repository.dart';

import 'package:invest_scopio/app/simulations/data/simulations_service.dart';

import 'package:invest_scopio/app/simulations/domain/simulations_interactor.dart';

import 'package:invest_scopio/app/simulations/presentation/simulations_screen.dart';

import 'package:invest_scopio/app/simulations/presentation/simulations_store.dart';


class SimulationsModule extends WidgetModule {

  @override
  List<Bind> get binds => [
    Bind<SimulationsService>((_) => SimulationsService(Modular.get())),
    Bind<SimulationsRepository>((_) => SimulationsRepositoryImpl(Modular.get())),
    Bind<SimulationsInteractor>((_) => SimulationsInteractorImpl(Modular.get())),
    Bind<SimulationsStore>((_) => SimulationsStore(Modular.get())),
  ];

  @override
  Widget get view => SimulationsScreen();
}