import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveTokens(String access, String refresh) async {
    await _storage.write(key: 'access', value: access);
    await _storage.write(key: 'refresh', value: refresh);
  }

  static Future<String?> getAccess() => _storage.read(key: 'access');
  static Future<String?> getRefresh() => _storage.read(key: 'refresh');

  static Future<void> clear() async {
    await _storage.delete(key: 'access');
    await _storage.delete(key: 'refresh');
  }
}