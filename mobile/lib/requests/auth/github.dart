import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:src/requests/network_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:src/data/local_storage/secure_storage.dart';
import 'dart:convert';
import 'package:enhanced_http/enhanced_http.dart' as http;

void githubAuth({required VoidCallback callback}) async {
  LocalSecureStorage storage = LocalSecureStorage();
  NetworkServices services = NetworkServices();
  final Uri tokenUrl = Uri.parse('https://github.com/login/oauth/access_token');
  final String? githubClientId = dotenv.env['GITHUB_CLIENT_ID'];
  final String? githubClientSecret = dotenv.env['GITHUB_CLIENT_SECRET'];
  final String githubScheme = dotenv.env['GITHUB_SCHEME'] ?? "com.mycomp.myapp";

  final List<String> scopes = [
    'user:email',
    'repo',
    'read:user',
    'project',
    'notifications'
  ];

  final url = Uri.https('github.com', '/login/oauth/authorize', {
    'client_id': githubClientId,
    'response_type': 'code',
    'redirect_uri': "$githubScheme://oauth2redirect",
    'scope': scopes.join(' '),
  });

  final result = await FlutterWebAuth2.authenticate(
    url: url.toString(),
    callbackUrlScheme: githubScheme,
  );

  final code = Uri.parse(result).queryParameters['code'];

  final response = await http.post(tokenUrl, body: {
    'client_id': githubClientId,
    'client_secret': githubClientSecret,
    'code': code,
    'redirect_uri': "$githubScheme://oauth2redirect",
  });

  final String accessToken = Uri.parse("?${response.body}").queryParameters['access_token'] ?? "";

  if (accessToken.isEmpty) {
    return;
  }

  Uri customUrl = Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8000,
      path: '/api/auth/github/callback'
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
