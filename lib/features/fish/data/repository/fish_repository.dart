import '../../../../core/client/http_client.dart';
import '../model/fish_model.dart';
import '../source/fish_data_source.dart';

abstract class IFishRepository {
  Future<FishModel> getFish({
    required String year,
    required String month,
  });

  Future<String> getFile({
    required String year,
    required String month,
  });
}

class FishRepository implements IFishRepository {
  final FishDataSource dataSource;

  FishRepository({
    required this.dataSource,
  });

  @override
  Future<FishModel> getFish({
    required String year,
    required String month,
  }) {
    return dataSource.getFish(
      year: year,
      month: month,
    );
  }

  @override
  Future<String> getFile({
    required String year,
    required String month,
  }) {
    return dataSource.getFile(
      year: year,
      month: month,
    );
  }
}

final fishRepository = FishRepository(
  dataSource: FishDataSource(
    http: httpClient,
  ),
);
