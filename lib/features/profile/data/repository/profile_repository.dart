import 'dart:typed_data';

import '../../../../core/client/http_client.dart';
import '../model/profile_model.dart';
import '../source/profile_data_source.dart';

abstract class IProfileRepository {
  Future<ProfileModel> getProfile();

  Future<void> changeProfileImage({
    required Uint8List image,
    required String filename,
  });
}

class ProfileRepository implements IProfileRepository {
  final IProfileDataSource dataSource;

  ProfileRepository({
    required this.dataSource,
  });

  @override
  Future<ProfileModel> getProfile() async {
    return await dataSource.getProfile();
  }

  @override
  Future<void> changeProfileImage({
    required Uint8List image,
    required String filename,
  }) {
    return dataSource.changeProfileImage(
      image: image,
      filename: filename,
    );
  }
}

final profileRepository = ProfileRepository(
  dataSource: ProfileDataSource(
    http: httpClient,
  ),
);
