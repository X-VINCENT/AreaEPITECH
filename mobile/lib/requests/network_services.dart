import 'package:enhanced_http/enhanced_http.dart' as http;
import 'package:flutter/material.dart';
import 'package:src/data/local_storage/secure_storage.dart';
import 'package:src/requests/login_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:src/requests/network_services.dart';
import 'dart:convert';

class NetworkServices {
  final String backendIp = dotenv.env['BACKEND_IP'] ?? "localhost";
  final int backendPort = int.parse(dotenv.env['BACKEND_PORT'] ?? "8000");

  Future<Map<String, dynamic>?> get({
    required String path,
  }) async {
    LocalSecureStorage storage = LocalSecureStorage();
    try {
      Uri customUrl =
          Uri(scheme: 'http', host: backendIp, port: backendPort, path: path);

      final token = await storage.read('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http.get(customUrl, headers: headers);
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return jsonResponse;
      }
    } on Exception catch (e) {
      print(e);
      return null;
    }

    return null;
  }

  Future<Map<String, dynamic>?> delete({
    required String path,
  }) async {
    LocalSecureStorage storage = LocalSecureStorage();
    try {
      Uri customUrl =
          Uri(scheme: 'http', host: backendIp, port: backendPort, path: path);

      final token = await storage.read('token');

      Map<String, String> headers = {
        "Authorization": "Bearer $token",
        "Accept": "application/json"
      };

      final response = await http.delete(customUrl, headers: headers);
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return jsonResponse;
      }
    } on Exception catch (e) {
      print(e);
      return null;
    }

    return null;
  }

  Future<String?> postLogin({
    required String path,
    required Map<String, String> body,
    required VoidCallback callback,
    required LoginController controller,
    required VoidCallback myCall,
  }) async {
    LocalSecureStorage storage = LocalSecureStorage();

    Uri customUrl =
        Uri(scheme: 'http', host: backendIp, port: backendPort, path: path);

    try {
      final response = await http.post(customUrl, body: body);
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final String token = jsonResponse['data']['token'];
        final Map<String, dynamic> user = jsonResponse['data']['user'];

        await storage.write('token', token);
        await storage.storeMap(user, 'user');
        callback();
      } else {
        parseResponseLogin(jsonResponse, controller);
        myCall();
      }
    } on Exception catch (e) {
      print(e);
    }

    return null;
  }

  Future<Map<String, dynamic>?> post({
    required String path,
    Map<String, dynamic>? body,
  }) async {
    LocalSecureStorage storage = LocalSecureStorage();
    try {
      Uri customUrl =
          Uri(scheme: 'http', host: backendIp, port: backendPort, path: path);
      final token = await storage.read('token');
      Map<String, String> headers = {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        'Content-Type': 'application/json',
      };

      final response =
          await http.post(customUrl, headers: headers, body: jsonEncode(body));
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      return jsonResponse;
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> put({
    required String path,
    Map<String, dynamic>? body,
  }) async {
    LocalSecureStorage storage = LocalSecureStorage();
    try {
      Uri customUrl =
          Uri(scheme: 'http', host: backendIp, port: backendPort, path: path);
      final token = await storage.read('token');
      Map<String, String> headers = {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        'Content-Type': 'application/json',
      };

      final response =
          await http.put(customUrl, headers: headers, body: jsonEncode(body));
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      return jsonResponse;
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }
}
