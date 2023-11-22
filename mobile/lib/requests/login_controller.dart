import 'package:src/data/constants.dart';
import 'package:flutter/material.dart';

void parseResponseLogin(
    Map<String, dynamic> jsonResponse, LoginController controller) {
  if (jsonResponse['message'] == "Invalid credentials.") {
    controller.setControllerState(ControllerState.email);
    controller.setControllerState(ControllerState.password);
    return;
  }
  if (jsonResponse['data'] != null) {
    if (jsonResponse['data']['name'] != null) {
      controller.setControllerState(ControllerState.name);
    }
    if (jsonResponse['data']['email'] != null) {
      controller.setControllerState(ControllerState.email);
    }
    if (jsonResponse['data']['password'] != null) {
      controller.setControllerState(ControllerState.password);
    }
    if (jsonResponse['data']['c_password'] != null) {
      controller.setControllerState(ControllerState.cpassword);
    }
  }
}

class LoginController {
  Map<ControllerState, List<dynamic>> infoController = {};

  LoginController() {
    infoController[ControllerState.email] = [TextEditingController(), false];
    infoController[ControllerState.name] = [TextEditingController(), false];
    infoController[ControllerState.password] = [TextEditingController(), false];
    infoController[ControllerState.cpassword] = [
      TextEditingController(),
      false
    ];
  }

  void setControllerState(ControllerState info) {
    infoController[info]![1] = true;
  }

  bool getControllerState(ControllerState info) {
    return infoController[info]![1];
  }

  TextEditingController getController(ControllerState info) {
    return infoController[info]![0];
  }

  void resetState() {
    infoController[ControllerState.email]![1] = false;
    infoController[ControllerState.name]![1] = false;
    infoController[ControllerState.password]![1] = false;
    infoController[ControllerState.cpassword]![1] = false;
  }
}
