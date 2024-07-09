import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_notif_app/utils/logger.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _secureStorage;

  SecureStorageService() : _secureStorage = const FlutterSecureStorage();

  Future<bool> hasKey(String key) async {
    debugLog(DebugTags.secureStorage, "Checking key: $key");
    final String? value = await _secureStorage.read(key: key);
    return value != null;
  }

  Future<String> read(String key) async {
    debugLog(DebugTags.secureStorage, "Reading key: $key");
    final String? value = await _secureStorage.read(key: key);
    if (value == null) {
      debugLog(DebugTags.secureStorage, "Not found key: $key");
      throw Exception("No value was stored for $key");
    }
    return value;
  }

  Future<void> write(String key, String value) async {
    debugLog(DebugTags.secureStorage, "Writing key: $key");
    await _secureStorage.write(key: key, value: value);
  }

  Future<void> delete(String key) async {
    debugLog(DebugTags.secureStorage, "Deleting key: $key");
    await _secureStorage.delete(key: key);
  }
}

final secureStorageServiceProvider = StateProvider<SecureStorageService>((ref) {
  return SecureStorageService();
});
