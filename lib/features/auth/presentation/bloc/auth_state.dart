part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthError extends AuthState {
  final AppException exception;

  const AuthError({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}

class AuthSuccess extends AuthState {
  const AuthSuccess();

  @override
  List<Object?> get props => [];
}

class AuthVerifySuccess extends AuthState {
  final ProfileModel profileData;
  final HomeDataModel homeData;
  final SliderModel sliders;

  const AuthVerifySuccess({
    required this.profileData,
    required this.homeData,
    required this.sliders,
  });

  @override
  List<Object?> get props => [
        profileData,
        homeData,
        sliders,
      ];
}

class AuthVerifyNeedUpdate extends AuthState {
  final AppVersion appVersion;

  const AuthVerifyNeedUpdate({
    required this.appVersion,
  });

  @override
  List<Object?> get props => [appVersion];
}
