import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:src/components/animation/spin_loading_register.dart';
import 'package:src/components/form/form_button.dart';
import 'package:src/data/constants.dart';
import 'package:src/requests/login_controller.dart';
import 'package:src/components/button/auth_button.dart';
import 'package:src/requests/network_services.dart';
import 'package:src/data/local_storage/secure_storage.dart';

class LoginColumn extends ConsumerStatefulWidget {
  @override
  _LoginColumn createState() => _LoginColumn();
}

class _LoginColumn extends ConsumerState<LoginColumn> {
  LoginController controller = LoginController();
  LoadingRegisterState loadingState = LoadingRegisterState.none;
  NetworkServices networkServices = NetworkServices();
  LocalSecureStorage storage = LocalSecureStorage();

  @override
  Widget build(BuildContext context) {
    void myCallback() {
      setState(() => {
            controller.getController(ControllerState.email).text = "",
            controller.getController(ControllerState.password).text = "",
          });
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100, right: 300),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Image(
                    width: 30,
                    height: 30,
                    image: AssetImage('assets/images/back.png'),
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Text(
                  translate('welcome_back'),
                  style: const TextStyle(
                    fontSize: 40,
                    fontFamily: 'Rockwell',
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FormButton(
                  text: translate('email'),
                  controller: controller.getController(ControllerState.email),
                  isFailure:
                      controller.getControllerState(ControllerState.email),
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
                  controller:
                      controller.getController(ControllerState.password),
                  isFailure:
                      controller.getControllerState(ControllerState.password),
                )
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 5),
              child: GestureDetector(
                  onTap: () => {}, child: Text(translate('forgot_password')))),
          Padding(
              padding: const EdgeInsets.only(top: 20),
              child: authButton(
                  buttonText: translate('login'),
                  buttonColor: Colors.black,
                  borderColor: Colors.black,
                  textColor: Colors.white,
                  onPressed: () => {
                        networkServices.postLogin(
                          path: "/api/login",
                          callback: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: SpinLoading(),
                              ),
                            );
                          },
                          body: {
                            "email": controller
                                .getController(ControllerState.email)
                                .text,
                            "password": controller
                                .getController(ControllerState.password)
                                .text,
                          },
                          controller: controller,
                          myCall: myCallback,
                        ),
                      }))
        ]);
  }
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(241, 241, 241, 1),
      body: LoginColumn(),
    );
  }
}
