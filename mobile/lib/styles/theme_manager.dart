import 'package:flutter/material.dart';
import 'package:src/styles/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeManager extends ChangeNotifier {
  ThemeData currentTheme = AppTheme.darkTheme;

  void toggleTheme() {
    currentTheme = (currentTheme == AppTheme.lightTheme) ? AppTheme.darkTheme : AppTheme.lightTheme;
    notifyListeners();
  }
}

final themeProvider = Provider<ThemeManager>((ref) => ThemeManager());