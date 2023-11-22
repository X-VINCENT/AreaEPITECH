import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:src/components/auth/rectangle_account.dart';
import 'package:src/data/provider/user_provider.dart';
import 'package:src/requests/network_services.dart';
import 'package:src/data/constants.dart';
import 'package:src/components/animation/shimmer.dart';
import 'package:src/data/local_storage/secure_storage.dart';

class ColumnRectangleAuth extends ConsumerStatefulWidget {
  double? height;
  bool? connectedVisible;
  bool? serviceNoAuthVisible;
  num? loadingRectangle;

  ColumnRectangleAuth(
      {this.height,
      this.connectedVisible,
      this.serviceNoAuthVisible = true,
      this.loadingRectangle = 2});

  @override
  _ColumnRectangleAuthState createState() => _ColumnRectangleAuthState();

  static _ColumnRectangleAuthState of(BuildContext context) {
    final _ColumnRectangleAuthState? app =
        context.findAncestorStateOfType<_ColumnRectangleAuthState>();
    if (app == null) {
      throw FlutterError('App widget not found in the widget tree');
    }
    return app;
  }
}

class _ColumnRectangleAuthState extends ConsumerState<ColumnRectangleAuth> {
  NetworkServices services = NetworkServices();
  LocalSecureStorage storage = LocalSecureStorage();
  Map<String, dynamic>? userMap;
  Map<String, dynamic>? serviceMap;

  void reload() {
    final servicesProvider = ref.watch(serviceProvider);
    setState(() {
      servicesProvider?.deleteService();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final servicesProvider = ref.watch(serviceProvider);
    final activeServicesProvider = servicesProvider?.getServices();

    Future<List<Map<String, dynamic>>> fetchData() async {
      final response = await services.get(path: '/api/services');
      if (response != null) {
        final data = response['data'] as List<dynamic>;
        final serviceList = data.toList().cast<Map<String, dynamic>>();
        userMap = auth?.getUser();
        return serviceList;
      } else {
        throw Exception('Data is not available');
      }
    }

    ConnectedTextState getConnectedState(
        {required bool isAuth, required String serviceName}) {
      if (userMap == null) {
        return ConnectedTextState.noAuth;
      }
      if (isAuth == false) {
        return ConnectedTextState.noAuth;
      }
      if (userMap?["${serviceName}_id"] == null ||
          userMap?["${serviceName}_id"] == null) {
        return ConnectedTextState.disconnected;
      }
      return ConnectedTextState.connected;
    }

    Widget myWidget({required List<Map<String, dynamic>> activeServices}) {
      return SizedBox(
          height: widget.height ?? 150,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  for (var service in activeServices)
                    if (widget.serviceNoAuthVisible == true ||
                        service['is_oauth'] == true)
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: RectangleAuthAccount(
                              url: service['url'] ?? "",
                              imagePath: service['logo_url'],
                              title: service['key'],
                              connectedTextState: getConnectedState(
                                  isAuth: service['is_oauth'],
                                  serviceName: service['key'])))
                ],
              )));
    }

    if (activeServicesProvider == null) {
      return FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                  height: widget.height ?? 150,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          for (var i = 0; i < widget.loadingRectangle!; i++)
                            const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: ShimmerLoading(
                                  width: 340,
                                  height: 60,
                                  borderRadius: 0,
                                ))
                        ],
                      )));
            } else if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final activeServices = snapshot.data!;
              servicesProvider?.setServices(activeServices);
              return myWidget(activeServices: activeServices);
            } else {
              return Container();
            }
          });
    } else {
      userMap = auth?.getUser();
      return myWidget(activeServices: activeServicesProvider);
    }
  }
}
