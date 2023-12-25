part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
}

class MessageStarted extends MessageEvent {
  final bool isRefreshing;
  final String? id;

  const MessageStarted({
    required this.isRefreshing,
    this.id,
  });

  @override
  List<Object?> get props => [
        isRefreshing,
        id,
      ];
}

class MessageCommentsStarted extends MessageEvent {
  final String id;

  const MessageCommentsStarted({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

class MessageAddCommentStarted extends MessageEvent {
  final String id;
  final String comment;

  const MessageAddCommentStarted({
    required this.id,
    required this.comment,
  });

  @override
  List<Object?> get props => [id, comment];
}

class CreateMessageStarted extends MessageEvent {
  @override
  List<Object?> get props => [];
}

class CreateMessageRequestStarted extends MessageEvent {
  final String title;
  final String? description;
  final bool canUserComment;
  final bool isActive;
  final Jalali startDate;
  final Jalali endDate;
  final String? eventId;
  final int? groupId;
  final String? departmentId;
  final XFile? image;

  const CreateMessageRequestStarted({
    required this.title,
    this.description,
    required this.canUserComment,
    required this.isActive,
    required this.startDate,
    required this.endDate,
    this.eventId,
    this.groupId,
    this.departmentId,
    this.image,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        canUserComment,
        isActive,
        startDate,
        endDate,
        image,
      ];
}

class MessageAdminStarted extends MessageEvent {
  final bool isScrolling;
  final String? searchText;

  const MessageAdminStarted({
    required this.isScrolling,
    this.searchText,
  });

  @override
  List<Object?> get props => [isScrolling, searchText];
}

class MessageSendNotifStarted extends MessageEvent {
  final String messageId;
  const MessageSendNotifStarted({
    required this.messageId,
  });

  @override
  List<Object?> get props => [messageId];
}

class EditMessageStarted extends MessageEvent {
  final String id;
  final String title;
  final String? description;
  final bool canUserComment;
  final bool isActive;
  final Jalali startDate;
  final Jalali endDate;
  final String? eventId;
  final int? groupId;
  final String? departmentId;
  final XFile? image;

  const EditMessageStarted({
    required this.id,
    required this.title,
    this.description,
    required this.canUserComment,
    required this.isActive,
    required this.startDate,
    required this.endDate,
    this.eventId,
    this.groupId,
    this.departmentId,
    this.image,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        canUserComment,
        isActive,
        startDate,
        endDate,
        image,
      ];
}
