import 'package:flutter/material.dart';
import 'package:src/requests/auth/parse.dart';
import 'package:src/data/local_storage/secure_storage.dart';
import 'package:src/components/auth/column_auth_rectangle_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:src/utils/create_templates.dart';
import 'package:src/utils/string.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:src/utils/is_svg.dart';
import 'package:src/data/constants.dart';
import 'package:src/components/other/templates_row.dart';

class ColumnTitleService extends StatefulWidget {
  final String title;
  final ConnectedTextState connectedTextState;

  const ColumnTitleService(
      {required this.title, required this.connectedTextState});
  @override
  State<ColumnTitleService> createState() => _ColumnTitleService();
}

class _ColumnTitleService extends State<ColumnTitleService> {
  Widget connectedText({required ConnectedTextState connectedTextState}) {
    switch (widget.connectedTextState) {
      case ConnectedTextState.connected:
        return Text(
          translate('connected'),
          style: const TextStyle(
            color: Colors.green,
            fontFamily: "Inter",
            fontSize: 14,
          ),
        );
      case ConnectedTextState.disconnected:
        return Text(
          translate('disconnected'),
          style: TextStyle(
            color: Theme.of(context).splashColor,
            fontFamily: "Inter",
            fontSize: 14,
          ),
        );
      case ConnectedTextState.noAuth:
        return Text(
          translate('no_auth'),
          style: TextStyle(
            color: Theme.of(context).splashColor,
            fontFamily: "Inter",
            fontSize: 14,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            capitalizeFirstLetter(widget.title),
            style: TextStyle(
              color: Theme.of(context).textTheme.displayLarge?.color,
              fontFamily: "Inter",
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(left: 10, top: 2),
        child: connectedText(connectedTextState: widget.connectedTextState),
      )
    ]);
  }
}

class RectangleAuthAccount extends ConsumerStatefulWidget {
  final String url;
  final String title;
  final String imagePath;
  final ConnectedTextState connectedTextState;

  const RectangleAuthAccount(
      {required this.url,
      required this.title,
      required this.imagePath,
      required this.connectedTextState});
  @override
  _RectangleAuthAccount createState() => _RectangleAuthAccount();
}

class _RectangleAuthAccount extends ConsumerState<RectangleAuthAccount> {
  LocalSecureStorage storage = LocalSecureStorage();
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    Map<String, dynamic>? userMap = auth?.getUser();
    final servicesProvider = ref.watch(serviceProvider);

    void onLongPressPopReload() {
      Navigator.of(context).pop();
      ColumnRectangleAuth.of(context).reload();
      servicesProvider?.deleteTemplates();
      fillTemplates(auth, servicesProvider);
    }

    Future<dynamic> dialogueConfirmation() {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(translate('disconnect_service')),
              content: Text(translate('disconnect_service_sentence')),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(translate('cancel'))),
                TextButton(
                    onPressed: () async {
                      auth?.deleteByName('${widget.title}_id');
                      await storage.deleteByKey("${widget.title}_id");
                      onLongPressPopReload();
                    },
                    child: Text(translate('confirm'))),
              ],
            );
          });
    }

    void reloadAuth() {
      ColumnRectangleAuth.of(context).reload();
      servicesProvider?.deleteTemplates();
      fillTemplates(auth, servicesProvider);
    }

    return TouchableOpacity(
        activeOpacity: 0.4,
        onLongPress: () {
          if (widget.connectedTextState == ConnectedTextState.connected) {
            dialogueConfirmation();
          }
        },
        onTap: () => {
              if (widget.connectedTextState == ConnectedTextState.disconnected)
                {
                  authProcessParsing(
                      key: widget.title,
                      callback: () async {
                        final userMap = await storage.readMap('user');
                        auth?.addByName("${widget.title}_id",
                            userMap?['${widget.title}_id']);
                        reloadAuth();
                      })
                }
            },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border.all(
              color: Theme.of(context).textTheme.displayLarge?.color ??
                  const Color.fromRGBO(241, 241, 241, 100),
              width: 1.0,
            ),
          ),
          child: SizedBox(
              width: 340,
              height: 60,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: createImageNetwork(url: widget.imagePath)),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: SizedBox(
                        width: 230,
                        height: 40,
                        child: ColumnTitleService(
                            connectedTextState: widget.connectedTextState,
                            title: widget.title),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SizedBox(
                          width: 15,
                          height: 15,
                          child: Image.asset('assets/images/chevron.png')))
                ],
              )),
        ));
  }
}
