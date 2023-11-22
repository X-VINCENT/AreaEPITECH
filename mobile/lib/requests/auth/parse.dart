import 'package:flutter/material.dart';
import 'package:src/requests/auth/google.dart';
import 'package:src/requests/auth/github.dart';
import 'package:src/requests/auth/gitlab.dart';
import 'package:src/requests/auth/microsoft.dart';
import 'package:src/requests/auth/stackexchange.dart';

void authProcessParsing({required String key, required VoidCallback callback}) {
  switch(key) {
    case "google":
      googleAuth(callback: callback);
      break;
    case "github":
      githubAuth(callback: callback);
      break;
    case "gitlab":
      gitlabAuth(callback: callback);
      break;
    case "microsoft":
      microsoftAuth(callback: callback);
      break;
    case "stackexchange":
      stackexchangeAuth(callback: callback);
      break;
    default:
      print('No key found');
      break;
  }
}