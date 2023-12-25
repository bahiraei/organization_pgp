import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../../core/exception/app_exception.dart';
import '../../../../core/utils/routes.dart';
import '../../../auth/data/repository/auth_repository.dart';
import '../../data/model/admin_message_model.dart';
import '../../data/model/comment_model.dart';
import '../../data/model/info_for_create_message_model.dart';
import '../../data/model/message_model.dart';
import '../../data/repository/message_repository.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final IMessageRepository repository;
  final BuildContext context;

  bool adminMoreData = true;
  int adminPage = 0;

  List<AdminMessageModel> _adminHistory = [];

  bool isAdminLoading = false;

  MessageBloc({
    required this.repository,
    required this.context,
  }) : super(MessageInitial()) {
    on<MessageEvent>(
      (event, emit) async {
        if (event is MessageStarted) {
          try {
            if (!event.isRefreshing) {
              emit(MessageLoading());
            } else {
              emit(MessageRefreshing());
            }

            final data = await repository.getPosts();

            if (data.data?.isEmpty ?? true) {
              emit(MessageEmpty());
            } else {
              if (event.id != null &&
                  event.id?.trim() != '' &&
                  !event.isRefreshing) {
                final MessageEntity redirect = data.data!
                    .where(
                      (e) =>
                          e.id?.toLowerCase() ==
                          event.id.toString().toLowerCase(),
                    )
                    .first;

                emit(MessageSuccess(
                  data: data,
                  redirectEntity: redirect,
                ));
              } else {
                emit(MessageSuccess(
                  data: data,
                  redirectEntity: null,
                ));
              }
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
              emit(MessageError(exception: exception));
            }
          }
        } else if (event is MessageCommentsStarted) {
          try {
            emit(const MessageCommentsLoading());

            final data = await repository.getComments(
              id: event.id,
            );
            emit(
              MessageCommentsSuccess(
                data: data,
              ),
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
              emit(MessageCommentsError(exception: exception));
            }
          }
        } else if (event is MessageAddCommentStarted) {
          try {
            emit(const MessageAddCommentLoading());

            await repository.addComment(
              id: event.id,
              comment: event.comment,
            );
            emit(
              const MessageAddCommentSuccess(),
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
              emit(MessageAddCommentError(exception: exception));
            }
          }
        } else if (event is CreateMessageStarted) {
          try {
            emit(CreateMessageLoading());
            final info = await repository.getInfoForCreateMessage();
            emit(CreateMessageSuccess(info: info));
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
              emit(CreateMessageError(exception: exception));
            }
          }
        } else if (event is CreateMessageRequestStarted) {
          try {
            emit(const CreateMessageRequestLoading());
            await repository.createMessage(
                title: event.title,
                fullText: event.description,
                canYouComment: event.canUserComment,
                isActive: event.isActive,
                startShowFa: event.startDate.formatCompactDate(),
                endShowFa: event.endDate.formatCompactDate(),
                personGroupId: event.groupId,
                eventId: event.eventId,
                categoryPersoneOfficelId: event.departmentId,
                image: event.image);
            emit(const CreateMessageRequestSuccess());
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
              emit(CreateMessageRequestError(exception: exception));
            }
          }
        } else if (event is MessageAdminStarted) {
          try {
            if (!event.isScrolling) {
              adminMoreData = true;
            }
            if ((isAdminLoading || !adminMoreData)) {
              return;
            } else {
              isAdminLoading = true;
            }

            if (!event.isScrolling) {
              _adminHistory = [];
              adminPage = 0;
              adminMoreData = true;
              emit(MessageLoading());
            }

            final result = await repository.getAllAdminMessages(
              page: adminPage,
              searchText: event.searchText,
            );

            adminPage++;
            adminMoreData = result.moreData;

            if (result.messages.isEmpty && _adminHistory.isNotEmpty) {
              adminPage--;
              isAdminLoading = false;

              emit(
                MessageAdminSuccess(
                  messages: _adminHistory,
                  moreData: result.moreData,
                ),
              );
            } else if (result.messages.isEmpty && _adminHistory.isEmpty) {
              isAdminLoading = false;
              emit(
                MessageEmpty(),
              );
            } else {
              isAdminLoading = false;
              _adminHistory = _adminHistory + result.messages;
              emit(
                MessageAdminSuccess(
                  messages: _adminHistory,
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
              isAdminLoading = false;
              emit(MessageError(exception: exception));
            }
          }
        } else if (event is MessageSendNotifStarted) {
          try {
            emit(const MessageSendNotifLoading());
            await repository.sendNotif(
              messageID: event.messageId,
            );
            emit(const MessageSendNotifSuccess());
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
              emit(MessageNotifError(exception: exception));
            }
          }
        } else if (event is EditMessageStarted) {
          try {
            emit(CreateMessageLoading());
            await repository.editMessage(
              id: event.id,
              title: event.title,
              fullText: event.description,
              canYouComment: event.canUserComment,
              isActive: event.isActive,
              startShowFa: event.startDate.formatCompactDate(),
              endShowFa: event.endDate.formatCompactDate(),
              personGroupId: event.groupId,
              eventId: event.eventId,
              categoryPersoneOfficelId: event.departmentId,
              image: event.image,
            );
            emit(const CreateMessageRequestSuccess());
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
              emit(CreateMessageError(exception: exception));
            }
          }
        }
      },
    );
  }
}
