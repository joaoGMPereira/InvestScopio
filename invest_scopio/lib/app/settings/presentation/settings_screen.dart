import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/UI/DesignSystemWidgets/text_widget.dart';
import 'package:mobx/mobx.dart';

import 'settings_store.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen();

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<ReactionDisposer> _disposers = [];
  SettingsStore _store = Modular.get();

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
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: TextWidget(
                text: "Configuração", style: Style.subtitle)));
  }

  void _installListeners() {
    _disposers.add(reaction((_) => _store.showToast, (message) {}));
  }
}
