import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _instance;
  SharedPref._();

  static Future<SharedPref> getInstance() async {
    _instance ??= await SharedPreferences.getInstance();
    return SharedPref._();
  }

  Future<bool> write(String key, String value) async {
    _instance ??= await SharedPreferences.getInstance();
    return _instance!.setString(key, value);
  }

  Future<String?> read(String key) async {
    _instance ??= await SharedPreferences.getInstance();
    return _instance!.getString(key);
  }
}
