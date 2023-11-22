import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromRGBO(241, 241, 241, 1),
    shadowColor: Colors.black.withOpacity(0.1),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      shadowColor: Colors.black.withOpacity(0.1),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.black,
      ),
    ),
    splashColor: Colors.grey[900]!,
    highlightColor: Colors.grey[900]!,
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    shadowColor: Colors.white.withOpacity(0.1),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Color.fromRGBO(241, 241, 241, 1),
      ),
      bodySmall: TextStyle(
        color: Color.fromRGBO(241, 241, 241, 30),
      ),
    ),
    splashColor: Colors.grey[900]!,
    highlightColor: Colors.grey[900]!,
  );
}
