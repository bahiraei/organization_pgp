import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IStorageDataSource {
  Future<void> write(String key, String value);

  Future<String?> read(String key);

  Future<void> delete(String key);

  Future<void> deleteAll();

  Future<bool> containsKey(String key);
}

class StorageSecureLocalDataSource implements IStorageDataSource {
  final _secureStorage = const FlutterSecureStorage();

  @override
  Future<bool> containsKey(String key) async {
    var containsKey = await _secureStorage.containsKey(
      key: key,
      aOptions: _getAndroidOptions(),
    );
    return containsKey;
  }

  @override
  Future<void> delete(String key) async {
    await _secureStorage.delete(
      key: key,
      aOptions: _getAndroidOptions(),
    );
  }

  @override
  Future<void> deleteAll() async {
    await _secureStorage.deleteAll(aOptions: _getAndroidOptions());
  }

  @override
  Future<String?> read(String key) async {
    var result = await _secureStorage.read(
      key: key,
      aOptions: _getAndroidOptions(),
    );
    if (result != null) {
      return result;
    }
    return null;
  }

  @override
  Future<void> write(String key, String value) async {
    await _secureStorage.write(
      key: key,
      value: value,
      aOptions: _getAndroidOptions(),
    );
  }

  AndroidOptions _getAndroidOptions() {
    return const AndroidOptions(
      encryptedSharedPreferences: true,
    );
  }
}

class StorageLocalDataSource implements IStorageDataSource {
  final Future<SharedPreferences> sharedPreferences;

  StorageLocalDataSource({
    required this.sharedPreferences,
  });

  @override
  Future<bool> containsKey(String key) {
    return sharedPreferences.then((shared) {
      return shared.containsKey(key);
    });
  }

  @override
  Future<void> delete(String key) {
    return sharedPreferences.then((shared) {
      shared.remove(key);
    });
  }

  @override
  Future<void> deleteAll() {
    return sharedPreferences.then((shared) {
      shared.clear();
    });
  }

  @override
  Future<String?> read(String key) {
    return sharedPreferences.then((shared) {
      return shared.getString(key);
    });
  }

  @override
  Future<void> write(String key, String value) {
    return sharedPreferences.then((shared) {
      shared.setString(key, value);
    });
  }
}
