import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/UI/DesignSystemWidgets/text_widget.dart';
import 'package:mobx/mobx.dart';

import 'simulations_store.dart';

class SimulationsScreen extends StatefulWidget {
  SimulationsScreen();

  @override
  _SimulationsScreenState createState() => _SimulationsScreenState();
}

class _SimulationsScreenState extends State<SimulationsScreen> {
  final List<ReactionDisposer> _disposers = [];
  SimulationsStore _store = Modular.get();

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
        child:
            Center(child: TextWidget(text: "Simulações", style: Style.title)));
    ;
  }

  void _installListeners() {
    _disposers.add(reaction((_) => _store.showToast, (message) {}));
  }
}
