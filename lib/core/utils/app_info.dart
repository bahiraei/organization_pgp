import 'package:package_info_plus/package_info_plus.dart';

import '../../features/auth/data/model/app_version.dart';

class AppInfo {
  static PackageInfo? packageInfo;
  static String? appSignature;
  static String? fcmToken;
  static AppVersion appServerVersion = AppVersion(
    allowToLogin: true,
    currentVersion: 0,
  );
  static const int appVersionForCheckUpdate = 6;
}
