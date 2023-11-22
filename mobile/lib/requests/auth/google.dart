import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:src/requests/network_services.dart';
import 'dart:convert';
import 'package:enhanced_http/enhanced_http.dart' as http;
import 'package:src/data/local_storage/secure_storage.dart';

void googleAuth({required VoidCallback callback}) async {
  LocalSecureStorage storage = LocalSecureStorage();
  final Uri tokenUrl = Uri.parse('https://www.googleapis.com/oauth2/v4/token');
  final String? googleClientId = dotenv.env['GOOGLE_CLIENT_ID'];
  final String? callbackUrlScheme = dotenv.env['GOOGLE_SCHEME'];

  final List<String> scopes = [
    'email',
    'profile',
    'https://mail.google.com',
    'openid',
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://www.googleapis.com/auth/calendar',
    'https://www.googleapis.com/auth/docs',
    'https://www.googleapis.com/auth/drive'
  ];

  final url = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
    'response_type': 'code',
    'client_id': googleClientId,
    'redirect_uri': '$callbackUrlScheme:/',
    'scope': scopes.join(' '),
    'access_type': 'offline',
    'prompt': 'consent'
  });

  final result = await FlutterWebAuth2.authenticate(
    url: url.toString(),
    callbackUrlScheme: callbackUrlScheme!
  );

  final code = Uri.parse(result).queryParameters['code'];

  final response = await http.post(tokenUrl, body: {
    'client_id': googleClientId,
    'redirect_uri': '$callbackUrlScheme:/',
    'grant_type': 'authorization_code',
    'code': code,
  });

  final accessToken = jsonDecode(response.body)['access_token'];

  Uri customUrl = Uri(
    scheme: 'http',
    host: 'localhost',
    port: 8000,
    path: '/api/auth/google/callback'
  ).replace(
    queryParameters: {
      'token': accessToken!,
    }
  );

  customUrl = Uri.parse(
    customUrl
      .toString()
      .replaceAll('%2F', '/')
      .replaceAll('%3A', ':')
      .replaceAll('+', '%20')
  );

  final token = await storage.read('token');

  final res = await http.get(customUrl, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  });

  if (res.statusCode == 200) {
    final data = jsonDecode(res.body)['data'];

    await storage.write('token', data['token']);
    await storage.storeMap(data['user'], 'user');
    callback();
  } else {
    print(res.body);
  }
}
