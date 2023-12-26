import '../../../../core/client/http_client.dart';
import '../response/digital_calandar_response.dart';
import '../source/digital_calendar_data_source.dart';

abstract class IDigitalCalendarRepository {
  Future<DigitalCalendarResponse> get();
}

class DigitalCalendarRepository implements IDigitalCalendarRepository {
  final IDigitalCalendarDataSource dataSource;

  DigitalCalendarRepository({
    required this.dataSource,
  });

  @override
  Future<DigitalCalendarResponse> get() {
    return dataSource.get();
  }
}

final digitalCalendarRepository = DigitalCalendarRepository(
  dataSource: DigitalCalendarDataSource(
    dio: httpClient,
  ),
);
