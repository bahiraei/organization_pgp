import 'package:dio/dio.dart';

import '../../../../core/exception/http_response_validator.dart';
import '../model/fish_model.dart';

abstract class IFishDataSource {
  Future<FishModel> getFish({
    required String year,
    required String month,
  });

  Future<String> getFile({
    required String year,
    required String month,
  });
}

class FishDataSource with HttpResponseValidator implements IFishDataSource {
  final Dio http;

  FishDataSource({
    required this.http,
  });

  @override
  Future<FishModel> getFish({
    required String year,
    required String month,
  }) async {
    final response = await http.post(
      'api/Fish/GetFishPetroEmam',
      data: {
        "year": year,
        "month": month,
      },
    );

    final validated = validateResponse(response);

    return FishModel.fromJson(validated.data);
  }

  @override
  Future<String> getFile({
    required String year,
    required String month,
  }) async {
    final response = await http.post(
      'api/Fish/GetFishPetroEmamPdf2',
      data: {
        "year": year,
        "month": month,
      },
    );

    final validated = validateResponse(response);

    return validated.data;
  }
}
