import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:src/screens/area/create.dart';
import 'package:src/components/navbar/info.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:src/data/constants.dart';
import 'package:src/screens/account/index.dart';
import 'package:src/screens/home/index.dart';
import 'package:src/screens/log/index.dart';

// Screens
import "package:src/screens/area/index.dart";

class ParseArea extends StatelessWidget {

  AreaStatePage statePage;

  ParseArea({Key? key, required this.statePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch(statePage) {
      case AreaStatePage.home:
        return Area();
      case AreaStatePage.create:
        return CreatePage();
      default:
        return Area();
    }
  }}


class Navbar extends ConsumerStatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  ConsumerState<Navbar> createState() => _Navbar();
}

class _Navbar extends ConsumerState<Navbar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    ref.read(areaStatePageProvider).setCallback(() => setState(() => {}));
    ref.read(navbarProvider).setCallbackTapped(_onItemTapped);
  }

  @override
  Widget build(BuildContext context) {
    final List<NavigationOptions> tabs = createWidgetOptions(context);
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              color: Theme.of(context).shadowColor,
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Theme.of(context).splashColor,
              hoverColor: Theme.of(context).highlightColor,
              haptic: true,
              tabBorderRadius: 15,
              tabActiveBorder: Border.all(
                  color: Colors.black, width: 1),
              duration: const Duration(milliseconds: 900),
              gap: 8,
              color: Colors.white.withOpacity(0.5),
              activeColor: Theme.of(context).appBarTheme.iconTheme?.color,
              iconSize: 24,
              tabBackgroundColor: Theme.of(context).splashColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              tabs: tabs.map((option) => option.widget).toList(),
              selectedIndex: _selectedIndex,
              onTabChange: _onItemTapped,
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget> [
          Home(),
          ParseArea(statePage: ref.read(areaStatePageProvider).getPage()),
          Log(),
          Account(),
        ],
      ),
    );
  }
}
