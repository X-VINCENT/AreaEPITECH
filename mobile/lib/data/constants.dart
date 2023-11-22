import 'dart:ui';

enum LoadingRegisterState {
  none,
  wrong,
  validated,
}

enum ControllerState {
  email,
  name,
  password,
  cpassword,
}

enum ControllerAreaState {
  name,
  description,
  delay,
  active,
  action,
  reaction,
  actionId,
  reactionId,
}

enum AreaStatePage {
  home,
  create,
  edit,
}

enum AreaUserState {
  none,
  service,
  action,
}

enum AvailableAreaState {
  none,
  menu
}

enum ConnectedTextState {
  connected,
  disconnected,
  noAuth
}

const List<Color> pastelColors = [Color.fromRGBO(197, 254, 195, 100), Color.fromRGBO(230, 226, 255, 100)];

const List<Color> pastelColorsActions = [
  Color.fromRGBO(255, 217, 217, 100),
  Color.fromRGBO(197, 254, 195, 100),
  Color.fromRGBO(230, 226, 255, 100),
  Color.fromRGBO(255, 247, 217, 100),
];
