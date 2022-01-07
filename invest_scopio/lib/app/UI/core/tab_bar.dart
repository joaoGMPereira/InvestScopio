import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

abstract class TabBarScreen extends StatefulWidget {
  TabBarScreen({Key? key}) : super(key: key);
}

abstract class TabBarScreenState<T extends TabBarScreen> extends State<T> {
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

  Map<String, IconData> items();

  List<Widget> getPages();

  Future onTap(int index);
}

class TabBottomNavigationBar extends StatelessWidget {
  final ValueChanged<int> onTap;
  final int currentIndex;
  final Map<String, IconData> items;

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

  List<BottomNavigationBarItem> _getBottomNavItems(
          Map<String, IconData> items) =>
      items.entries
          .map((entry) => _getBottomNavigationBarItem(entry.key, entry.value))
          .toList();

  BottomNavigationBarItem _getBottomNavigationBarItem(
    String label,
    IconData icon,
  ) =>
      BottomNavigationBarItem(
        icon: _getCoreAssetIcon(icon, isSelected: false),
        activeIcon: _getCoreAssetIcon(icon, isSelected: true),
        label: label,
      );

  Widget _getCoreAssetIcon(IconData icon, {required bool isSelected}) =>
      Icon(icon, size: _iconHeight);
}
