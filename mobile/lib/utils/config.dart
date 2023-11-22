import 'package:flutter/material.dart';
import 'package:src/data/provider/user_provider.dart';

Map<String, TextEditingController> configActionReactionFromProvider(
    bool isActions,
    ServiceProvider servicesProvider,
    num id) {
  List<Map<String, dynamic>> dataList = [];
  List<bool> listTypes = [];
  Map<String, dynamic> data = {};
  Map<String, TextEditingController> controller = {};

  if (isActions == true) {
    dataList = servicesProvider.getActions()!;
  } else {
    dataList = servicesProvider.getReactions()!;
  }

  for (var i = 0; i < dataList.length; i++) {
    if (dataList[i]['id'] == id) {
      data = dataList[i];
    }
  }

  List<Map<String, dynamic>> configList =
      List<Map<String, dynamic>>.from(data['config_keys'] ?? []);

  for (var i = 0; i < configList.length; i++) {
    final configId = configList[i]['id'];
    listTypes.add(configList[i]['type'] == "number");
    controller[configId] = TextEditingController();
  }
  if (isActions == true) {
    servicesProvider.setActionTypes(listTypes);
  } else {
    servicesProvider.setReactionTypes(listTypes);
  }
  return controller;
}

Map<String, TextEditingController> configActionReaction(
    List<Map<String, dynamic>> dataList, num id) {
  List<Map<String, dynamic>> dataList = [];
  Map<String, dynamic> data = {};
  Map<String, TextEditingController> controller = {};

  for (var i = 0; i < dataList.length; i++) {
    if (dataList[i]['id'] == id) {
      data = dataList[i];
    }
  }

  List<Map<String, dynamic>> configList = List<Map<String, dynamic>>.from(data['config_keys'] ?? []);

  for (var i = 0; i < configList.length; i++) {
    final configId = configList[i]['id'];
    controller[configId] = TextEditingController();
  }
  return controller;
}