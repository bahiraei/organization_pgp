import 'package:dio/dio.dart';

import '../core.dart';

class AppException implements Exception {
  final String? message;
  final String? prefix;
  final String? url;

  AppException({
    this.message,
    this.prefix,
    this.url,
  });
}

class ExceptionHandler {
  static Future<String> getMessage(
    exception,
  ) async {
    if (exception is FetchDataException) {
      return exception.message.toString();
    } else if (exception is BadRequestException) {
      return exception.message.toString();
    } else if (exception is ToManyRequestException) {
      return exception.message.toString();
    } else if (exception is UnauthorizedException) {
      return exception.message.toString();
    } else if (exception is NotFoundException) {
      return exception.message.toString();
    } else if (exception is ApiNotRespondingException) {
      return exception.message.toString();
    } else if (exception is AppException) {
      return exception.message.toString();
    } else {
      return 'Unknown error occurred.';
    }
  }

  static Future<AppException> handleDioError(error) async {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return FetchDataException(
          message: 'ارتباط با سرور برقرار نشد',
        );
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return FetchDataException(
          message: error.response?.data['message'] ?? error.message,
        );
      } else if (error.type == DioExceptionType.sendTimeout) {
        return FetchDataException(
          message: error.response?.data['message'] ?? error.message,
        );
      } else if (error.type == DioExceptionType.badResponse) {
        if (error.response != null) {
          switch (error.response?.statusCode) {
            case 400: // Bad Request
              return BadRequestException(
                  message: error.response?.data['message'] ?? error.message);
            case 401: //Unauthorized
              return UnauthorizedException(
                message: error.response?.data['message'] ?? error.message,
              );
            case 403: //Forbidden
              return UnauthorizedException(
                message: error.response?.data['message'] ?? error.message,
              );
            case 404: // Not Found
              return NotFoundException(
                  message: error.response?.data['message'] ?? error.message);
            case 500: // Internal Server Error
            default:
              return FetchDataException(message: 'خطا در ارتباط با سرور');
          }
        }
        return FetchDataException(
          message: error.response?.data['message'] ?? error.message,
        );
      } else if (error.type == DioExceptionType.unknown) {
        if (error.response != null) {
          switch (error.response?.statusCode) {
            case 400: // Bad Request
              return BadRequestException(
                  message: error.response?.data['message'] ?? error.message);
            case 401: //Unauthorized
              return UnauthorizedException(
                message: error.response?.data['message'] ?? error.message,
              );
            case 403: //Forbidden
              return UnauthorizedException(
                message: error.response?.data['message'] ?? error.message,
              );
            case 404: // Not Found
              return NotFoundException(
                  message: error.response?.data['message'] ?? error.message);
            case 500: // Internal Server Error
            default:
              return FetchDataException(
                  message: error.response?.data['message'] ?? error.message);
          }
        } else {
          return SocketException(
            message: 'لطفا اینترنت خود را بررسی کنید!',
          );
        }
      } else if (error.type == DioExceptionType.connectionError) {
        return SocketException(
          message: 'خطا در اتصال به سرور!',
        );
      } else if (error.type == DioExceptionType.badCertificate) {
        return BadRequestException(
          message: 'گواهی امنیتی معتبر نمی باشد.',
        );
      } else if (error.type == DioExceptionType.badCertificate) {
        return BadRequestException(
          message: 'گواهی امنیتی معتبر نمی باشد.',
        );
      } else if (error.type == DioExceptionType.cancel) {
        return FetchDataException(
          message: error.response?.data['message'] ?? error.message,
        );
      } else if (error.type == DioExceptionType.badResponse) {
        if (error.response!.statusCode == 401) {
          return UnauthorizedException(
            message: error.response?.data['message'] ?? error.message,
          );
        } else if (error.response!.statusCode == 413) {
          return BadRequestException(message: 'حجم فایل ارسالی زیاد میباشد');
        } else {
          return BadRequestException(
              message: error.response?.data['message'] ?? error.message);
        }
      }
    } else if (error is AppException) {
      Helper.log(error.toString());
      return error;
    } else {
      Helper.log(error.toString());
      return FetchDataException(message: 'خطایی رخ داده است');
    }
    return FetchDataException(message: 'خطایی رخ داده است');
  }
}

class BadRequestException extends AppException {
  BadRequestException({
    super.message,
    super.url,
  }) : super(
          prefix: ' Bad Request',
        );
}

class ToManyRequestException extends AppException {
  ToManyRequestException({
    super.message,
    super.url,
  }) : super(
          prefix: 'To Many Request',
        );
}

class FetchDataException extends AppException {
  FetchDataException({
    super.message,
    super.url,
  }) : super(
          prefix: 'Unable to process the request',
        );
}

class UnprocessableException extends AppException {
  UnprocessableException({
    super.message,
    super.url,
  }) : super(
          prefix: 'Unprocessable Entity response',
        );
}

class SocketException extends AppException {
  SocketException({
    super.message,
    super.url,
  }) : super(
          prefix: 'No Internet Connection',
        );
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException({
    super.message,
    super.url,
  }) : super(
          prefix: 'API not responding',
        );
}

class UnauthorizedException extends AppException {
  UnauthorizedException({
    super.message,
    super.url,
  }) : super(
          prefix: 'Unauthorized Request',
        );
}

class NotFoundException extends AppException {
  NotFoundException({
    super.message,
    super.url,
  }) : super(
          prefix: 'Page not found',
        );
}

/*class LocationServiceException extends AppException {
  LocationServiceException({
    String? message,
    String? url,
  }) : super(
          message: message,
          prefix: 'Please enable location service.',
          url: url,
        );
}*/

/*
class LocationPermissionException extends AppException {
  LocationPermissionException({
    String? message,
    String? url,
  }) : super(
          message: message ?? 'please grant location permission.',
          prefix: 'Location Permission',
          url: url,
        );
}
*/
