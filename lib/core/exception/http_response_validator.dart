import 'dart:convert';

import 'package:dio/dio.dart';

import 'app_exception.dart';

mixin HttpResponseValidator {
  Response validateResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 201:
        return response;
      case 202:
        return response;
      case 400: // Bad Request
        throw BadRequestException();
      case 401: //Unauthorized
        throw UnauthorizedException();
      case 403: // Forbidden
        throw UnauthorizedException(
            message: jsonDecode(response.data['message']));
      case 404: // Not Found
        throw NotFoundException(message: jsonDecode(response.data['message']));
      case 422: // Not Found
        throw UnprocessableException(
          message: jsonDecode(response.data['message']),
        );
      case 500: // Internal Server Error
      default:
        throw FetchDataException(message: jsonDecode(response.data['message']));
    }
  }
}
