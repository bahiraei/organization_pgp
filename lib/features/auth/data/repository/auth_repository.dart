import 'package:organization_pgp/core/client/http_client.dart';
import 'package:organization_pgp/features/auth/data/repository/storage_repository.dart';

import '../../../../core/core.dart';
import '../model/account_info.dart';
import '../model/token_info.dart';
import '../response/confirm_pass_response.dart';
import '../source/auth_data_source.dart';

abstract class IAuthRepository {
  Future<ConfirmPassResponse?> login({
    required String nationalCode,
    String? confirmCode,
    String? smsAutoFillCode,
  });

  Future<AccountInfoResponse?> verify({
    required String securityKey,
    required DeviceTypeEnum deviceType,
    required int appVersion,
    String? imei,
  });

  Future<bool> isLogin();

  Future<void> signOut();

  Future<void> saveFireBaseToken({
    required String token,
  });
}

class AuthRepository implements IAuthRepository {
  final IAuthDataSource dataSource;
  final IStorageRepository secureStorageRepository;
  static AccountInfo? tokenInfo;

  AuthRepository({
    required this.dataSource,
    required this.secureStorageRepository,
  });

  Future<void> persistAuthTokens(
    AccountInfoResponse authInfo,
  ) async {
    if (authInfo.token != null && authInfo.securityKey != null) {
      await secureStorageRepository.write(
        AppKey.STORAGE_ACCESS_TOKEN_KEY,
        authInfo.token ?? '',
      );

      await secureStorageRepository.write(
        AppKey.STORAGE_SECURITY_KEY,
        authInfo.securityKey ?? '',
      );
    }

    await loadAuthInfo();
  }

  Future<void> loadAuthInfo() async {
    final String accessToken =
        await secureStorageRepository.read(AppKey.STORAGE_ACCESS_TOKEN_KEY) ??
            '';

    final String securityKey =
        await secureStorageRepository.read(AppKey.STORAGE_SECURITY_KEY) ?? '';

    if (accessToken != '' && securityKey != '') {
      tokenInfo = AccountInfo(
        token: accessToken,
        securityToken: securityKey,
      );
    }
  }

  @override
  Future<ConfirmPassResponse?> login({
    required String nationalCode,
    String? confirmCode,
    String? smsAutoFillCode,
  }) {
    return dataSource.login(
      nationalCode: nationalCode,
      confirmCode: confirmCode,
      smsAutoFillCode: smsAutoFillCode,
    );
  }

  @override
  Future<AccountInfoResponse?> verify({
    required String securityKey,
    required DeviceTypeEnum deviceType,
    required int appVersion,
    String? imei,
  }) async {
    AccountInfoResponse? account = await dataSource.verify(
      securityKey: securityKey,
      deviceType: deviceType,
      appVersion: appVersion,
      imei: imei,
    );
    if (account != null) {
      if (account.isSuccess) {
        if (account.token != null && account.securityKey != null) {
          await persistAuthTokens(account);
        }
      }
    }

    return account;
  }

  @override
  Future<bool> isLogin() async {
    try {
      await authRepository.loadAuthInfo();
      final String? accessToken =
          await secureStorageRepository.read(AppKey.STORAGE_ACCESS_TOKEN_KEY);

      final String? securityKey =
          await secureStorageRepository.read(AppKey.STORAGE_SECURITY_KEY);

      if (tokenInfo != null && accessToken != null && securityKey != null) {
        final bool result = await dataSource.isLogin();
        if (result == false) {
          await authRepository.signOut();
        }
        return result;
      } else {
        return false;
      }
    } catch (e) {
      await authRepository.signOut();
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await authRepository.saveFireBaseToken(token: '');
    } catch (e) {
      Helper.log(e.toString());
    }
    tokenInfo = null;
    AppInfo.fcmToken = null;
    await secureStorageRepository.delete(AppKey.STORAGE_ACCESS_TOKEN_KEY);
    await secureStorageRepository.delete(AppKey.STORAGE_SECURITY_KEY);
  }

  @override
  Future<void> saveFireBaseToken({
    required String token,
  }) {
    return dataSource.saveFireBaseToken(
      token: token,
    );
  }
}

final authRepository = AuthRepository(
  dataSource: AuthDataSource(
    http: httpClient,
  ),
  secureStorageRepository: secureStorageRepository,
);
