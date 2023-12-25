// ignore_for_file: file_names

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static const Permission _storagePermission = Permission.storage;
  static const Permission _requestInstallPackagePermission =
      Permission.requestInstallPackages;

  static Future<PermissionStatus> getRequestInstallPackagePermission() async {
    var status = await _requestInstallPackagePermission.request();

    return status;
  }

  static Future<PermissionStatus> isRequestInstallPackagePermission() async {
    return await _requestInstallPackagePermission.status;
  }

  static Future<PermissionStatus> getStoragePermission() async {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        if ((await DeviceInfoPlugin().androidInfo).version.sdkInt <= 29) {
          var status = await _storagePermission.request();
          return status;
        } else {
          return PermissionStatus.granted;
        }
      }
    }

    var status = await _storagePermission.request();

    return status;
  }

  static Future<PermissionStatus> isStoragePermission() async {
    return await _storagePermission.status;
  }
}
