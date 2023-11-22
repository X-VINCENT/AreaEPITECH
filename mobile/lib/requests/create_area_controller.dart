import 'package:src/data/constants.dart';
import 'package:flutter/material.dart';

class AreaController {
  Map<ControllerAreaState, List<dynamic>> infoController = {};
  Map<String, TextEditingController> action = {};
  Map<String, TextEditingController> reaction = {};
  num actionId = 0;
  num reactionId = 0;
  num areaId = 0;
  Color actionColor = Colors.white;
  Color reactionColor = Colors.white;

  AreaController() {
    infoController[ControllerAreaState.name] = [TextEditingController()];
    infoController[ControllerAreaState.description] = [TextEditingController()];
    infoController[ControllerAreaState.active] = [bool];
    infoController[ControllerAreaState.delay] = [TextEditingController()];
  }

  dynamic getController(ControllerAreaState info) {
    return infoController[info]![0];
  }

  Map<String, TextEditingController> getAction() {
    return action;
  }

    Map<String, TextEditingController> getReaction() {
    return reaction;
  }

  void setAction(Map<String, TextEditingController> newAction) {
    action = newAction;
  }

  void setReaction(Map<String, TextEditingController> newReaction) {
    reaction = newReaction;
  }

  void setActionId(num id) {
    actionId = id;
  }

  void setReactionId(num id) {
    reactionId = id;
  }

  num getActionId() {
    return actionId;
  }

  num getReactionId() {
    return reactionId;
  }

  Color getActionColor() {
    return actionColor;
  }

  Color getReactionColor() {
    return reactionColor;
  }

  void setColorId(num i, Color color, bool isActions) {
    if (isActions == true) {
      actionColor = color;
      actionId = i;
    } else {
      reactionColor = color;
      reactionId = i;
    }
  }

  void setSwitch() {
    infoController[ControllerAreaState.active]![0] =
        !infoController[ControllerAreaState.active]![0];
  }

  void initSwitch(bool value) {
    infoController[ControllerAreaState.active]![0] = value;
  }

  num getAreaId() {
    return areaId;
  }

  void setAreaId(num i) {
    areaId = i;
  }

  void resetState() {}
}
