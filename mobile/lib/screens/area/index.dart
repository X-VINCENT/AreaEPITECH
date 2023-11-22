import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:src/components/other/route_title.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:src/components/button/plus_button.dart';
import 'package:src/data/constants.dart';
import 'package:src/components/field/available_areas.dart';
import 'package:src/components/field/shutdown_areas.dart';

class Area extends ConsumerStatefulWidget {
  @override
  ConsumerState<Area> createState() => _Area();
}

class _Area extends ConsumerState<Area> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 80, left: 30),
            child: Row(children: [
              routeTitle(title: translate('area'), context: context),
              Padding(
                padding: const EdgeInsets.only(left: 180, top: 10),
                child: ButtonPlus(
                    callback: () => {
                          ref
                              .read(areaStatePageProvider)
                              .setPage(AreaStatePage.create),
                        }),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: SizedBox(
              width: double.infinity,
              height: 250,
              child: AvailableAreas(),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 30, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                routeTitle(
                    title: translate('shutdown_areas'),
                    context: context,
                    size: 32)
              ])),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: SizedBox(
              width: double.infinity,
              height: 250,
              child: ShutdownAreas(),
            ),
          ),
        ]));
  }
}
