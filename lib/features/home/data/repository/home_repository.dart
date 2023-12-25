import 'package:organization_pgp/core/client/http_client.dart';

import '../model/home_data_model.dart';
import '../model/slider_model.dart';
import '../source/home_data_source.dart';

abstract class IHomeRepository {
  Future<HomeDataModel> getHome();

  Future<SliderModel> getSlider();

  Future<void> readHappyBirthday();
}

class HomeRepository implements IHomeRepository {
  final IHomeDataSource dataSource;

  HomeRepository({
    required this.dataSource,
  });

  @override
  Future<HomeDataModel> getHome() {
    return dataSource.getHome();
  }

  @override
  Future<SliderModel> getSlider() {
    return dataSource.getSlider();
  }

  @override
  Future<void> readHappyBirthday() {
    return dataSource.readHappyBirthday();
  }
}

final homeRepository = HomeRepository(
  dataSource: HomeDataSource(
    http: httpClient,
  ),
);
