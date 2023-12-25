import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/exception/app_exception.dart';
import '../../../../core/utils/routes.dart';
import '../../../auth/data/repository/auth_repository.dart';
import '../../../profile/data/model/profile_model.dart';
import '../../../profile/data/repository/profile_repository.dart';
import '../../data/model/home_data_model.dart';
import '../../data/model/slider_model.dart';
import '../../data/repository/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IHomeRepository homeRepository;
  final IAuthRepository authRepository;
  final IProfileRepository profileRepository;
  final BuildContext context;

  HomeBloc({
    required this.homeRepository,
    required this.authRepository,
    required this.profileRepository,
    required this.context,
  }) : super(HomeInitial()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeHappyBirthdayRead) {
        try {
          emit(HomeDialogLoading());

          await homeRepository.readHappyBirthday();

          emit(HomeHappyBirthdayReadSuccess());
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
            emit(HomeDialogError(exception: exception));
          }
        }
      } else if (event is HomeStarted) {
        try {
          HomeDataModel? homeData = event.homData;
          SliderModel? sliders = event.sliders;
          ProfileModel? profileData = event.profileData;

          /*if (!event
                  .isRefreshing */ /*||
              homeData == null ||
              sliders == null ||
              profileData == null*/ /*
              ) {
            emit(HomeLoading());
          }*/

          if (event.isRefreshing == false) {
            emit(HomeLoading());
          }

          if (event.homData == null) {
            homeData = await homeRepository.getHome();
          }

          if (event.sliders == null) {
            sliders = await homeRepository.getSlider();
          }

          if (event.profileData == null) {
            final profileModel = await profileRepository.getProfile();
            profileData = profileModel;
          }

          emit(HomeSuccess(
            homeData: homeData!,
            sliders: sliders!,
            profileData: profileData!.data!,
          ));
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
            emit(HomeDialogError(exception: exception));
          }
        }
      }
    });
  }
}
