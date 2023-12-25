part of 'fish_bloc.dart';

abstract class FishEvent extends Equatable {
  const FishEvent();
}

class FishStarted extends FishEvent {
  final String year;
  final String month;

  const FishStarted({
    required this.year,
    required this.month,
  });

  @override
  List<Object?> get props => [year, month];
}
