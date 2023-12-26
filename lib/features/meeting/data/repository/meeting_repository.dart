import '../../../../core/client/http_client.dart';
import '../response/meeting_response.dart';
import '../source/meeting_data_source.dart';

abstract class IMeetingRepository {
  Future<MeetingResponse> getAll({
    required int page,
  });
}

class MeetingRepository implements IMeetingRepository {
  final IMeetingDataSource dataSource;

  MeetingRepository({
    required this.dataSource,
  });

  @override
  Future<MeetingResponse> getAll({
    required int page,
  }) {
    return dataSource.getAll(
      page: page,
    );
  }
}

final meetingRepository = MeetingRepository(
  dataSource: MeetingDataSource(
    dio: httpClient,
  ),
);
