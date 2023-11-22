import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:src/data/constants.dart';
import 'package:src/components/other/route_title.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:src/components/button/square_button.dart';
import 'package:src/components/other/templates_row.dart';
import 'package:src/components/auth/column_auth_rectangle_settings.dart';
import 'package:src/data/provider/user_provider.dart';

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80, left: 30),
              child: routeTitle(title: translate('home'), context: context),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 30),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SquareButton(text: "create_your_own_area", callback: () => {
                    ref.read(navbarProvider).onItemTapped(1),
                    ref.read(areaStatePageProvider).setPage(AreaStatePage.create)
                  })
                ])),
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(translate('or'),
                      style: const TextStyle(
                        fontFamily: "Inter",
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ))
                ])),
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 20),
              child: TemplatesRow(),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 15, left: 30),
                child: Text(translate('connect_service_sentence'),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontFamily: "Rockwell",
                      fontSize: 20,
                    ))),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 30),
              child: ColumnRectangleAuth(height: 220, loadingRectangle: 3, connectedVisible: false, serviceNoAuthVisible: false,),
            )
          ],
        ));
  }
}