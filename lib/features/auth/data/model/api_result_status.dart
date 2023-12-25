import '../../../../core/core.dart';

class ApiResultStatus {
  final ResultStatusCodeEnum? status;

  ApiResultStatus({
    required this.status,
  });

  factory ApiResultStatus.fromJson(int status) {
    ResultStatusCodeEnum? resultStatusCode;
    switch (status) {
      case 0:
        resultStatusCode = ResultStatusCodeEnum.success;
        break;
      case 1:
        resultStatusCode = ResultStatusCodeEnum.serverError;
        break;
      case 2:
        resultStatusCode = ResultStatusCodeEnum.badRequest;
        break;
      case 3:
        resultStatusCode = ResultStatusCodeEnum.notFound;
        break;
      case 4:
        resultStatusCode = ResultStatusCodeEnum.listEmpty;
        break;
      case 5:
        resultStatusCode = ResultStatusCodeEnum.logicError;
        break;
      case 6:
        resultStatusCode = ResultStatusCodeEnum.unAuthorized;
        break;
    }

    return ApiResultStatus(
      status: resultStatusCode,
    );
  }
}
