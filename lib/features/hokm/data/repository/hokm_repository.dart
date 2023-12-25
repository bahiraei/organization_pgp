import '../../../../core/client/http_client.dart';
import '../model/hokm_model.dart';
import '../source/hokm_data_source.dart';

abstract class IHokmRepository {
  Future<HokmModel> getHokm();
}

class HokmRepository implements IHokmRepository {
  final IHokmDataSource dataSource;

  HokmRepository({
    required this.dataSource,
  });

  @override
  Future<HokmModel> getHokm() {
    return dataSource.getHokm();
  }
}

final hokmRepository = HokmRepository(
  dataSource: HokmDataSource(
    http: httpClient,
  ),
);
