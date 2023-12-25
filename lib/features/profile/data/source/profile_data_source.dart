import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../../core/exception/http_response_validator.dart';
import '../model/profile_model.dart';

abstract class IProfileDataSource {
  Future<ProfileModel> getProfile();

  Future<void> changeProfileImage({
    required Uint8List image,
    required String filename,
  });
}

class ProfileDataSource
    with HttpResponseValidator
    implements IProfileDataSource {
  final Dio http;

  ProfileDataSource({
    required this.http,
  });

  @override
  Future<ProfileModel> getProfile() async {
    final Response response = await http.post(
      '/api/Account/GetProfile',
    );

    validateResponse(response);

    return ProfileModel.fromJson(response.data);
  }

  @override
  Future<void> changeProfileImage({
    required Uint8List image,
    required String filename,
  }) async {
    final formData = FormData.fromMap(
      {
        'profileImage': MultipartFile.fromBytes(
          image,
          filename: filename,
        ),
      },
    );

    final Response response = await http.post(
      '/api/Account/ChangeProfileImage',
      data: formData,
    );

    validateResponse(response);
  }
}
