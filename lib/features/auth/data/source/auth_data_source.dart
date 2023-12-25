import 'package:dio/dio.dart';

import '../../../../core/core.dart';
import '../../../../core/exception/http_response_validator.dart';
import '../model/account_info.dart';
import '../response/confirm_pass_response.dart';

abstract class IAuthDataSource {
  Future<ConfirmPassResponse?> login({
    required String nationalCode,
    String? confirmCode,
    String? smsAutoFillCode,
  });

  Future<AccountInfoResponse?> verify({
    required String securityKey,
    required DeviceTypeEnum deviceType,
    required int appVersion,
    String? imei,
  });

  Future<bool> isLogin();

  Future<void> saveFireBaseToken({
    required String token,
  });
}

class AuthDataSource with HttpResponseValidator implements IAuthDataSource {
  final Dio http;

  AuthDataSource({
    required this.http,
  });

  @override
  Future<ConfirmPassResponse?> login({
    required String nationalCode,
    String? confirmCode,
    String? smsAutoFillCode,
  }) async {
    final response = await http.post(
      'api/Account/ConfirmSms/',
      data: {
        "meliCode": nationalCode,
        "confirmCode": confirmCode,
        "smsAutoFillCode": smsAutoFillCode,
      },
    );

    if (response.data == null) {
      return null;
    } else {
      return ConfirmPassResponse.fromJson(response.data);
    }
  }

  @override
  Future<AccountInfoResponse?> verify({
    required String securityKey,
    required DeviceTypeEnum deviceType,
    required int appVersion,
    String? imei,
  }) async {
    final response = await http.post(
      'api/Account/Login',
      data: {
        "securityKey": securityKey,
        "deviceType": deviceType.index + 1,
        'appVersion': appVersion,
        'imei': imei,
      },
    );

    if (response.data == null) {
      return null;
    } else {
      return AccountInfoResponse.fromJson(response.data);
    }
  }

  @override
  Future<bool> isLogin() async {
    try {
      await http.post(
        'api/Account/GetProfile',
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> saveFireBaseToken({
    required String token,
  }) async {
    final response = await http.post(
      'api/Account/SaveFirebaseToken',
      data: {
        "data": token,
      },
    );

    validateResponse(response);
  }
}
