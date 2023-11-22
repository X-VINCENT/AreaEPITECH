import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:src/data/local_storage/secure_storage.dart';
import 'dart:convert';
import 'package:enhanced_http/enhanced_http.dart' as http;
import 'package:pkce/pkce.dart';

void gitlabAuth({required VoidCallback callback}) async {
  LocalSecureStorage storage = LocalSecureStorage();
  final Uri tokenUrl = Uri.parse('https://gitlab.com/oauth/token');
  final String? gitlabClientId = dotenv.env['GITLAB_CLIENT_ID'];
  final String? gitlabClientSecret = dotenv.env['GITLAB_CLIENT_SECRET'];
  final String gitlabScheme = dotenv.env['GITLAB_SCHEME'] ?? "com.mycomp.myapp";

  final List<String> scopes = [
    'read_repository',
    'read_user',
    'api',
    'write_repository',
    'profile',
    'email',
  ];

  final pkcePair = PkcePair.generate();

  final url = Uri.https('gitlab.com', '/oauth/authorize', {
    'client_id': gitlabClientId,
    'response_type': 'code',
    'redirect_uri': "$gitlabScheme://oauth2redirect",
    'scope': scopes.join(' '),
    'code_challenge': pkcePair.codeChallenge,
    'code_challenge_method': 'S256',
  });

  final result = await FlutterWebAuth2.authenticate(
    url: url.toString(),
    callbackUrlScheme: gitlabScheme,
  );

  final code = Uri.parse(result).queryParameters['code'];

  final response = await http.post(tokenUrl, body: {
    'client_id': gitlabClientId,
    'client_secret': gitlabClientSecret,
    'code': code,
    'grant_type': 'authorization_code',
    'redirect_uri': "$gitlabScheme://oauth2redirect",
    'code_verifier': pkcePair.codeVerifier,
  });

  final String accessToken = jsonDecode(response.body)['access_token'];

  if (accessToken.isEmpty) {
    return;
  }

  Uri customUrl = Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8000,
      path: '/api/auth/gitlab/callback'
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
