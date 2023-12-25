part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();
}

class MessageInitial extends MessageState {
  @override
  List<Object> get props => [];
}

class MessageLoading extends MessageState {
  @override
  List<Object?> get props => [];
}

class MessageRefreshing extends MessageState {
  @override
  List<Object?> get props => [];
}

class MessageEmpty extends MessageState {
  @override
  List<Object?> get props => [];
}

class MessageError extends MessageState {
  final AppException exception;

  const MessageError({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}

class MessageSuccess extends MessageState {
  final MessageModel data;
  final MessageEntity? redirectEntity;

  const MessageSuccess({
    required this.data,
    this.redirectEntity,
  });

  @override
  List<Object?> get props => [data];
}

class MessageCommentsError extends MessageState {
  final AppException exception;

  const MessageCommentsError({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}

class MessageCommentsSuccess extends MessageState {
  final CommentModel data;

  const MessageCommentsSuccess({
    required this.data,
  });

  @override
  List<Object?> get props => [data];
}

class MessageCommentsLoading extends MessageState {
  const MessageCommentsLoading();

  @override
  List<Object?> get props => [];
}

class MessageAddCommentSuccess extends MessageState {
  const MessageAddCommentSuccess();

  @override
  List<Object?> get props => [];
}

class MessageAddCommentError extends MessageState {
  final AppException exception;

  const MessageAddCommentError({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}

class MessageAddCommentLoading extends MessageState {
  const MessageAddCommentLoading();

  @override
  List<Object?> get props => [];
}

class CreateMessageSuccess extends MessageState {
  final InfoForeCreateMessageModel info;

  const CreateMessageSuccess({
    required this.info,
  });

  @override
  List<Object?> get props => [info];
}

class CreateMessageError extends MessageState {
  final AppException exception;

  const CreateMessageError({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}

class CreateMessageLoading extends MessageState {
  @override
  List<Object?> get props => [];
}

class CreateMessageRequestSuccess extends MessageState {
  const CreateMessageRequestSuccess();

  @override
  List<Object?> get props => [];
}

class CreateMessageRequestError extends MessageState {
  final AppException exception;

  const CreateMessageRequestError({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}

class CreateMessageRequestLoading extends MessageState {
  const CreateMessageRequestLoading();

  @override
  List<Object?> get props => [];
}

class MessageAdminSuccess extends MessageState {
  final List<AdminMessageModel> messages;
  final bool moreData;

  const MessageAdminSuccess({
    required this.messages,
    required this.moreData,
  });

  @override
  List<Object?> get props => [messages, moreData];
}

class MessageNotifError extends MessageState {
  final AppException exception;

  const MessageNotifError({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}

class MessageSendNotifLoading extends MessageState {
  const MessageSendNotifLoading();

  @override
  List<Object?> get props => [];
}

class MessageSendNotifSuccess extends MessageState {
  const MessageSendNotifSuccess();

  @override
  List<Object?> get props => [];
}
