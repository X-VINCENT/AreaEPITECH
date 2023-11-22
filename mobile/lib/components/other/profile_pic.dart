import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:src/styles/app_theme.dart';

class ProfilePicture extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String path = ref.read(userPreferencesProvider).getTheme() == AppTheme.darkTheme ?
    'assets/images/profile-invert.png' : 'assets/images/profile.png';
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        image: DecorationImage(
          image: AssetImage(path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
