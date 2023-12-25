import 'package:dio/dio.dart';

import '../../../../core/exception/http_response_validator.dart';
import '../model/home_data_model.dart';
import '../model/slider_model.dart';

abstract class IHomeDataSource {
  Future<HomeDataModel> getHome();

  Future<SliderModel> getSlider();

  Future<void> readHappyBirthday();
}

class HomeDataSource with HttpResponseValidator implements IHomeDataSource {
  final Dio http;

  HomeDataSource({
    required this.http,
  });

  @override
  Future<HomeDataModel> getHome() async {
    final response = await http.post(
      '/api/Home/GetHome',
    );

    validateResponse(response);

    return HomeDataModel.fromJson(response.data);
  }

  @override
  Future<SliderModel> getSlider() async {
    final response = await http.post(
      '/api/Slider/Get',
    );

    validateResponse(response);

    return SliderModel.fromJson(response.data);
  }

  @override
  Future<void> readHappyBirthday() async {
    final response = await http.post(
      '/api/BornToday/ReadHappyBirthdayMessage',
    );

    validateResponse(response);
  }
}
