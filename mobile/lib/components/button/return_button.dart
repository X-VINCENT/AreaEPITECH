import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:src/styles/app_theme.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:src/data/constants.dart';

class ReturnButtonArea extends ConsumerStatefulWidget {
  @override
  ConsumerState<ReturnButtonArea> createState() => _ReturnButtonArea();
}

class _ReturnButtonArea extends ConsumerState<ReturnButtonArea> {
  @override
  Widget build(BuildContext context) {
    String path = ref.read(userPreferencesProvider).getTheme() == AppTheme.darkTheme ?
    'assets/images/back-invert.png' : 'assets/images/back.png';
    return TouchableOpacity(
        activeOpacity: 0.4,
        onTap: () => {
          ref.read(areaStatePageProvider).setPage(AreaStatePage.home),
          ref.read(areaCreateProvider)?.resetProvider(),
        },
        child: SizedBox(
          width: 35,
          height: 35,
          child: Image.asset(path),
        ));
  }
}
