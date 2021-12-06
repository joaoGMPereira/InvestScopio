import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/home/data/home_repository.dart';
import 'package:invest_scopio/app/home/data/home_service.dart';
import 'package:invest_scopio/app/home/domain/home_interactor.dart';
import 'package:invest_scopio/app/home/presentation/home_screen.dart';
import 'package:invest_scopio/app/home/presentation/home_store.dart';


class HomeModule extends Module {

  @override
  List<Bind> get binds => [
    Bind<HomeService>((_) => HomeService(Modular.get())),
    Bind<HomeRepository>((_) => HomeRepositoryImpl(Modular.get())),
    Bind<HomeInteractorImpl>((_) => HomeInteractorImpl(Modular.get(), Modular.get())),
    Bind<HomeStore>((_) => HomeStore(Modular.get())),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (context, args) => HomeScreen()),
    ModuleRoute('/simulation', module: SimulationModule()),
  ];
}

class SimulationModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [];
}