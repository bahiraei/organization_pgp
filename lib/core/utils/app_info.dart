import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static PackageInfo? packageInfo;
  static String? appSignature;
  static String? fcmToken;
  static int appServerBuildNumber = 0;
  static const int appVersionForCheckUpdate = 1;
}
