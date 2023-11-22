import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

enum RouteType { home, area, settings }

class NavigationOptions {
  final GButton widget;
  final String route;
  final String buttonText;
  final IconData buttonIcon;

  NavigationOptions(
    this.route,
    this.buttonText,
    this.buttonIcon,
  ) : widget = GButton(
          icon: buttonIcon,
          text: buttonText,
        );
}

List<NavigationOptions> createWidgetOptions(BuildContext context) {
  return <NavigationOptions>[
    NavigationOptions(
      "/home",
      translate('home'),
      LineIcons.home,
    ),
    NavigationOptions(
      "/area",
      translate('area'),
      LineIcons.database,
    ),
    NavigationOptions(
      "/log",
      translate('log'),
      LineIcons.file,
    ),
    NavigationOptions(
      "/account",
      translate('account'),
      LineIcons.user,
    ),
  ];
}
