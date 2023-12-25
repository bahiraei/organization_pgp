import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/exception/app_exception.dart';
import '../../../../core/utils/routes.dart';
import '../../../auth/data/repository/auth_repository.dart';
import '../../data/repository/hokm_repository.dart';

part 'hokm_event.dart';
part 'hokm_state.dart';

class HokmBloc extends Bloc<HokmEvent, HokmState> {
  final IHokmRepository hokmRepository;
  final BuildContext context;

  HokmBloc({
    required this.hokmRepository,
    required this.context,
  }) : super(HokmInitial()) {
    on<HokmEvent>((event, emit) async {
      if (event is HokmStarted) {
        try {
          emit(HokmLoading());

          final result = await hokmRepository.getHokm();

          if (result.data?.isEmpty ?? true) {
            emit(HokmEmpty());
          } else {
            var convertImage = const Base64Decoder().convert(result.data!);
            emit(HokmSuccess(
              image: convertImage,
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
            emit(HokmError(exception: exception));
          }
        }
      }
    });
  }
}
