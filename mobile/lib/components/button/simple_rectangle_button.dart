import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:src/components/button/plus_button.dart';
import 'package:src/data/constants.dart';
import 'package:src/components/button/return_button.dart';
import 'package:src/requests/create_area_controller.dart';
import 'package:src/requests/network_services.dart';
import 'package:animations/animations.dart';
import 'package:src/components/form/form_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class SimpleRectangleButton extends StatelessWidget {
  final String text;
  VoidCallback callback;

  SimpleRectangleButton({Key? key, required this.text, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      activeOpacity: 0.8,
      onTap: callback,
      child: Container(
        width: 340,
        height: 55,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(254, 102, 102, 100),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.only(top: 17, left: 20),
            child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: "Inter",
            ),
            )
          ),
        ),
      ),
    );
  }
}
