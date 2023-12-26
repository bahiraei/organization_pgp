part of 'meeting_bloc.dart';

abstract class MeetingState extends Equatable {
  const MeetingState();
}

class MeetingInitial extends MeetingState {
  @override
  List<Object> get props => [];
}

class MeetingLoading extends MeetingState {
  @override
  List<Object?> get props => [];
}

class MeetingEmpty extends MeetingState {
  @override
  List<Object?> get props => [];
}

class MeetingError extends MeetingState {
  final AppException exception;

  const MeetingError({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}

class MeetingSuccess extends MeetingState {
  final List<MeetingModel> meetings;
  final bool moreData;

  const MeetingSuccess({
    required this.meetings,
    required this.moreData,
  });

  @override
  List<Object?> get props => [meetings, moreData];
}
