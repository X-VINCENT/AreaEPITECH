import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'shared_preferences.dart';

class TranslatePreferences implements ITranslatePreferences
{
  static const String selectedLocaleKey = 'language';
  String currentLanguage = "en_US";

  @override
  Future<Locale?> getPreferredLocale() async {
    SharedPref sharedPref = await SharedPref.getInstance();

    String? localeString = await sharedPref.read(selectedLocaleKey);
    if (localeString == null) {
      return localeFromString(currentLanguage);
    }
    return localeFromString(localeString);
  }

  @override
  Future savePreferredLocale(Locale locale) async
  {
    SharedPref sharedPref = await SharedPref.getInstance();

    sharedPref.write(selectedLocaleKey, localeToString(locale));
  }
}