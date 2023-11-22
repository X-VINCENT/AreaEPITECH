import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter/cupertino.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:src/styles/app_theme.dart';

class DarkSwitches extends ConsumerStatefulWidget {
  const DarkSwitches({super.key});

  @override
  ConsumerState<DarkSwitches> createState() => _DarkSwitches();
}

class _DarkSwitches extends ConsumerState<DarkSwitches> {
  bool switchValue = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
        translate('dark_mode'),
        style: TextStyle(
          fontFamily: "Rockwell",
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.displayLarge?.color,
        )
      ),
      const SizedBox(
        width: 150,
      ),
      CupertinoSwitch(
        value: ref.read(userPreferencesProvider.notifier).getTheme() == AppTheme.darkTheme,
        activeColor: Colors.black,
        onChanged: (bool? value) => {
          ref.read(userPreferencesProvider.notifier).toggleTheme(),
          setState(() => switchValue = value ?? false)
        },
      )
    ]);
  }
}