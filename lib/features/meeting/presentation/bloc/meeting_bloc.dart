import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/exception/app_exception.dart';
import '../../../../core/utils/routes.dart';
import '../../../auth/data/repository/auth_repository.dart';
import '../../data/model/meeting_model.dart';
import '../../data/repository/meeting_repository.dart';

part 'meeting_event.dart';
part 'meeting_state.dart';

class MeetingBloc extends Bloc<MeetingEvent, MeetingState> {
  final IMeetingRepository repository;
  final BuildContext context;

  MeetingBloc({
    required this.repository,
    required this.context,
  }) : super(MeetingInitial()) {
    bool meetingMoreData = true;
    int meetingPage = 0;

    List<MeetingModel> _meetingHistory = [];

    bool isMeetingLoading = false;

    on<MeetingEvent>(
      (event, emit) async {
        if (event is MeetingStarted) {
          try {
            if ((isMeetingLoading || meetingMoreData == false)) {
              return;
            } else {
              isMeetingLoading = true;
            }

            if (!event.isScrolling) {
              _meetingHistory = [];
              meetingPage = 0;
              meetingMoreData = true;
              isMeetingLoading = false;

              emit(MeetingLoading());
            }

            final result = await repository.getAll(
              page: meetingPage,
            );

            meetingPage++;
            meetingMoreData = result.moreData;

            if (result.meetings.isEmpty && _meetingHistory.isNotEmpty) {
              meetingPage--;
              isMeetingLoading = false;

              emit(
                MeetingSuccess(
                  meetings: _meetingHistory,
                  moreData: result.moreData,
                ),
              );
            } else if (result.meetings.isEmpty && _meetingHistory.isEmpty) {
              isMeetingLoading = false;
              emit(
                MeetingEmpty(),
              );
            } else {
              isMeetingLoading = false;
              _meetingHistory = _meetingHistory + result.meetings;
              emit(
                MeetingSuccess(
                  meetings: _meetingHistory,
                  moreData: result.moreData,
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
              emit(MeetingError(exception: exception));
            }
          }
        }
      },
    );
  }
}
