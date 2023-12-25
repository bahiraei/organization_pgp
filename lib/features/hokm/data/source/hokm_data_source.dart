import 'package:dio/dio.dart';

import '../../../../core/exception/http_response_validator.dart';
import '../model/hokm_model.dart';

abstract class IHokmDataSource {
  Future<HokmModel> getHokm();
}

class HokmDataSource with HttpResponseValidator implements IHokmDataSource {
  final Dio http;

  HokmDataSource({
    required this.http,
  });

  @override
  Future<HokmModel> getHokm() async {
    final response = await http.post('/api/Fish/GetHokm');

    final validated = validateResponse(response);

    return HokmModel.fromJson(validated.data);
  }
}
