part of 'digital_calendar_bloc.dart';

abstract class DigitalCalendarState extends Equatable {
  const DigitalCalendarState();
}

class DigitalCalendarInitial extends DigitalCalendarState {
  @override
  List<Object> get props => [];
}

class DigitalCalendarSuccess extends DigitalCalendarState {
  final List<DigitalCalendarModel> digitalCalendars;

  const DigitalCalendarSuccess({
    required this.digitalCalendars,
  });

  @override
  List<Object?> get props => [digitalCalendars];
}

class DigitalCalendarLoading extends DigitalCalendarState {
  @override
  List<Object?> get props => [];
}

class DigitalCalendarError extends DigitalCalendarState {
  final AppException exception;

  const DigitalCalendarError({
    required this.exception,
  });

  @override
  List<Object> get props => [exception];
}

class DigitalCalendarEmpty extends DigitalCalendarState {
  @override
  List<Object?> get props => [];
}
