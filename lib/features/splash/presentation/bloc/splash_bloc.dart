import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:organization_pgp/core/exception/app_exception.dart';
import 'package:organization_pgp/features/home/data/model/home_data_model.dart';
import 'package:organization_pgp/features/home/data/model/slider_model.dart';
import 'package:organization_pgp/features/home/data/repository/home_repository.dart';
import 'package:organization_pgp/features/profile/data/repository/profile_repository.dart';

import '../../../../core/utils/routes.dart';
import '../../../auth/data/repository/auth_repository.dart';
import '../../../profile/data/model/profile_model.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final IAuthRepository authRepository;
  final IHomeRepository homeRepository;
  final IProfileRepository profileRepository;
  final BuildContext context;

  SplashBloc({
    required this.authRepository,
    required this.homeRepository,
    required this.profileRepository,
    required this.context,
  }) : super(SplashInitial()) {
    on<SplashEvent>((event, emit) async {
      if (event is SplashStarted) {
        try {
          emit(SplashLoading());

          final connectivityResult = await (Connectivity().checkConnectivity());

          if (connectivityResult == ConnectivityResult.none) {
            emit(
              SplashError(
                exception: SocketException(
                  message: 'داده ها و یا وای فای را روشن کنید.',
                ),
              ),
            );
            return;
          }

          final bool isLogin = await authRepository.isLogin();

          if (isLogin) {
            final homeData = await homeRepository.getHome();
            final sliderData = await homeRepository.getSlider();
            final profileData = await profileRepository.getProfile();

            emit(
              SplashSuccess(
                homeData: homeData,
                profileData: profileData,
                sliders: sliderData,
              ),
            );
          } else {
            emit(
              SplashError(
                exception: UnauthorizedException(),
              ),
            );
          }
        } catch (e) {
          final exception = await ExceptionHandler.handleDioError(e);
          if (exception is UnauthorizedException) {
            await authRepository.signOut().then((value) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.splash,
                (route) => false,
              );
            });
          } else {
            emit(SplashError(exception: exception));
          }
        }
      }
    });
  }
}
