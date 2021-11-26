import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/app_module/di/app_module.dart';
import 'package:invest_scopio/app/app_module/presentation/app_screen.dart';
import 'app_config.dart';
export 'package:kotlin_flavor/scope_functions.dart';

void startEnvironment({required String baseUrl}) {
  startApp(appConfig: AppConfig(baseUrl: baseUrl));
}

Future<void> startApp({required AppConfig appConfig}) async {
  await _startFirebase();
  _systemSetup();
  runApp(_appWidget(appConfig:appConfig));
}

Future _startFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

void _systemSetup() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

Widget _appWidget({required AppConfig appConfig}) {
  return ModularApp(module: AppModule(appConfig), child: AppScreen());
}
