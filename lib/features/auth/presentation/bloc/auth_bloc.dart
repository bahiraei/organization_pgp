import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:organization_pgp/core/core.dart';
import 'package:organization_pgp/features/auth/data/model/app_version.dart';
import 'package:organization_pgp/features/profile/data/repository/profile_repository.dart';

import '../../../../core/exception/app_exception.dart';
import '../../../home/data/model/home_data_model.dart';
import '../../../home/data/model/slider_model.dart';
import '../../../home/data/repository/home_repository.dart';
import '../../../profile/data/model/profile_model.dart';
import '../../data/model/account_info.dart';
import '../../data/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository authRepository;
  final IProfileRepository profileRepository;
  final IHomeRepository homeRepository;
  final BuildContext context;

  AuthBloc({
    required this.authRepository,
    required this.profileRepository,
    required this.homeRepository,
    required this.context,
  }) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthLoginStarted) {
        try {
          emit(AuthLoading());
          final response = await authRepository.login(
            nationalCode: event.nationalCode,
            smsAutoFillCode: event.smsAutoFillCode,
          );
          if ((response?.isSuccess ?? false) &&
              response?.confirmStatus == ConfirmSmsStatusEnum.sentSms) {
            emit(const AuthSuccess());
          } else {
            if (response?.confirmStatus == ConfirmSmsStatusEnum.notFind) {
              emit(
                AuthError(
                  exception: AppException(message: 'کاربر مورد نظر یافت نشد'),
                ),
              );
            } else {
              emit(
                AuthError(
                  exception: AppException(message: 'خطایی رخ داده است'),
                ),
              );
            }
          }
        } catch (e) {
          final exception = await ExceptionHandler.handleDioError(e);
          emit(AuthError(exception: exception));
        }
      } else if (event is AuthVerifyStarted) {
        try {
          emit(AuthLoading());
          final response = await authRepository.login(
            nationalCode: event.nationalCode,
            confirmCode: event.confirmCode,
          );
          if ((response?.isSuccess ?? false) &&
              response?.confirmStatus == ConfirmSmsStatusEnum.verify &&
              response?.securityKey != null) {
            final AccountInfoResponse? accountInfo =
                await authRepository.verify(
              securityKey: response!.securityKey!,
              deviceType: kIsWeb ? DeviceTypeEnum.ios : DeviceTypeEnum.android,
              appVersion: AppInfo.appVersionForCheckUpdate,
            );
            Helper.log('BuildNumber =>${AppInfo.appVersionForCheckUpdate}');
            Helper.log('Token =>${AuthRepository.tokenInfo?.token}');
            if (accountInfo != null) {
              if (accountInfo.appVersion.allowToLogin) {
                final serverVersion = accountInfo.appVersion.currentVersion;

                Helper.log(AppInfo.appVersionForCheckUpdate.toString());
                Helper.log(serverVersion.toString());

                AppInfo.appServerBuildNumber = serverVersion;

                final homeData = await homeRepository.getHome();
                final sliderData = await homeRepository.getSlider();
                final profileData = await profileRepository.getProfile();

                emit(AuthVerifySuccess(
                  sliders: sliderData,
                  profileData: profileData,
                  homeData: homeData,
                ));
              } else {
                emit(AuthVerifyNeedUpdate(appVersion: accountInfo.appVersion));
              }
            } else {
              emit(
                AuthError(
                  exception: AppException(message: 'خطایی رخ داده است'),
                ),
              );
            }
          } else {
            if (response?.confirmStatus == ConfirmSmsStatusEnum.notFind) {
              emit(
                AuthError(
                  exception: AppException(message: 'کاربر مورد نظر یافت نشد'),
                ),
              );
            } else {
              emit(
                AuthError(
                  exception: AppException(message: 'خطایی رخ داده است'),
                ),
              );
            }
          }
        } catch (e) {
          final exception = await ExceptionHandler.handleDioError(e);
          emit(AuthError(exception: exception));
        }
      }
    });
  }
}
