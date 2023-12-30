// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/exception/app_exception.dart';
import '../../../../core/utils/routes.dart';
import '../../../auth/data/repository/auth_repository.dart';
import '../../data/model/digital_calendar_model.dart';
import '../../data/repository/digital_calendar_repository.dart';

part 'digital_calendar_event.dart';
part 'digital_calendar_state.dart';

class DigitalCalendarBloc
    extends Bloc<DigitalCalendarEvent, DigitalCalendarState> {
  final IDigitalCalendarRepository repository;
  final BuildContext context;
  DigitalCalendarBloc({
    required this.repository,
    required this.context,
  }) : super(DigitalCalendarInitial()) {
    on<DigitalCalendarEvent>((event, emit) async {
      if (event is DigitalCalendarStarted) {
        try {
          emit(DigitalCalendarLoading());

          final response = await repository.get();

          if (response.digitalCalendars.isEmpty) {
            emit(
              DigitalCalendarEmpty(),
            );
          } else {
            emit(
              DigitalCalendarSuccess(
                digitalCalendars: response.digitalCalendars,
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
            emit(DigitalCalendarError(exception: exception));
          }
        }
      }
    });
  }
}
