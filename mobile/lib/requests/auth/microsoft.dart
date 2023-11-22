import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pkce/pkce.dart';
import 'package:src/data/local_storage/secure_storage.dart';
import 'dart:convert';
import 'package:enhanced_http/enhanced_http.dart' as http;

void microsoftAuth({required VoidCallback callback}) async {
  LocalSecureStorage storage = LocalSecureStorage();
  final String? microsoftClientId = dotenv.env['MICROSOFT_CLIENT_ID'];
  final String? microsoftTenantId = dotenv.env['MICROSOFT_TENANT_ID'];
  final String microsoftScheme = dotenv.env['MICROSOFT_SCHEME'] ?? "msauth.com.com.mycomp.myapp";
  final Uri tokenUrl = Uri.parse('https://login.microsoftonline.com/$microsoftTenantId/oauth2/v2.0/token');

  final List<String> scopes = [
    'Calendars.ReadWrite',
    'Chat.ReadWrite',
    'email',
    'Files.ReadWrite.All',
    'Mail.Read',
    'Mail.Send',
    'Notes.Create',
    'Notes.ReadWrite.All',
    'Notifications.ReadWrite.CreatedByApp',
    'offline_access',
    'openid',
    'profile',
    'ShortNotes.ReadWrite',
    'Tasks.ReadWrite',
    'User.ReadBasic.All',
    'User.ReadWrite',
  ];

  final pkcePair = PkcePair.generate();
  const String state = '23456';

  final url = Uri.https('login.microsoftonline.com', '$microsoftTenantId/oauth2/v2.0/authorize', {
    'client_id': microsoftClientId,
    'response_type': 'code',
    'redirect_uri': "$microsoftScheme://auth",
    'response_mode': 'query',
    'scope': scopes.join(' '),
    'state': state,
    'code_challenge': pkcePair.codeChallenge,
    'code_challenge_method': 'S256',
  });

  final result = await FlutterWebAuth2.authenticate(
    url: url.toString(),
    callbackUrlScheme: microsoftScheme,
  );

  final code = Uri.parse(result).queryParameters['code'];
  final stateResult = Uri.parse(result).queryParameters['state'];

  if (stateResult != state || code == null) {
    return;
  }

  final response = await http.post(tokenUrl, body: {
    'client_id': microsoftClientId,
    'scope': scopes.join(' '),
    'code': code,
    'redirect_uri': "$microsoftScheme://auth",
    'grant_type': 'authorization_code',
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
      path: '/api/auth/microsoft/callback'
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
