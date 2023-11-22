import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:src/data/local_storage/secure_storage.dart';
import 'package:src/requests/network_services.dart';

class SpinLoading extends ConsumerStatefulWidget {

  @override
  _SpinLoading createState() => _SpinLoading();
}

class _SpinLoading extends ConsumerState<SpinLoading> {
  NetworkServices services = NetworkServices();
  int time = 0;

  Widget loadingAnimation() {
    return SpinKitPouringHourGlass(
      color: Colors.black,
      size: 150.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final servicesProvider = ref.watch(serviceProvider);
    LocalSecureStorage storage = LocalSecureStorage();

    Future<List<Map<String, dynamic>>> fetchData() async {
      final servicesResponse = await services.get(path: '/api/services');
      final reactionsResponse = await services.get(path: '/api/reactions');
      final actionsResponse = await services.get(path: '/api/actions');

      if (servicesResponse != null &&
          actionsResponse != null &&
          reactionsResponse != null) {
        final actionsData = actionsResponse['data'] as List<dynamic>;
        final reactionsData = reactionsResponse['data'] as List<dynamic>;
        final actionsList = actionsData.toList().cast<Map<String, dynamic>>();
        final reactionsList =
            reactionsData.toList().cast<Map<String, dynamic>>();
        servicesProvider?.setActions(actionsList);
        servicesProvider?.setReactions(reactionsList);
        final data = servicesResponse['data'] as List<dynamic>;
        final serviceList = data.toList().cast<Map<String, dynamic>>();
        servicesProvider?.setServices(serviceList);
        final userMap = await storage.readMap('user');
        auth?.setUser(userMap!);
        Navigator.pushNamed(context, '/home');
        return serviceList;
      } else {
        throw Exception('Data is not available');
      }
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: const Color.fromRGBO(241, 241, 241, 1),
              body: Column(
                children: [
              const Padding(
              padding: EdgeInsets.only(top: 140, left: 5),
                child: Image(
                  image: AssetImage('assets/images/bloblo-welcome-logo.png'),
                      width: 300,
                      height: 100,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 140),
                    child: loadingAnimation(),
                  ),
                ]));
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return Scaffold(
              backgroundColor: const Color.fromRGBO(241, 241, 241, 1),
              body: Column(
                children: [
              const Padding(
              padding: EdgeInsets.only(top: 140, left: 5),
                child: Image(
                  image: AssetImage('assets/images/bloblo-welcome-logo.png'),
                      width: 300,
                      height: 100,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 140),
                    child: loadingAnimation(),
                  ),
                ]));
          } else {
            return const Text('Aucune donnée disponible.');
          }
        });
  }
}
