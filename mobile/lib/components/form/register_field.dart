import 'package:flutter/material.dart';
import 'package:src/components/animation/spin_loading_register.dart';
import 'package:src/components/form/form_button.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:src/requests/login_controller.dart';
import 'package:src/requests/network_services.dart';
import 'package:src/components/button/auth_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:src/data/constants.dart';
import 'package:src/data/local_storage/secure_storage.dart';

class RegisterField extends StatefulWidget {
  @override
  _RegisterFieldColumn createState() => _RegisterFieldColumn();
}

class _RegisterFieldColumn extends State<RegisterField> {
  LoadingRegisterState loadingState = LoadingRegisterState.none;
  LoginController controller = LoginController();

  NetworkServices networkServices = NetworkServices();
  LocalSecureStorage storage = LocalSecureStorage();

  @override
  Widget build(BuildContext context) {
    void myCallback() {
      setState(() {
        controller.getController(ControllerState.cpassword).text = "";
      });
    }

    return Container(
        child: Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 350),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FormButton(
              text: translate('email'),
              controller: controller.getController(ControllerState.email),
              isFailure: controller.getControllerState(ControllerState.email),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FormButton(
              text: translate('username'),
              controller: controller.getController(ControllerState.name),
              isFailure: controller.getControllerState(ControllerState.name),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PasswordButtonWidget(
              text: translate('password'),
              controller: controller.getController(ControllerState.password),
              isFailure:
                  controller.getControllerState(ControllerState.password),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PasswordButtonWidget(
              text: translate('confirm'),
              controller: controller.getController(ControllerState.cpassword),
              isFailure:
                  controller.getControllerState(ControllerState.cpassword),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 40),
        child: authButton(
            buttonText: translate('create_an_account'),
            buttonColor: Colors.black,
            borderColor: Colors.black,
            textColor: Colors.white,
            onPressed: () => {
                  controller.resetState(),
                  networkServices.postLogin(
                    path: "/api/register",
                    callback: () => {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: SpinLoading(),
                        ),
                      )
                    },
                    body: {
                      "email":
                          controller.getController(ControllerState.email).text,
                      "name":
                          controller.getController(ControllerState.name).text,
                      "password": controller
                          .getController(ControllerState.password)
                          .text,
                      "c_password": controller
                          .getController(ControllerState.cpassword)
                          .text,
                    },
                    controller: controller,
                    myCall: myCallback,
                  ),
                  controller.getController(ControllerState.cpassword).text = "",
                }),
      )
    ]));
  }
}
