part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthLoginStarted extends AuthEvent {
  final String nationalCode;
  final String? smsAutoFillCode;

  const AuthLoginStarted({
    required this.nationalCode,
    this.smsAutoFillCode,
  });

  @override
  List<Object?> get props => [
        nationalCode,
        smsAutoFillCode,
      ];
}

class AuthVerifyStarted extends AuthEvent {
  final String nationalCode;
  final String confirmCode;

  const AuthVerifyStarted({
    required this.nationalCode,
    required this.confirmCode,
  });

  @override
  List<Object?> get props => [
        nationalCode,
        confirmCode,
      ];
}
