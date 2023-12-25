import 'app_version.dart';

class AccountInfoResponse {
  String? token;
  String? securityKey;
  bool isSuccess;
  String? message;
  AppVersion appVersion;

  AccountInfoResponse({
    this.token,
    this.securityKey,
    required this.isSuccess,
    this.message,
    required this.appVersion,
  });

  factory AccountInfoResponse.fromJson(dynamic json) {
    final data = json['data'];

    return AccountInfoResponse(
      token: data['token'],
      securityKey: data['securityKey'],
      message: json['message'],
      isSuccess: json['isSuccess'],
      appVersion: AppVersion(
        allowToLogin: data['appVersion']['allowedToLogin'],
        currentVersion: data['appVersion']['currentVersion'],
        url: data['appVersion']['url'],
        description: data['appVersion']['description'],
      ),
    );
  }
}
