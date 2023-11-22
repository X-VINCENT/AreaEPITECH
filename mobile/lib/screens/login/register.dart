import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:src/components/form/register_field.dart';

class RegisterColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 600, right: 300),
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
                    padding: const EdgeInsets.only(bottom: 320),
                    child: Text(
                      translate('create_an_account'),
                      style: const TextStyle(
                        fontSize: 40,
                        fontFamily: 'Rockwell',
                      ),
                    ),
                  ),
                ],
              ),
              RegisterField(),
            ]))
      ],
    );
  }
}

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(241, 241, 241, 1),
      body: RegisterColumn(),
    );
  }
}
