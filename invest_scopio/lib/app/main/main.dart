import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:invest_scopio/app/core/app_di/app_di.dart';
import 'package:invest_scopio/app/login/login_bind.dart';
import 'package:invest_scopio/app/login/login_widget.dart';
import 'app_config.dart';
export 'package:kotlin_flavor/scope_functions.dart';

void startEnvironment({@required String? baseUrl}) {
  startApp(appConfig: AppConfig(baseUrl: baseUrl));
}

Future<void> startApp({@required AppConfig? appConfig}) async {
  await _startFirebase();
  await setupDI(appConfig);
  _systemSetup();
  runApp(_appWidget());
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

Widget _appWidget() {
  return GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/login',
    theme: FlexColorScheme.dark(scheme: FlexScheme.bigStone).toTheme,
    getPages: [
      GetPage(name: '/login', page: () => LoginWidget(), binding: LoginBind()),
    ],
  );
}
