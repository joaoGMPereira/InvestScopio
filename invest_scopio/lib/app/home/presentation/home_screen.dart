import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:invest_scopio/app/core/logger/logger.dart';
import 'package:invest_scopio/app/home/di/home_module.dart';
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
  Map<String, String> items() => {
    "home": "home",
    "marcas": "marcas",
    "vendedores": "vendedores",
    "pedidos": "pedidos",
    "perfil": "perfil",
  };

  @override
  List<Widget> getPages() {
    return [
      SimulationsModule()
    ];
  }

  @override
  onTap(int index) async {
    //_store.onBottomNavClick(index);
  }

  @override
  pageIndex() {
    return 0;
   // _store.pageIndex;
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


abstract class TabBarScreen extends StatefulWidget {
  TabBarScreen({Key? key}) : super(key: key);
}

abstract class TabBarScreenState<T extends TabBarScreen>
    extends State<T> {
  Offset? position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Observer(
          builder: (_) => IndexedStack(
            index: pageIndex(),
            children: getPages(),
          ),
        ),
        bottomNavigationBar: Observer(
          builder: (_) => TabBottomNavigationBar(
            currentIndex: pageIndex(),
            onTap: onTap,
            items: items(),
          ),
        ));
  }

  int pageIndex();

  Map<String, String> items();

  List<Widget> getPages();

  Future onTap(int index);
}


class TabBottomNavigationBar extends StatelessWidget {
  final ValueChanged<int> onTap;
  final int currentIndex;
  final Map<String, String> items;

  static const double _iconHeight = 24;

  const TabBottomNavigationBar({
    Key? key,
    required this.onTap,
    required this.currentIndex,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: _getBottomNavItems(items),
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }

  List<BottomNavigationBarItem> _getBottomNavItems(Map<String, String> items) =>
      items.entries
          .map((entry) => _getBottomNavigationBarItem(entry.key, entry.value))
          .toList();

  BottomNavigationBarItem _getBottomNavigationBarItem(
      String assetName,
      String label,
      ) =>
      BottomNavigationBarItem(
        icon: _getCoreAssetIcon(assetName, isSelected: false),
        activeIcon: _getCoreAssetIcon(assetName, isSelected: true),
        label: label,
      );

  Widget _getCoreAssetIcon(String assetName, {required bool isSelected}) =>
      Icon(Icons.add,
        size: _iconHeight,
        color: isSelected
            ? Colors.redAccent
            : Colors.greenAccent,
      );
}
