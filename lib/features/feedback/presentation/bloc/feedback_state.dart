part of 'feedback_bloc.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();
}

class FeedbackInitial extends FeedbackState {
  @override
  List<Object> get props => [];
}

class FeedbackLoading extends FeedbackState {
  @override
  List<Object?> get props => [];
}

class FeedbackEmpty extends FeedbackState {
  @override
  List<Object?> get props => [];
}

class FeedbackError extends FeedbackState {
  final AppException exception;

  const FeedbackError({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}

class FeedbackUserSuccess extends FeedbackState {
  final List<FeedbackModel> feedbacks;

  const FeedbackUserSuccess({
    required this.feedbacks,
  });

  @override
  List<Object?> get props => [feedbacks];
}

class FeedbackApplyUserLoading extends FeedbackState {
  @override
  List<Object?> get props => [];
}

class FeedbackApplyUserError extends FeedbackState {
  final AppException exception;

  const FeedbackApplyUserError({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}

class FeedbackApplyUserSuccess extends FeedbackState {
  const FeedbackApplyUserSuccess();

  @override
  List<Object?> get props => [];
}

class FeedbackAdminSuccess extends FeedbackState {
  final List<AdminFeedbackModel> feedbacks;
  final bool moreData;

  const FeedbackAdminSuccess({
    required this.feedbacks,
    required this.moreData,
  });

  @override
  List<Object?> get props => [feedbacks, moreData];
}

class FeedbackApplyAdminSuccess extends FeedbackState {
  const FeedbackApplyAdminSuccess();

  @override
  List<Object?> get props => [];
}
