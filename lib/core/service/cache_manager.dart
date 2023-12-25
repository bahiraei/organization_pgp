import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class CacheManager {
  static Future<void> clearAllCache() async {
    final cacheDir = await getCacheDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  static Future<void> clearAllApp() async {
    final appDir = await getApplicationSupportDirectory();
    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  static Future<void> clearAll() async {
    await clearAllCache();
    await clearAllApp();
  }

  static Future<Directory> getCacheDirectory() async {
    Directory directory = await getTemporaryDirectory();
    return directory;
  }

  static Future<Directory> getAppDirectory() async {
    Directory directory = await getApplicationSupportDirectory();
    return directory;
  }

  static Future<void> deleteFilesIfCache(String endsWith) async {
    if (kIsWeb) return;
    final cacheDir = await getCacheDirectory();
    final files = cacheDir.listSync();
    for (final file in files) {
      if (file.path.endsWith(endsWith)) {
        file.deleteSync();
      }
    }
  }
}
