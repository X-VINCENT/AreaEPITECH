import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class LocalSecureStorage {
  final storage = FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await storage.delete(key: key);
  }

  Future<void> storeMap(Map<String, dynamic> map, String key) async {
    final jsonString = json.encode(map);
    await storage.write(key: key, value: jsonString);
  }

  Future<Map<String, dynamic>?> readMap(String key) async {
    final jsonString = await storage.read(key: key);
    if (jsonString != null) {
      final map = json.decode(jsonString);
      if (map is Map<String, dynamic>) {
        return map;
      }
    }
    return null;
  }

  Future<void> deleteByKey(String key) async {
    final jsonString = await storage.read(key: 'user');
    if (jsonString != null) {
      final map = json.decode(jsonString);
      if (map is Map<String, dynamic>) {
        map.remove(key);
        await storage.write(key: 'user', value: json.encode(map));
      }
    }
  }
}
