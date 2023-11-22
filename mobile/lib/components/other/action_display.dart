import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:src/utils/is_svg.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:src/utils/search.dart';
import 'package:src/data/constants.dart';
import 'package:src/data/provider/user_provider.dart';

class RectangleAction extends StatelessWidget {
  String title;
  String description;
  Color color;
  num id;
  bool isLocked;
  Function(num id, Color color, bool isAction) callback;
  bool isAction;

  RectangleAction(
      {Key? key,
      required this.title,
      required this.description,
      required this.color,
      required this.id,
      required this.callback,
      required this.isLocked,
      required this.isAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget myWidget() {
      return Container(
          width: 340,
          constraints: const BoxConstraints(minHeight: 30),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(25),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: SizedBox(
                child: Text(title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                child: Text(description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                    )),
              ),
            )
          ]));
    }

    return isLocked
        ? TouchableOpacity(
            onTap: () => {callback(id, color, isAction)},
            child: myWidget(),
          )
        : Container(
            child: Container(
            width: 340,
            height: 80,
          constraints: const BoxConstraints(minHeight: 30),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(25),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset('assets/images/lock.svg',
                color: Colors.black38,
                ),
                    )),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: SizedBox(
                child: Text(translate('not_connected'),
                    style: const TextStyle(
                      fontSize: 10,
                      fontFamily: "Inter",
                      color: Colors.black38,
                    )),
              ),
            )
          ])
            )

          );
  }
}

class LogoContainer extends ConsumerWidget {
  String logoUrl;
  String name;
  String serviceName;
  int serviceId;
  bool isAction;
  Function(num id, Color color, bool isAction) callback;
  List<Map<String, dynamic>> dataList;

  LogoContainer(
      {Key? key,
      required this.logoUrl,
      required this.serviceName,
      required this.name,
      required this.serviceId,
      required this.isAction,
      required this.callback,
      required this.dataList})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final servicesProvider = ref.watch(serviceProvider);
    final userMap = auth?.getUser();
    final service = servicesProvider?.getServices();

    bool isAuthService({required String key}) {
      for (var i = 0; i < service!.length; i++) {
        if (service[i]['key'] == key && service[i]['is_oauth'] == true) {
          return true;
        }
      }
      return false;
    }

    int indexColor = 0;
    List<Map<String, dynamic>> filterById(
        List<Map<String, dynamic>> dataList, int id) {
      return dataList.where((item) => item['service_id'] == id).toList();
    }

    int incrementeIndexColor({required int indexColor}) {
      if (pastelColors.length == indexColor) {
        indexColor = 0;
      } else {
        indexColor++;
      }
      return indexColor;
    }

    bool isLocked() {
      if (userMap == null ||
          userMap['${serviceName}_id'] == null &&
              userMap.containsKey('${serviceName}_id') ||
          userMap.containsKey('${serviceName}_id') == false &&
          isAuthService(key: serviceName)
          ) {
        return false;
      }
      return true;
    }

    List<Map<String, dynamic>> newData = filterById(dataList, serviceId);
    return Column(children: [
      Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: SizedBox(
              width: 20,
              height: 20,
              child: createImageNetwork(url: logoUrl),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: SizedBox(
              child: Text(name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ),
        ],
      )),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0;
              i < newData.length;
              i++, indexColor = incrementeIndexColor(indexColor: indexColor))
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 15),
              child: RectangleAction(
                  title: newData[i]['name'],
                  description: newData[i]['description'],
                  isAction: isAction,
                  isLocked: isLocked(),
                  callback: callback,
                  id: newData[i]['id'],
                  color: isLocked()
                      ? pastelColorsActions[indexColor]
                      : Colors.black12),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Container(),
          ),
        ],
      )
    ]);
  }
}

class ActionDisplay extends ConsumerWidget {
  final Function(num id, Color color, bool isAction) callback;
  bool isActions;

  ActionDisplay({Key? key, required this.callback, this.isActions = true})
      : super(key: key);

  Widget build(BuildContext context, WidgetRef ref) {
    final servicesProvider = ref.watch(serviceProvider);
    List<Map<String, dynamic>>? dataList;
    Map<String, dynamic> data = {};
    if (isActions == true) {
      dataList = servicesProvider?.getActions();
    } else {
      dataList = servicesProvider?.getReactions();
    }
    if (dataList == null) return Container();

    final serviceList = servicesProvider?.getServices();

    dataList.sort((a, b) {
      final int serviceIdA = a['service_id'];
      final int serviceIdB = b['service_id'];
      return serviceIdA.compareTo(serviceIdB);
    });

    List<Map<String, dynamic>> logoList =
        extractUniqueServiceInfo(dataList, serviceList!);

    return Column(children: [
      for (int i = 0; i < logoList.length; i++,)
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: LogoContainer(
              logoUrl: logoList[i]['logo_url'],
              name: logoList[i]['name'],
              serviceName: logoList[i]['key'],
              isAction: isActions,
              serviceId: logoList[i]['service_id'],
              callback: callback,
              dataList: dataList),
        ),
    ]);
  }
}
