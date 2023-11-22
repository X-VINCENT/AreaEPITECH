import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:src/components/button/square_button.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:src/styles/app_theme.dart';

Color getButtonColor(WidgetRef ref) {
  if (ref.read(userPreferencesProvider.notifier).getTheme() == AppTheme.darkTheme) {
    return const Color.fromRGBO(241, 241, 241, 1);
  }
  return Colors.black;
}

class SquareButton extends ConsumerWidget {
  final String text;
  final VoidCallback callback;

  SquareButton({required this.text, required this.callback});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 340,
      height: 50,
      child: ElevatedButton(
        onPressed: callback,
        style: ElevatedButton.styleFrom(
          backgroundColor: getButtonColor(ref),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        ),
        child: Text(
          translate (text),
          style: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontFamily: "Inter",
            fontWeight: FontWeight.w600,
            fontSize: 16,
          )
        )
      )
    );
  }
}