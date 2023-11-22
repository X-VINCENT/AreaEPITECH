import 'package:flutter/material.dart';

Widget routeTitle({required String title, required BuildContext context,
  double? size}) {
  return Text(title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: size ?? 48,
        fontFamily: "Rockwell",
        color: Theme.of(context).textTheme.displayLarge?.color,
      ));
}
