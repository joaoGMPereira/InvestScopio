import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/settings/data/settings_repository.dart';
import 'package:invest_scopio/app/settings/data/settings_service.dart';
import 'package:invest_scopio/app/settings/domain/settings_interactor.dart';
import 'package:invest_scopio/app/settings/presentation/settings_screen.dart';
import 'package:invest_scopio/app/settings/presentation/settings_store.dart';


class SettingsModule extends WidgetModule {

  @override
  List<Bind> get binds => [
    Bind<SettingsService>((_) => SettingsService(Modular.get())),
    Bind<SettingsRepository>((_) => SettingsRepositoryImpl(Modular.get())),
    Bind<SettingsInteractor>((_) => SettingsInteractorImpl(Modular.get())),
    Bind<SettingsStore>((_) => SettingsStore(Modular.get())),
  ];

    @override
  Widget get view => SettingsScreen();
}

