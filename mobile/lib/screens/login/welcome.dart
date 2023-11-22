import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:src/components/animation/bike.dart';
import 'package:src/screens/login/register.dart';
import 'package:src/components/button/auth_button.dart';
import 'package:src/components/auth/circle.dart';
import 'package:page_transition/page_transition.dart';
import 'package:src/screens/login/login.dart';

class WelcomeColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Positioned(
                top: 150,
                child: BikeLottie(),
              ),
              Positioned(
                  bottom: 250,
                  child: authButton(
                      buttonText: translate('create_an_account'),
                      buttonColor: Colors.black,
                      borderColor: Colors.black,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: Register(),
                          ),
                        );
                      })),
              Positioned(
                bottom: 190,
                child: authButton(
                  buttonText: translate('login'),
                  buttonColor: Colors.white,
                  borderColor: Colors.black,
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: Login(),
                      ),
                    );
                  },
                ),
              ),
              const Positioned(
                top: 100,
                child: Image(
                  image: AssetImage('assets/images/bloblo-welcome-logo.png'),
                  width: 300,
                  height: 100,
                ),
              ),
              const Positioned(
                bottom: 80,
                child: RoundedAuth(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(253, 253, 253, 1),
      body: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: WelcomeColumn(),
      ),
    );
  }
}
