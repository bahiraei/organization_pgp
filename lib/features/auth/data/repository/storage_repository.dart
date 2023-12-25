import 'package:shared_preferences/shared_preferences.dart';

import '../source/storage_data_source.dart';

abstract class IStorageRepository {
  Future<void> write(String key, String value);

  Future<String?> read(String key);

  Future<void> delete(String key);

  Future<void> deleteAll();

  Future<bool> containsKey(String key);
}

class StorageRepository implements IStorageRepository {
  final IStorageDataSource storageDataSource;

  StorageRepository(this.storageDataSource);

  @override
  Future<bool> containsKey(String key) {
    return storageDataSource.containsKey(key);
  }

  @override
  Future<void> delete(String key) async {
    storageDataSource.delete(key);
  }

  @override
  Future<void> deleteAll() {
    return storageDataSource.deleteAll();
  }

  @override
  Future<String?> read(String key) {
    return storageDataSource.read(key);
  }

  @override
  Future<void> write(String key, String value) {
    return storageDataSource.write(key, value);
  }
}

final IStorageRepository secureStorageRepository = StorageRepository(
  StorageSecureLocalDataSource(),
);

final IStorageRepository storageRepository = StorageRepository(
  StorageLocalDataSource(
    sharedPreferences: SharedPreferences.getInstance(),
  ),
);
