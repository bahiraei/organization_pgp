// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/exception/app_exception.dart';
import '../../../../core/utils/helper.dart';
import '../../../../core/utils/routes.dart';
import '../../../auth/data/repository/auth_repository.dart';
import '../../data/repository/fish_repository.dart';

part 'fish_event.dart';
part 'fish_state.dart';

class FishBloc extends Bloc<FishEvent, FishState> {
  final IFishRepository repository;
  final BuildContext context;

  FishBloc({
    required this.repository,
    required this.context,
  }) : super(FishInitial()) {
    on<FishEvent>(
      (event, emit) async {
        if (event is FishStarted) {
          try {
            emit(FishLoading());

            final file = await repository.getFile(
              year: event.year,
              month: event.month,
            );

            if (file.isEmpty) {
              emit(FishEmpty());
            } else {
              var convertFile = const Base64Decoder().convert(file);
              Helper.log(file.toString());
              emit(FishSuccess(
                year: event.year,
                month: event.month,
                file: convertFile,
              ));
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
              emit(FishError(exception: exception));
            }
          }
        }
      },
    );
  }
}
