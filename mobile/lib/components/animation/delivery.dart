import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

Widget floor() {
  return Container(
    color: const Color.fromRGBO(53, 58, 64, 1),
    height: 2,
    width: 500,
  );
}

Widget delivery() {
  final controller = SimpleAnimation('Move');

  return Stack(
    children: [
      SizedBox(
        height: 500,
        width: 500,
        child: RiveAnimation.asset(
          'assets/riv/delivery.riv',
          fit: BoxFit.cover,
          controllers: [controller],
        ),
      ),
      Positioned(
        bottom: 205,
        child: floor(),
      )
    ],
  );
}
