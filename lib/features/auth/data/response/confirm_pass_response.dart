import '../../../../core/core.dart';
import '../model/api_result_status.dart';

class ConfirmPassResponse {
  final String? securityKey;
  final bool isSuccess;
  final String? message;
  final ConfirmSmsStatusEnum confirmStatus;
  final ApiResultStatus resultStatus;

  ConfirmPassResponse({
    this.securityKey,
    required this.isSuccess,
    this.message,
    required this.confirmStatus,
    required this.resultStatus,
  });

  factory ConfirmPassResponse.fromJson(dynamic json) {
    ConfirmSmsStatusEnum status = ConfirmSmsStatusEnum.error;
    switch (json['data']["status"]) {
      case 0:
        status = ConfirmSmsStatusEnum.error;
        break;
      case 1:
        status = ConfirmSmsStatusEnum.sentSms;
        break;
      case 2:
        status = ConfirmSmsStatusEnum.verify;
        break;
      case 3:
        status = ConfirmSmsStatusEnum.notFind;
        break;
    }
    return ConfirmPassResponse(
      isSuccess: json['isSuccess'],
      securityKey: json['data']['securityKey'],
      confirmStatus: status,
      message: json['message'],
      resultStatus: ApiResultStatus.fromJson(json['statusCode']),
    );
  }
}
