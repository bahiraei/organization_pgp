part of 'hokm_bloc.dart';

abstract class HokmState extends Equatable {
  const HokmState();
}

class HokmInitial extends HokmState {
  @override
  List<Object> get props => [];
}

class HokmLoading extends HokmState {
  @override
  List<Object?> get props => [];
}

class HokmEmpty extends HokmState {
  @override
  List<Object?> get props => [];
}

class HokmError extends HokmState {
  final AppException exception;

  const HokmError({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}

class HokmSuccess extends HokmState {
  final Uint8List image;

  const HokmSuccess({
    required this.image,
  });

  @override
  List<Object?> get props => [image];
}
