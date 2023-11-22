import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:src/components/animation/spin_loading_register.dart';
import 'package:page_transition/page_transition.dart';
import 'package:src/components/animation/shimmer.dart';
import 'package:src/requests/network_services.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:src/requests/auth/parse.dart';
import 'package:src/utils/is_svg.dart';

class CircleOnTouch extends StatelessWidget {
  final String imagePath;
  final String serviceName;

  const CircleOnTouch(
      {Key? key, required this.imagePath, required this.serviceName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: TouchableOpacity(
            activeOpacity: 0.4,
            onTap: () {
              authProcessParsing(
                  key: serviceName,
                  callback: () => {
                        Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: SpinLoading(),
                                  ),
                                )
                      });
            },
            child: createImageNetwork(url: imagePath)));
  }
}

Widget orText() {
  return Text(
    translate('or'),
    style: const TextStyle(
      fontFamily: "Inter",
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: Colors.black,
    ),
  );
}

class RoundedAuth extends ConsumerStatefulWidget {
  const RoundedAuth({super.key});

  @override
  ConsumerState<RoundedAuth> createState() => _RoundedAuthState();
}

class _RoundedAuthState extends ConsumerState<RoundedAuth>
    with SingleTickerProviderStateMixin {
  NetworkServices services = NetworkServices();

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await services.get(path: '/api/services');
    if (response != null) {
      final data = response['data'] as List<dynamic>;
      final serviceList = data.toList().cast<Map<String, dynamic>>();
      return serviceList;
    } else {
      throw Exception('Impossible de récupérer les données.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(children: [
              orText(),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var i = 0; i < 5; i++)
                        const Padding(
                            padding:
                                EdgeInsets.only(top: 20, left: 5, right: 5),
                            child: ShimmerLoading(
                              width: 40,
                              height: 40,
                              borderRadius: 100,
                            ))
                    ],
                  ))
            ]);
          } else if (snapshot.hasError) {
            return Text('Erreur : ${snapshot.error}');
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final activeServices = snapshot.data!;
            return Column(children: [
              orText(),
              Row(
                children: [
                  for (var service in activeServices)
                    if (service['is_oauth'] == true)
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 5, right: 5),
                        child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircleOnTouch(
                                serviceName: service['key'],
                                imagePath: service['logo_url'])),
                      ),
                ],
              )
            ]);
          } else {
            return Container();
          }
        });
  }
}
