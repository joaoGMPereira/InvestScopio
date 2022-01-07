import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/UI/DesignSystemWidgets/text_widget.dart';
import 'package:mobx/mobx.dart';

import 'simulation_creation_store.dart';

class SimulationCreationScreen extends StatefulWidget {
  SimulationCreationScreen();

  @override
  _SimulationCreationScreenState createState() =>
      _SimulationCreationScreenState();
}

class _SimulationCreationScreenState extends State<SimulationCreationScreen> {
  final List<ReactionDisposer> _disposers = [];
  SimulationCreationStore _store = Modular.get();

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
            child:
                TextWidget(text: "Criação", style: Style.subtitle)));
  }

  void _installListeners() {
    _disposers.add(reaction((_) => _store.showToast, (message) {}));
  }
}
