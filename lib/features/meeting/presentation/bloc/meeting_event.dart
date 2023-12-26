part of 'meeting_bloc.dart';

abstract class MeetingEvent extends Equatable {
  const MeetingEvent();
}

class MeetingStarted extends MeetingEvent {
  final bool isScrolling;

  const MeetingStarted({
    required this.isScrolling,
  });

  @override
  List<Object?> get props => [isScrolling];
}
