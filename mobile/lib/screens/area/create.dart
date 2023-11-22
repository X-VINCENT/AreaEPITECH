import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:src/components/other/route_title.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:src/components/button/return_button.dart';
import 'package:src/requests/network_services.dart';
import 'package:src/components/field/create_page_field.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:src/requests/create_area_controller.dart';

class CreatePage extends ConsumerStatefulWidget {
  @override
  _CreatePage createState() => _CreatePage();
}

class _CreatePage extends ConsumerState<CreatePage>
    with SingleTickerProviderStateMixin {
  NetworkServices services = NetworkServices();
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final servicesProvider = ref.watch(serviceProvider);
    Future<List<Map<String, dynamic>>> fetchData() async {
      final actionsResponse = await services.get(path: '/api/actions');
      final serviceResponse = await services.get(path: '/api/services');
      final reactionResponse = await services.get(path: '/api/reactions');
      if (actionsResponse != null &&
          reactionResponse != null &&
          serviceResponse != null) {
        final actionsData = actionsResponse['data'] as List<dynamic>;
        final reactionsData = reactionResponse['data'] as List<dynamic>;
        final serviceData = serviceResponse['data'] as List<dynamic>;
        final actionsList = actionsData.toList().cast<Map<String, dynamic>>();
        final serviceList = serviceData.toList().cast<Map<String, dynamic>>();
        final reactionsList =
            reactionsData.toList().cast<Map<String, dynamic>>();
        servicesProvider?.setActions(actionsList);
        servicesProvider?.setServices(serviceList);
        servicesProvider?.setReactions(reactionsList);
        return actionsList;
      } else {
        throw Exception('Impossible de récupérer les données.');
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80, left: 30),
            child: Row(
              children: [
                routeTitle(
                    title: translate('new_area'), context: context, size: 40),
                Padding(
                    padding: const EdgeInsets.only(left: 120, top: 10),
                    child: ReturnButtonArea()),
              ],
            ),
          ),
          if (servicesProvider?.getActions() == null ||
              servicesProvider?.getReactions() == null ||
              servicesProvider?.getServices() == null)
            FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 180),
                      child: LoadingAnimation(),
                    ));
                  } else if (snapshot.hasError) {
                    return Text('Erreur : ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SizedBox(
                            width: 340,
                            height: 600,
                            child: CreatePageField(
                            ),
                          ),
                        ));
                  } else {
                    return Container();
                  }
                })
          else
            Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: 340,
                    height: 600,
                    child: CreatePageField(
                    ),
                  ),
                ))
        ],
      ),
    );
  }
}
