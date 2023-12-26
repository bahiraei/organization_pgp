import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/exception/app_exception.dart';
import '../../../../core/utils/routes.dart';
import '../../../auth/data/repository/auth_repository.dart';
import '../../data/model/admin_feedback.dart';
import '../../data/model/feedback.dart';
import '../../data/repository/feedback_repository.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final IFeedbackRepository repository;
  final BuildContext context;

  bool adminMoreData = true;
  int adminPage = 0;

  List<AdminFeedbackModel> _adminHistory = [];

  bool isAdminLoading = false;

  FeedbackBloc({
    required this.repository,
    required this.context,
  }) : super(FeedbackInitial()) {
    on<FeedbackEvent>((event, emit) async {
      if (event is FeedbackUserStarted) {
        try {
          emit(FeedbackLoading());

          final result = await repository.getAll();

          if (result.feedbacks?.isEmpty ?? true) {
            emit(FeedbackEmpty());
          } else {
            emit(
              FeedbackUserSuccess(
                feedbacks: result.feedbacks,
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
            emit(FeedbackError(exception: exception));
          }
        }
      } else if (event is FeedbackApplyUserStarted) {
        try {
          emit(FeedbackApplyUserLoading());

          final result = await repository.save(
            title: event.title,
            description: event.description,
            type: event.type,
            files: event.files,
          );

          emit(
            const FeedbackApplyUserSuccess(),
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
            emit(FeedbackApplyUserError(exception: exception));
          }
        }
      }
      if (event is FeedbackAdminStarted) {
        try {
          if ((isAdminLoading || adminMoreData == false)) {
            return;
          } else {
            isAdminLoading = true;
          }

          if (!event.isScrolling) {
            _adminHistory = [];
            adminPage = 0;
            adminMoreData = true;
            isAdminLoading = false;

            emit(FeedbackLoading());
          }

          final result = await repository.getAllAdmin(
            page: adminPage,
          );

          adminPage++;
          adminMoreData = result.moreData;

          if (result.feedbacks.isEmpty && _adminHistory.isNotEmpty) {
            adminPage--;
            isAdminLoading = false;

            emit(
              FeedbackAdminSuccess(
                feedbacks: _adminHistory,
                moreData: result.moreData,
              ),
            );
          } else if (result.feedbacks.isEmpty && _adminHistory.isEmpty) {
            isAdminLoading = false;
            emit(
              FeedbackEmpty(),
            );
          } else {
            isAdminLoading = false;
            _adminHistory = _adminHistory + result.feedbacks;
            emit(
              FeedbackAdminSuccess(
                feedbacks: _adminHistory,
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
            emit(FeedbackError(exception: exception));
          }
        }
      } else if (event is FeedbackApplyAdminStarted) {
        try {
          emit(FeedbackLoading());

          final result = await repository.answerAdmin(
            feedbackId: event.feedbackId,
            text: event.text,
          );

          emit(
            const FeedbackApplyAdminSuccess(),
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
            emit(FeedbackError(exception: exception));
          }
        }
      }
    });
  }
}
