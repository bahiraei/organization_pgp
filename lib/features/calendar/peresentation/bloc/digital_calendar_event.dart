part of 'digital_calendar_bloc.dart';

abstract class DigitalCalendarEvent extends Equatable {
  const DigitalCalendarEvent();
}

class DigitalCalendarStarted extends DigitalCalendarEvent {
  @override
  List<Object?> get props => [];
}
