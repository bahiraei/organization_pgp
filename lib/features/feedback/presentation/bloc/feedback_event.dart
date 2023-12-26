part of 'feedback_bloc.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();
}

class FeedbackUserStarted extends FeedbackEvent {
  @override
  List<Object?> get props => [];
}

class FeedbackApplyUserStarted extends FeedbackEvent {
  final String title;
  final String description;
  final int type;
  final List<PlatformFile> files;

  const FeedbackApplyUserStarted({
    required this.title,
    required this.description,
    required this.type,
    required this.files,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        type,
        files,
      ];
}

class FeedbackAdminStarted extends FeedbackEvent {
  final bool isScrolling;

  const FeedbackAdminStarted({
    required this.isScrolling,
  });

  @override
  List<Object?> get props => [isScrolling];
}

class FeedbackApplyAdminStarted extends FeedbackEvent {
  final String text;
  final String feedbackId;

  const FeedbackApplyAdminStarted({
    required this.text,
    required this.feedbackId,
  });

  @override
  List<Object?> get props => [text, feedbackId];
}
