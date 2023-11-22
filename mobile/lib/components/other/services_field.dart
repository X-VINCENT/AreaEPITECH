import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:src/components/other/rectangle.dart';
import 'package:src/requests/network_services.dart';
import 'package:src/components/other/square.dart';

class ServiceField extends StatefulWidget {
  @override
  State<ServiceField> createState() => _ServiceFieldState();
}

class _ServiceFieldState extends State<ServiceField> {
  NetworkServices networkServices = NetworkServices();

  Future<Map<String, dynamic>?> fetchData() async {
    final response = await networkServices.get(path: "/api/services");
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('Aucune donnée disponible');
        } else {
          final data = snapshot.data!;
          final serviceName = data['service_name'];
          return InfoSquare(path: data['data'][0]['logo_url']);
        }
      },
    );
  }
}
