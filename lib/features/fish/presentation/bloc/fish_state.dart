part of 'fish_bloc.dart';

abstract class FishState extends Equatable {
  const FishState();
}

class FishInitial extends FishState {
  @override
  List<Object> get props => [];
}

class FishLoading extends FishState {
  @override
  List<Object?> get props => [];
}

class FishError extends FishState {
  final AppException exception;

  const FishError({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}

class FishEmpty extends FishState {
  @override
  List<Object?> get props => [];
}

class FishSuccess extends FishState {
  final String year;
  final String month;
  final Uint8List file;

  const FishSuccess({
    required this.year,
    required this.month,
    required this.file,
  });

  @override
  List<Object?> get props => [
        year,
        month,
        file,
      ];
}
