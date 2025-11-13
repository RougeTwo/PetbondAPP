import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  void setStore(String key, String? data) async {
    await storage.write(key: key, value: data);
  }

  Future<String?> readStore(String key) async {
    return await storage.read(key: key);
  }

  void deleteStore(String key) async {
    await storage.delete(key: key);
  }

  void deleteAll() async {
    await storage.deleteAll();
  }
}
