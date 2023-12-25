part of 'phone_bloc.dart';

abstract class PhoneState extends Equatable {
  const PhoneState();
}

class PhoneInitial extends PhoneState {
  @override
  List<Object> get props => [];
}

class PhoneLoading extends PhoneState {
  @override
  List<Object?> get props => [];
}

class PhoneEmpty extends PhoneState {
  @override
  List<Object?> get props => [];
}

class PhoneError extends PhoneState {
  final AppException exception;

  const PhoneError({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}

class PhoneSuccess extends PhoneState {
  final List<Phone> phones;

  const PhoneSuccess({
    required this.phones,
  });

  @override
  List<Object?> get props => [phones];
}
