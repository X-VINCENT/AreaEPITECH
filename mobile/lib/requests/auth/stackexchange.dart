import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:src/data/local_storage/secure_storage.dart';
import 'dart:convert';
import 'package:enhanced_http/enhanced_http.dart' as http;

void stackexchangeAuth({required VoidCallback callback}) async {
  LocalSecureStorage storage = LocalSecureStorage();
  final Uri tokenUrl = Uri.parse('https://stackoverflow.com/oauth/access_token');
  final String? stackexchangeClientId = dotenv.env['STACKEXCHANGE_CLIENT_ID'];
  final String? stackexchangeClientSecret = dotenv.env['STACKEXCHANGE_CLIENT_SECRET'];
  final String stackexchangeScheme = dotenv.env['STACKEXCHANGE_SCHEME'] ?? "com.mycomp.myapp";

  final List<String> scopes = [
    'read_inbox',
    'no_expiry',
    'write_access',
    'private_info',
  ];

  const String state = '23456';

  final url = Uri.https('stackoverflow.com', '/oauth/dialog', {
    'client_id': stackexchangeClientId,
    'redirect_uri': "$stackexchangeScheme://oauth2redirect",
    'scope': scopes.join(' '),
    'state': state,
  });

  final result = await FlutterWebAuth2.authenticate(
    url: url.toString(),
    callbackUrlScheme: stackexchangeScheme,
  );

  final code = Uri.parse(result).queryParameters['code'];
  final stateResult = Uri.parse(result).queryParameters['state'];

  if (stateResult != state || code == null) {
    return;
  }

  final response = await http.post(tokenUrl, body: {
    'client_id': stackexchangeClientId,
    'client_secret': stackexchangeClientSecret,
    'code': code,
    'redirect_uri': "$stackexchangeScheme://oauth2redirect",
  });

  if (response.statusCode != 200) {
    return;
  }

  final String accessToken = Uri.parse("?${response.body}").queryParameters['access_token'] ?? "";

  if (accessToken.isEmpty) {
    return;
  }

  Uri customUrl = Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8000,
      path: '/api/auth/stackexchange/callback'
  ).replace(
      queryParameters: {
        'token': accessToken,
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
