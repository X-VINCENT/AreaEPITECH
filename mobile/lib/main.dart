import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:src/data/local_storage/translate_preferences.dart';
import 'app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = TranslatePreferences();

  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en_US',
    supportedLocales: ['en_US', 'es_ES', 'fr_FR', 'de_DE'],
    preferences: preferences,
  );

  await dotenv.load(fileName: ".env");
  runApp(
    ProviderScope(
      child: LocalizedApp(delegate, const App()),
    )
  );
}