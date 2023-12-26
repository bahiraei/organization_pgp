import 'package:dio/dio.dart';

import '../../../../core/exception/http_response_validator.dart';
import '../response/digital_calandar_response.dart';

abstract class IDigitalCalendarDataSource {
  Future<DigitalCalendarResponse> get();
}

class DigitalCalendarDataSource
    with HttpResponseValidator
    implements IDigitalCalendarDataSource {
  final Dio dio;

  DigitalCalendarDataSource({
    required this.dio,
  });

  @override
  Future<DigitalCalendarResponse> get() async {
    final response = await dio.post(
      '/api/DigitalCalender/Get',
    );

    final validated = validateResponse(response);

    return DigitalCalendarResponse.fromJson(validated.data);
  }
}
