import 'package:flutter/material.dart';

String getCurrentRoute(BuildContext context) {
  final currentRoute = ModalRoute.of(context)?.settings.name;
  return currentRoute ?? '/unknown';
}