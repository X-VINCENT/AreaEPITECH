import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:src/components/form/form_button.dart';
import 'package:src/utils/is_svg.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:src/utils/search.dart';
import 'package:src/data/provider/user_provider.dart';

class ActionButtonRectangle extends ConsumerWidget {
  final num id;
  VoidCallback callback;
  bool isActions;
  List<Map<String, TextEditingController>> configList = [];
  Map<String, TextEditingController> controller;
  List<bool> typeList;
  TextEditingController test = TextEditingController();
  Color color;
  ActionButtonRectangle(
      {Key? key,
      required this.id,
      required this.typeList,
      required this.controller,
      required this.color,
      required this.callback,
      this.isActions = true})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesProvider = ref.watch(serviceProvider);
    final areaProvider = ref.watch(areaCreateProvider);

    List<Map<String, dynamic>>? dataList;
    Map<String, dynamic> data = {};
    if (isActions == true) {
      dataList = servicesProvider?.getActions();
    } else {
      dataList = servicesProvider?.getReactions();
    }
    final serviceList = servicesProvider?.getServices();

    for (var i = 0; i < dataList!.length; i++) {
      if (dataList[i]['id'] == id) {
        data = dataList[i];
      }
    }

    final logoUrl =
        findElementToService(dataList, serviceList ?? [], id, 'logo_url');
    List<Map<String, dynamic>> configList =
        List<Map<String, dynamic>>.from(data['config_keys'] ?? []);

    return TouchableOpacity(
      activeOpacity: 0.8,
      onTap: callback,
      child: Container(
          width: 340,
          constraints: const BoxConstraints(minHeight: 50),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 5, left: 20),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: createImageNetwork(url: logoUrl!),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 5, left: 20),
                      child: SizedBox(
                          width: 240,
                          child: Text(
                            data['name'],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontFamily: "Inter",
                            ),
                          ))),
                ],
              ),
              for (var i = 0; i < configList.length; i++)
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 5),
                  child: FormButton(
                    width: 300,
                    isMiniText: true,
                    isNbr: typeList[i],
                    text: configList[i]['id'],
                    isDate: configList[i]['id'] == "start" || configList[i]['id'] == "end",
                    controller: controller[configList[i]['id']]!,
                    isFailure: false,
                  ),
                ),
            ],
          )),
    );
  }
}