part of 'hokm_bloc.dart';

abstract class HokmEvent extends Equatable {
  const HokmEvent();
}

class HokmStarted extends HokmEvent {
  @override
  List<Object?> get props => [];
}
