import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:src/components/other/rectangle.dart';
import 'package:src/components/other/route_title.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:src/requests/network_services.dart';

class LogField extends StatefulWidget {
  @override
  _LogField createState() => _LogField();
  static _LogField of(BuildContext context) {
    final _LogField? app = context.findAncestorStateOfType<_LogField>();
    if (app == null) {
      throw FlutterError('AvailableAreas widget not found in the widget tree');
    }
    return app;
  }
}

class _LogField extends State<LogField> with SingleTickerProviderStateMixin {
  NetworkServices services = NetworkServices();
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    controller.repeat();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await services.get(path: 'api/areas/logs');
    if (response != null) {
      final data = response['data'] as List<dynamic>;
      final logList = data.toList().cast<Map<String, dynamic>>();
      for (final log in logList) {
        final areaResponse = await services.get(path: 'api/areas/${log['area_id']}');
        log['name'] = areaResponse?['data']['name'];
      }
      return logList;
    } else {
      throw Exception('Data is not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitCubeGrid(
            color: Colors.black,
            controller: controller,
            size: 150,
          )
          );
        } else if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final logList = snapshot.data!;
          return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  for (var log in logList)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: LogRectangle(
                          id: log['id'].toString(),
                          area: log['area_id'].toString(),
                          message: log['name'] ?? "",
                          status: log['status'] == "success",
                          date: log['created_at']
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

class Log extends ConsumerStatefulWidget {
  @override
  ConsumerState<Log> createState() => _Log();
}

class _Log extends ConsumerState<Log> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(top: 80, left: 30),
          child: routeTitle(title: translate('log'), context: context),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: double.infinity,
                height: 570,
              child: LogField(),
              )
            )
      ]),
    );
  }
}
