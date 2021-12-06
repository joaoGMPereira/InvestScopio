import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/core/logger/logger.dart';
import 'package:invest_scopio/app/core/logger/logger_interceptor.dart';
import 'package:invest_scopio/app/core/logger/logger_store.dart';
import 'package:invest_scopio/app/core/networks/network.dart';
import 'package:invest_scopio/app/core/storage/storage_core.dart';
import 'package:invest_scopio/app/core/storage/storage_repository.dart';
import 'package:invest_scopio/app/app_module/presentation/login_widget.dart';
import 'package:invest_scopio/app/home/di/home_module.dart';
import 'package:invest_scopio/app/main/app_config.dart';
import 'package:invest_scopio/app/app_module/data/app_repository.dart';
import 'package:invest_scopio/app/app_module/data/app_service.dart';
import 'package:invest_scopio/app/app_module/domain/app_interactor.dart';
import 'package:invest_scopio/app/app_module/presentation/app_store.dart';

class AppModule extends Module {
  final AppConfig _appConfig;

  AppModule(this._appConfig);

  @override
  List<Bind> get binds => [
        Bind<AppConfig>((_) => _appConfig),
        Bind<AuthController>((_) => AuthController()),
        Bind<StreamController<AuthController>>(
            (_) => StreamController<AuthController>()),
        Bind<LoggerStore>((_) => LoggerStore()),
        Bind<Logger>((_) => Logger(Modular.get())),
        Bind<LoggerInterceptor>((_) => LoggerInterceptor(Modular.get())),
        Bind<StorageCore>((_) => StorageCoreImpl()),
        Bind<StorageRepository>(
          (_) => StorageRepositoryImpl(Modular.get()),
        ),
        Bind((_) =>
            Network.create(_appConfig.baseUrl, Modular.get(), Modular.get())),
        Bind<AppService>((_) => AppService(Modular.get())),
        Bind<AppRepository>((_) => AppRepositoryImpl(Modular.get())),
        Bind<AppInteractorImpl>(
            (_) => AppInteractorImpl(Modular.get(), Modular.get())),
        Bind<AppStore>((_) => AppStore(Modular.get(), Modular.get())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => LoginWidget(Modular.get())),
        ModuleRoute('/home', module: HomeModule()),
      ];
}

class AuthController {
  AuthState state = AuthState.NotLogged;
}

enum AuthState { Logged, NotLogged, ReAuth, Disconnected }
