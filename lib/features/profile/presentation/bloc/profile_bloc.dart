import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/exception/app_exception.dart';
import '../../../../core/utils/routes.dart';
import '../../../auth/data/repository/auth_repository.dart';
import '../../data/model/profile_model.dart';
import '../../data/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IAuthRepository repository;
  final IProfileRepository profileRepository;
  final BuildContext context;

  ProfileBloc({
    required this.repository,
    required this.profileRepository,
    required this.context,
  }) : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) async {
      if (event is ProfileStarted) {
        try {
          emit(ProfileLoading());

          final profile = await profileRepository.getProfile();

          emit(
            ProfileSuccess(profile: profile),
          );
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
            emit(ProfileError(exception: exception));
          }
        }
      } else if (event is ProfileChangeAvatarStarted) {
        try {
          emit(ProfileLoading());

          await profileRepository.changeProfileImage(
            image: event.image,
            filename: event.filename,
          );

          emit(const ProfileChangeAvatarSuccess());
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
            emit(ProfileError(exception: exception));
          }
        }
      }
    });
  }
}
