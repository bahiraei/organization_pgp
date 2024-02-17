// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:organization_pgp/core/exception/app_exception.dart';
import 'package:organization_pgp/features/home/data/model/home_data_model.dart';
import 'package:organization_pgp/features/home/data/model/slider_model.dart';
import 'package:organization_pgp/features/home/data/repository/home_repository.dart';
import 'package:organization_pgp/features/profile/data/repository/profile_repository.dart';

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
        final stopWatch = Stopwatch();
        try {
          stopWatch.start();
          emit(SplashLoading());

          final connectivityResult = await (Connectivity().checkConnectivity());

          if (connectivityResult == ConnectivityResult.none) {
            stopWatch.stop();
            if (stopWatch.elapsed.inSeconds < 4) {
              await Future.delayed(
                  Duration(seconds: 4 - stopWatch.elapsed.inSeconds));
            }
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

            stopWatch.stop();
            if (stopWatch.elapsed.inSeconds < 4) {
              await Future.delayed(
                  Duration(seconds: 4 - stopWatch.elapsed.inSeconds));
            }
            emit(
              SplashSuccess(
                homeData: homeData,
                profileData: profileData,
                sliders: sliderData,
              ),
            );
          } else {
            stopWatch.stop();
            if (stopWatch.elapsed.inSeconds < 4) {
              await Future.delayed(
                  Duration(seconds: 4 - stopWatch.elapsed.inSeconds));
            }
            emit(
              SplashError(
                exception: UnauthorizedException(),
              ),
            );
          }
        } catch (e) {
          final exception = await ExceptionHandler.handleDioError(e);
          stopWatch.stop();
          if (stopWatch.elapsed.inSeconds < 4) {
            await Future.delayed(
                Duration(seconds: 4 - stopWatch.elapsed.inSeconds));
          }
          emit(SplashError(
            exception: exception,
          ));
        }
      }
    });
  }
}
