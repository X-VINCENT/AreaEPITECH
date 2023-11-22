import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:src/utils/create_templates.dart';
import 'package:src/utils/random.dart';
import 'package:src/utils/config.dart';
import 'package:src/components/other/square.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:src/requests/create_area_controller.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:src/data/constants.dart';

class TemplatesRow extends ConsumerStatefulWidget {
  @override
  _TemplatesRowState createState() => _TemplatesRowState();
}

class _TemplatesRowState extends ConsumerState<TemplatesRow> {
  @override
  Widget build(BuildContext context) {
    final services = ref.watch(serviceProvider);
    final auth = ref.watch(authProvider);
    if (services == null || auth == null) {
      return Container();
    }

    List<Map<String, dynamic>>? activeTemplates = services.getTemplates();

    if (activeTemplates == null) {
      fillTemplates(auth, services);
      activeTemplates = services.getTemplates();
    }

    void fillController(
        AreaController controller, Map<String, dynamic> actions) {
      controller.setActionId(actions['action_id']);
      controller.setReactionId(actions['reaction_id']);
      TextEditingController name =
          controller.getController(ControllerAreaState.name);
      name.text = actions['name'];
      final actionConfig = configActionReactionFromProvider(
          true, services, actions['action_id']);
      final reactionConfig = configActionReactionFromProvider(
          false, services, actions['reaction_id']);
      controller.setAction(actionConfig);
      controller.setReaction(reactionConfig);
    }

    if (activeTemplates == null) {
      return Container();
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (activeTemplates.isNotEmpty)
        Padding(
            padding: const EdgeInsets.only(top: 0, left: 10),
            child: Text(translate('start_with_customs'),
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontFamily: "Rockwell",
                  fontSize: 20,
                ))),
      Padding(
          padding: const EdgeInsets.only(top: 15),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var service in activeTemplates!)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          AreaSquare(
                              width: 130,
                              height: 130,
                              fontSize: 13,
                              logoHeight: 30,
                              heightBox: 30,
                              title: service['name'],
                              areaService: service,
                              callback: fillController,
                              color: randomElement(pastelColors)),
                        ],
                      ),
                    ),
                ],
              )))
    ]);
  }
}
