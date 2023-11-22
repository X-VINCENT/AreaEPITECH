import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:src/styles/app_theme.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:src/screens/area/create.dart';

class ButtonPlus extends ConsumerWidget {

  VoidCallback callback;

  ButtonPlus({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String path = ref.read(userPreferencesProvider.notifier).getTheme() ==
            AppTheme.lightTheme
        ? "assets/images/plus-button.png"
        : "assets/images/plus-button-invert.png";

    return TouchableOpacity(
    activeOpacity: 0.4,
    onTap: callback,
    child: SizedBox(
      width: 40,
      height: 40,
      child: Image.asset(path),
    )
    );
  }
}
