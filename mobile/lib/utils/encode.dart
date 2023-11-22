import 'dart:convert';
import 'package:flutter/material.dart';

String encodeControllerMap(Map<String, dynamic> controllerMap) {
  final Map<String, dynamic> encodedMap = {};

  controllerMap.forEach((key, controller) {
    if (controller is TextEditingController) {
      encodedMap[key] = controller.text;
    } else {
      encodedMap[key] = controller;
    }
  });

  final String json = jsonEncode(encodedMap);
  return json;
}

int? stringToIntIfNumeric(String input) {
  if (RegExp(r'^[0-9]+$').hasMatch(input)) {
    return int.tryParse(input);
  } else {
    return null;
  }
}

Map<String, TextEditingController> convertMapToTextControllers(Map<String, dynamic> input) {
  final Map<String, TextEditingController> result = {};

  input.forEach((key, value) {
    if (value is int) {
      result[key] = TextEditingController(text: value.toString());
    } else if (value is String) {
      result[key] = TextEditingController(text: value);
    } else {
      result[key] = TextEditingController();
    }
  });
  return result;
}

Map<String, dynamic> convertStringToMap(String jsonString) {
  try {
    final Map<String, dynamic> resultMap = jsonDecode(jsonString);
    return resultMap;
  } catch (e) {
    print("Erreur lors de la conversion de la chaîne en carte : $e");
    return {};
  }
}

Map<String, dynamic> convertTextControllersToMap(
    Map<String, TextEditingController> input) {
  final Map<String, dynamic> result = {};

  input.forEach((key, controller) {
    if (RegExp(r'^[0-9]+$').hasMatch(controller.text)) {
      result[key] = int.tryParse(controller.text);
    } else {
      result[key] = controller.text;
    }
  });
  return result;
}

Map<String, dynamic> formatAction(
    String name,
    String description,
    bool isActive,
    num actionId,
    num reactionId,
    String delay,
    Map<String, TextEditingController> actionConfig,
    Map<String, TextEditingController> reactionConfig) {
  Map<String, dynamic> out = {
    'name': name,
    'description': description,
    'active': isActive,
    'refresh_delay': delay,
    'action_id': actionId,
    'action_config': convertTextControllersToMap(actionConfig),
    'reaction_id': reactionId,
    'reaction_config': convertTextControllersToMap(reactionConfig),
  };
  return out;
}