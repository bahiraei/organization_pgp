import 'package:dio/dio.dart';

import '../../../../core/exception/http_response_validator.dart';
import '../model/phone_book_model.dart';

abstract class IPhoneDataSource {
  Future<PhoneBookModel> getAll();
}

class PhoneDataSource with HttpResponseValidator implements IPhoneDataSource {
  final Dio dio;

  PhoneDataSource({
    required this.dio,
  });

  @override
  Future<PhoneBookModel> getAll() async {
    final response = await dio.post(
      '/api/PhoneBook/GetAll',
    );

    final validated = validateResponse(response);

    return PhoneBookModel.fromJson(validated.data);
  }
}
