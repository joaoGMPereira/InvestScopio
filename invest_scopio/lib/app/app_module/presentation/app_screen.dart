import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/core/logger/logger.dart';
import 'package:invest_scopio/app/core/logger/logger_button.dart';
import 'package:mobx/mobx.dart';

import 'app_store.dart';

class AppScreen extends StatefulWidget {
  AppScreen();

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final List<ReactionDisposer> _disposers = [];
  AppStore _store = Modular.get();

  @override
  void initState() {
    _store.init();
    super.initState();
    _installListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "InvestScopio",
      theme: FlexThemeData.dark(
        scheme: FlexScheme.bigStone,
        appBarElevation: 2,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', "US"),
        const Locale('pt', "BR"),
        const Locale('es', "ES")
      ],
    ).modular();
  }

  void _installListeners() {
    _disposers.add(
      reaction((_) => _store.showToast, (message) {
        // if (message != null) _screenUtils.showToast(message);
        // _store.showToast = null;
      }),
    );
  }
}
