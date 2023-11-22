import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:src/requests/network_services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:src/data/constants.dart';
import 'package:src/requests/create_area_controller.dart';
import 'package:src/components/button/simple_rectangle_button.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:animations/animations.dart';
import 'package:src/components/form/form_button.dart';
import 'package:src/components/other/action_display.dart';
import 'package:src/components/button/action_button_rectangle.dart';
import 'package:src/utils/config.dart';
import 'package:src/utils/encode.dart';

Widget LoadingAnimation() {
  return const SpinKitRotatingPlain(
    color: Colors.black,
    size: 150.0,
  );
}

class CreatePageField extends ConsumerStatefulWidget {
  @override
  ConsumerState<CreatePageField> createState() => _CreatePageField();
}

class _CreatePageField extends ConsumerState<CreatePageField> {
  NetworkServices networkServices = NetworkServices();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final areaProvider = ref.watch(areaCreateProvider);
    final servicesProvider = ref.watch(serviceProvider);
    if (areaProvider == null || servicesProvider == null) {
      return Container();
    }
    AreaController controller = areaProvider.getController();

    void setColorCallback(num id, Color color, bool isAction) {
      setState(() {
        controller.setColorId(id, color, isAction);
        final config =
            configActionReactionFromProvider(isAction, servicesProvider, id);
        if (isAction) {
          controller.setAction(config);
        } else {
          controller.setReaction(config);
        }
        Navigator.of(context).pop();
      });
    }

    void setLoading() {
      setState(() {
        loading = !loading;
      });
    }

    Future<dynamic> ShowServiceOptions({required bool isActions}) {
      return showModal(
        context: context,
        configuration: const FadeScaleTransitionConfiguration(
          transitionDuration: Duration(milliseconds: 500),
        ),
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ActionDisplay(
                    callback: setColorCallback,
                    isActions: isActions,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    Widget myWidget() {
      return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            FormButton(
              text: translate('name'),
              isMiniText: true,
              width: 340,
              controller: controller.getController(ControllerAreaState.name),
              isFailure: false,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: FormButton(
                width: 340,
                miniText: "${translate('description')} (Optionnal)",
                isMiniText: true,
                text: translate('description'),
                controller:
                    controller.getController(ControllerAreaState.description),
                isFailure: false,
              ),
            ),
            Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                  translate('active'),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    fontFamily: "Inter",
                  ),
                ),
                )
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Transform.scale(
                        scale: 0.85,
                        child: CupertinoSwitch(
                          value: controller.getController(
                              ControllerAreaState.active) as bool,
                          activeColor: Colors.black,
                          onChanged: (bool? value) {
                            setState(() => controller.setSwitch());
                          },
                        )))
              ]),
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: FormButton(
                width: 340,
                isDelay: true,
                isMiniText: true,
                miniText: "${translate('refresh_delay')} (seconds)",
                text: translate('refresh_delay'),
                controller: controller.getController(ControllerAreaState.delay),
                isFailure: false,
              ),
            ),
            if (controller.getActionId() == 0)
              Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SimpleRectangleButton(
                    text: translate('create_an_action'),
                    callback: () async {
                      ShowServiceOptions(
                        isActions: true,
                      );
                    },
                  )),
            if (controller.getActionId() > 0)
              Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: ActionButtonRectangle(
                    color: controller.getActionColor(),
                    id: controller.getActionId(),
                    controller: controller.getAction(),
                    typeList: servicesProvider.getActionTypes(),
                    callback: () {
                      ShowServiceOptions(
                        isActions: true,
                      );
                    },
                  )),
            if (controller.getReactionId() == 0)
              Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SimpleRectangleButton(
                    text: translate('create_a_reaction'),
                    callback: () async {
                      ShowServiceOptions(
                        isActions: false,
                      );
                    },
                  )),
            if (controller.getReactionId() > 0)
              Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: ActionButtonRectangle(
                    color: controller.getReactionColor(),
                    id: controller.getReactionId(),
                    isActions: false,
                    typeList: servicesProvider.getReactionTypes(),
                    controller: controller.getReaction(),
                    callback: () {
                      ShowServiceOptions(
                        isActions: false,
                      );
                    },
                  )),
            Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        setLoading();
                        final body = formatAction(
                            controller
                                .getController(ControllerAreaState.name)
                                .text,
                            controller
                                .getController(ControllerAreaState.description)
                                .text,
                            controller.getController(ControllerAreaState.active)
                                as bool,
                            controller.getActionId(),
                            controller.getReactionId(),
                            controller
                                .getController(ControllerAreaState.delay)
                                .text,
                            controller.getAction(),
                            controller.getReaction());
                        final response;
                        if (controller.getAreaId() == 0) {
                          response = await networkServices.post(
                              path: '/api/areas', body: body);
                        } else {
                          response = await networkServices.put(
                              path: '/api/areas/${controller.getAreaId()}',
                              body: body);
                        }
                        if (response['success'] == true) {
                          ref.read(navbarProvider).onItemTapped(1);
                          ref
                              .read(areaStatePageProvider)
                              .setPage(AreaStatePage.home);
                          areaProvider.resetProvider();
                        } else {
                          print(response);
                        }
                        setLoading();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            translate('create'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: "Inter",
                            ),
                          )),
                    )))
          ]));
    }

    if (loading == false) {
      return myWidget();
    }
    return LoadingAnimation();
  }
}
