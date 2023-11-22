import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enhanced_http/enhanced_http.dart';
import 'package:src/components/other/profile_pic.dart';
import 'package:src/app.dart';
import 'package:src/components/other/route_title.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:src/components/other/user_info.dart';
import 'package:src/components/button/dark_mode_field.dart';
import 'package:src/components/button/square_button.dart';
import 'package:src/components/auth/column_auth_rectangle_settings.dart';
import 'package:src/data/local_storage/secure_storage.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:src/data/constants.dart';


class Account extends ConsumerStatefulWidget {
  @override
  ConsumerState<Account> createState() => _Account();
}

class _Account extends ConsumerState<Account> {
  final LocalSecureStorage storage = LocalSecureStorage();
  List<String> listLangue = ["de", "fr", "us", "es"];

  @override
  Widget build(BuildContext context) {
    Widget dropDownMenuLanguage() {
      return DropdownMenu<String>(
        width: 100,
        initialSelection: App.of(context).getLocale(),
        onSelected: (value) => {
          App.of(context).setLocale(Locale.fromSubtags(languageCode: value!)),
          setState(() {})
        },
        dropdownMenuEntries:
            listLangue.map<DropdownMenuEntry<String>>((String value) {
          return DropdownMenuEntry<String>(value: value, label: value);
        }).toList(),
      );
    }

    void goWelcomePage() {
      Navigator.pushNamed(context, '/welcome');
    }

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(top: 80, left: 30),
                child: Row(children: [
                  routeTitle(title: translate('account'), context: context)
                ]),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 80, left: 60),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: dropDownMenuLanguage(),
                  ))
            ]),
            Padding(
                padding: const EdgeInsets.only(top: 90),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ProfilePicture()])),
            Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [UserInfo()],
                )),
            const Padding(
              padding: EdgeInsets.only(top: 60),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [DarkSwitches()]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10), child: ColumnRectangleAuth(),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SquareButton(
                      text: "logout",
                      callback: () async {
                        final auth = ref.watch(authProvider);
                        auth?.deleteProvider();
                        await storage.delete("token");
                        await storage.delete("user");
                        ref.read(areaStatePageProvider).setPage(AreaStatePage.home);
                        goWelcomePage();
                      })
                ])),
          ],
        ));
  }
}
