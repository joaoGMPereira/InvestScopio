import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/UI/Core/tab_bar.dart';
import 'package:invest_scopio/app/app_foundation/core/logger/logger.dart';
import 'package:invest_scopio/app/home/di/home_module.dart';
import 'package:invest_scopio/app/home/i18n/localization_ext.dart';
import 'package:invest_scopio/app/settings/di/settings_module.dart';
import 'package:invest_scopio/app/simulation_creation/di/simulation_creation_module.dart';
import 'package:invest_scopio/app/simulations/di/simulations_module.dart';
import 'package:mobx/mobx.dart';

import 'home_store.dart';

class HomeScreen extends TabBarScreen {
  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends TabBarScreenState<HomeScreen> {
  final List<ReactionDisposer> _disposers = [];
  HomeStore _store = Modular.get();

  @override
  void initState() {
    super.initState();
    _installListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Map<String, IconData> items() {
    Map<String, IconData> map = {};
    HomeTabs.values.forEach((value) {
      map.addAll({value.label: value.icon});
    });
    return map;
  }

  @override
  List<Widget> getPages() {
    return [SimulationsModule(), SimulationCreationModule(), SettingsModule()];
  }

  @override
  onTap(int index) async {
    _store.onBottomNavClick(index);
  }

  @override
  pageIndex() {
    return _store.pageIndex;
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

enum HomeTabs { Simulations, Creation, Settings }

extension HomeTabsExtension on HomeTabs {
  String get label {
    switch (this) {
      case HomeTabs.Simulations:
        return Strings.simulations_tab_PT_BR.i18n;
      case HomeTabs.Creation:
        return Strings.simulation_creation_tab_PT_BR.i18n;
      case HomeTabs.Settings:
        return Strings.settings_tab_PT_BR.i18n;
    }
  }

  IconData get icon {
    switch (this) {
      case HomeTabs.Simulations:
        return Icons.list;
      case HomeTabs.Creation:
        return Icons.bar_chart_rounded;
      case HomeTabs.Settings:
        return Icons.settings;
    }
  }
}
