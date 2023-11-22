import 'package:flutter/material.dart';
import 'package:src/requests/create_area_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:src/utils/encode.dart';
import 'package:src/requests/network_services.dart';
import 'package:src/components/other/square.dart';
import 'package:src/utils/random.dart';
import 'package:src/data/constants.dart';
import 'package:src/components/animation/shimmer.dart';

class AvailableAreas extends ConsumerStatefulWidget {
  @override
  _AvailableAreas createState() => _AvailableAreas();

  static _AvailableAreas of(BuildContext context) {
    final _AvailableAreas? app = context.findAncestorStateOfType<_AvailableAreas>();
    if (app == null) {
      throw FlutterError('AvailableAreas widget not found in the widget tree');
    }
    return app;
  }
}

class _AvailableAreas extends ConsumerState<AvailableAreas> {
  NetworkServices services = NetworkServices();

  void reload() {
    setState(() {});
  }

  Future<List<dynamic>> fetchDataLogo({required List<int> id}) async {
    List<dynamic> idReActions = [];
    List<dynamic> serviceLogo = [];
    Map<String, dynamic>? response =
        await services.get(path: '/api/actions/${id[0]}');
    idReActions.add(response?['data']['service_id']);
    response = await services.get(path: '/api/reactions/${id[1]}');
    idReActions.add(response?['data']['service_id']);
    response = await services.get(path: '/api/services/${idReActions[0]}');
    serviceLogo.add(response?['data']['logo_url']);
    response = await services.get(path: '/api/services/${idReActions[1]}');
    serviceLogo.add(response?['data']['logo_url']);
    return serviceLogo;
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await services.get(path: '/api/areas');
    if (response != null) {
      final data = response['data'] as List<dynamic>;
      final activeServices = data
          .where((item) => item['active'] == true)
          .toList()
          .cast<Map<String, dynamic>>();
      for (var service in activeServices) {
        List<int> id = [service['action_id'], service['reaction_id']];
        List<dynamic> serviceLogo = await fetchDataLogo(id: id);
        service['action_logo'] = serviceLogo[0];
        service['reaction_logo'] = serviceLogo[1];
      }
      return activeServices;
    } else {
      throw Exception('Data not available');
    }
  }

    void fillController(AreaController controller, Map<String, dynamic> areaService) {
      final nameController = controller.getController(ControllerAreaState.name);
      final delayController = controller.getController(ControllerAreaState.delay);
      final descriptionController = controller.getController(ControllerAreaState.description);
      nameController.text = areaService['name'];
      delayController.text = areaService['refresh_delay'].toString();
      descriptionController.text = areaService['description'] ?? "";
      controller.setActionId(areaService['action_id']);
      controller.setReactionId(areaService['reaction_id']);
      if (areaService['id'] != '') {
        controller.setAreaId(areaService['id']);
      }
      controller.setAction(convertMapToTextControllers(areaService['action_config']));
      controller.setReaction(convertMapToTextControllers(areaService['reaction_config']));
    }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for(var i = 0; i < 2; i++)
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: ShimmerLoading(width: 200, height: 200, borderRadius: 16,)
                )
            ],
          )
          );
        } else if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final activeServices = snapshot.data!;
          return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var service in activeServices)
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          AreaSquare(
                              title: service['name'],
                              areaService: service,
                              callback: fillController,
                              color: randomElement(pastelColors)),
                        ],
                      ),
                    ),
                ],
              ));
        } else {
          return Container();
        }
      },
    );
  }
}
