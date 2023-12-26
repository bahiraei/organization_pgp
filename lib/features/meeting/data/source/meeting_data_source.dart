import 'package:dio/dio.dart';

import '../../../../core/exception/http_response_validator.dart';
import '../response/meeting_response.dart';

abstract class IMeetingDataSource {
  Future<MeetingResponse> getAll({
    required int page,
  });
}

class MeetingDataSource
    with HttpResponseValidator
    implements IMeetingDataSource {
  final Dio dio;

  MeetingDataSource({
    required this.dio,
  });

  @override
  Future<MeetingResponse> getAll({
    required int page,
  }) async {
    final response = await dio.post(
      '/api/Meeting/Get',
      data: {
        "page": page,
      },
    );

    final validated = validateResponse(response);

    return MeetingResponse.fromJson(validated.data);
  }
}
