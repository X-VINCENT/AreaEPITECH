import 'package:flutter/material.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:src/components/field/shutdown_areas.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:src/utils/is_svg.dart';
import 'package:src/utils/random.dart';
import 'package:src/data/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:src/requests/network_services.dart';
import 'package:src/components/field/available_areas.dart';
import 'package:src/requests/create_area_controller.dart';

class AreaSquareMenu extends StatelessWidget {
  final VoidCallback cancelCallback;
  final bool topField;
  final id;

  AreaSquareMenu({Key? key, required this.cancelCallback, required this.id, this.topField = true}) : super(key: key);

  NetworkServices services = NetworkServices();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: SizedBox(
            width: 50,
            height: 50,
            child: GestureDetector(
              onTap: () => cancelCallback(),
              child: const Icon(Icons.close, color: Colors.white, size: 30),
            ),
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: TouchableOpacity(
                  activeOpacity: 0.4,
                  onTap: () => {
                    services.get(path: "/api/areas/$id/execute"),
                    cancelCallback(),
                  },
                  child: SizedBox(
                    width: 40,
                    height: 40,
                child: SvgPicture.asset('assets/images/play.svg',
                  color: Colors.green,
                ))
              )),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: TouchableOpacity(
                  activeOpacity: 0.4,
                  onTap: () => {
                    services.delete(path: "/api/areas/$id"),
                    if (topField == true) {
                      AvailableAreas.of(context).reload(),
                    } else {
                      ShutdownAreas.of(context).reload(),
                    }
                  },
                  child: SizedBox(
                    width: 40,
                    height: 40,
                child: SvgPicture.asset('assets/images/trash.svg',
                  color: Colors.red,
                ))
              )
              )
            ],
          ),
        ),
      ],
    );
  }
}
class AreaSquare extends ConsumerStatefulWidget {
  String? title;
  Color? color;
  double? width;
  double? height;
  double? logoHeight;
  double? fontSize;
  double? heightBox;
  Map<String, dynamic> areaService;
  bool topField;
  Function(AreaController controller, Map<String, dynamic> areaService) callback;

  AreaSquare(
      {Key? key,
      this.title,
      this.color,
      this.fontSize,
      this.width,
      this.heightBox,
      this.logoHeight,
      this.height,
      this.topField = true,
      required this.areaService,
      required this.callback,
      })
      : super(key: key);
  @override
  _AreaSquare createState() => _AreaSquare();
}

class _AreaSquare extends ConsumerState<AreaSquare> {
  AvailableAreaState availableAreaState = AvailableAreaState.none;

  @override
  Widget build(BuildContext context) {
    final areaProvider = ref.watch(areaCreateProvider);

    if (areaProvider == null) {
      return Container();
    }

    final controller = areaProvider.getController();

    Widget roundedLogo({required Widget child, double? width, double? height}) {
      return SizedBox(
          width: width ?? 40,
          height: height ?? 40,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100), child: child));
    }

    return TouchableOpacity(
        activeOpacity: 0.4,
        onTap: () => {
              if (availableAreaState == AvailableAreaState.none)
                {
                  widget.callback(controller, widget.areaService),
                  ref.read(navbarProvider).onItemTapped(1),
                  ref.read(areaStatePageProvider).setPage(AreaStatePage.create)
                }
            },
        onLongPress: () {
          setState(() {
            if (availableAreaState == AvailableAreaState.none) {
              availableAreaState = AvailableAreaState.menu;
            }
          });
        },
        child: Container(
            width: widget.width ?? 200,
            height: widget.height ?? 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: availableAreaState == AvailableAreaState.none
                  ? widget.color ?? randomElement(pastelColors)
                  : const Color.fromRGBO(0, 0, 0, 30),
            ),
            child: Stack(children: [
              Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: roundedLogo(
                              width: widget.logoHeight,
                              height: widget.logoHeight,
                                child: createImageNetwork(
                              url: widget.areaService['action_logo'] ?? "https://cdn.iconscout.com/icon/premium/png-512-thumb/unknown-website-578019.png?f=webp&w=512",
                              color:
                                  availableAreaState == AvailableAreaState.menu
                                      ? const Color.fromRGBO(0, 0, 0, 70)
                                      : null,
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: roundedLogo(
                              width: widget.logoHeight,
                              height: widget.logoHeight,
                              child: createImageNetwork(
                                url: widget.areaService['reaction_logo'] ?? "https://cdn.iconscout.com/icon/premium/png-512-thumb/unknown-website-578019.png?f=webp&w=512",
                                color: availableAreaState ==
                                        AvailableAreaState.menu
                                    ? const Color.fromRGBO(0, 0, 0, 70)
                                    : null,
                              ),
                            ),
                          )
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 30, left: 10),
                      child: Container(
                          width: 170,
                          padding: const EdgeInsets.only(top: 1, left: 1, right: 1, bottom: 1),
                          height: widget.heightBox ?? 85,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(
                                widget.areaService['name'],
                                style: TextStyle(
                                  fontSize: widget.fontSize ?? 20,
                                  fontFamily: "Rockwell",
                                  color: Colors.black,
                                ),
                              ))))
                ],
              ),
              if (availableAreaState == AvailableAreaState.menu)
                AreaSquareMenu(
                  cancelCallback: () {
                    setState(() {
                      availableAreaState = AvailableAreaState.none;
                    });
                  },
                  topField: widget.topField,
                  id: widget.areaService['id'],
                )
            ])));
  }
}

class InfoSquare extends StatelessWidget {
  final String path;

  InfoSquare({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromRGBO(195, 219, 255, 100),
        ),
        child: Image.network(path));
  }
}