import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:organization_pgp/core/core.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:universal_html/html.dart' as html;

import '../../features/auth/data/model/account_info.dart';
import '../../features/auth/data/repository/auth_repository.dart';

final Dio _freshDio = Dio(
  BaseOptions(
    baseUrl: AppEnvironment.baseUrl,
    connectTimeout: const Duration(seconds: 40),
  ),
)..interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: false,
      maxWidth: 90,
      logPrint: (object) {
        Helper.log(object.toString());
      },
    ),
  );

Dio _httpForRefresh = Dio(
  BaseOptions(
    baseUrl: AppEnvironment.baseUrl,
    connectTimeout: const Duration(seconds: 40),
  ),
)
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final authInfo = AuthRepository.tokenInfo;
        options.headers['Authorization'] = 'Bearer ${authInfo?.token}';
        options.headers['Accept'] = 'application/json';

        handler.next(options);
      },
    ),
  )
  ..interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: false,
      maxWidth: 90,
      logPrint: (object) {
        Helper.log(object.toString());
      },
    ),
  );

Dio httpClient = Dio(
  BaseOptions(
    baseUrl: AppEnvironment.baseUrl,
    connectTimeout: const Duration(seconds: 40),
  ),
)
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final authInfo = AuthRepository.tokenInfo;
        options.headers['Authorization'] = 'Bearer ${authInfo?.token}';
        options.headers['Accept'] = 'application/json';

        handler.next(options);
      },
      onError: (error, handler) async {
        Helper.log('onError');
        if (error.response?.statusCode == 403 ||
            error.response?.statusCode == 401) {
          AccountInfoResponse? accountInfo;
          if (AuthRepository.tokenInfo != null &&
              AuthRepository.tokenInfo?.securityToken != null) {
            try {
              final response = await _httpForRefresh.post(
                'api/Account/Login',
                data: {
                  "securityKey": AuthRepository.tokenInfo?.securityToken,
                  "deviceType": kIsWeb
                      ? DeviceTypeEnum.ios.index + 1
                      : DeviceTypeEnum.android.index + 1,
                  'appVersion': AppInfo.appVersionForCheckUpdate,
                  'imei': '',
                },
              );

              if (response.statusCode == 400) {
                accountInfo = null;
              } else if (response.statusCode == 200 &&
                  response.data['isSuccess']) {
                accountInfo = AccountInfoResponse.fromJson(response.data);
                await authRepository.persistAuthTokens(
                  accountInfo,
                );
              } else {
                return handler.reject(error);
              }
            } catch (e) {
              accountInfo = null;
            }
          }

          Helper.log('refresh token sent');
          if (accountInfo != null) {
            AppInfo.appServerBuildNumber =
                accountInfo.appVersion.currentVersion;
            if (accountInfo.appVersion.allowToLogin == false && !kIsWeb) {
              return handler.reject(error);
            } else if (accountInfo.appVersion.allowToLogin == false && kIsWeb) {
              html.window.location.reload();
            }
            //get new tokens ...
            Helper.log("security token ${accountInfo.securityKey}");
            Helper.log("access token ${accountInfo.token}");
            //create request with new access token
            Options opts = Options(
              method: error.requestOptions.method,
              contentType: 'application/json',
              headers: {},
            );

            opts.headers!['Authorization'] = 'Bearer ${accountInfo.token}';
            opts.headers!['Content-Type'] = 'application/json';
            opts.headers!['Content-Length'] = '0';

            late Response? cloneReq;
            try {
              if (error.requestOptions.data != null) {
                if (error.requestOptions.data is FormData) {
                  FormData formData = FormData();
                  formData.fields.addAll(error.requestOptions.data.fields);

                  for (MapEntry mapFile in error.requestOptions.data.files) {
                    formData.files.add(
                      MapEntry(
                        mapFile.key,
                        MultipartFile.fromFileSync(
                          mapFile.value.FILE_PATH,
                          filename: mapFile.value.filename,
                        ),
                      ),
                    );
                  }

                  cloneReq = await _freshDio.request(
                    error.requestOptions.path,
                    options: opts,
                    data: formData,
                    queryParameters: error.requestOptions.queryParameters,
                  );
                } else {
                  cloneReq = await _freshDio.request(
                    error.requestOptions.path,
                    options: opts,
                    data: error.requestOptions.data,
                    queryParameters: error.requestOptions.queryParameters,
                  );
                }
              } else {
                cloneReq = await _freshDio.request(
                  error.requestOptions.path,
                  options: opts,
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                );
              }
            } catch (e) {
              if (e is DioException) {
                return handler.reject(e);
              } else {
                return handler.reject(error);
              }
            }

            Helper.log(cloneReq.toString());

            return handler.resolve(cloneReq);
          } else {
            return handler.reject(error);
          }
        }
        Helper.log('end onError');
        handler.next(error);
      },
    ),
  )
  ..interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: false,
      maxWidth: 90,
      logPrint: (object) {
        Helper.log(object.toString());
      },
    ),
  );
