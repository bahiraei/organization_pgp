part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState();
}

class SplashInitial extends SplashState {
  @override
  List<Object> get props => [];
}

class SplashLoading extends SplashState {
  @override
  List<Object?> get props => [];
}

class SplashSuccess extends SplashState {
  final ProfileModel profileData;
  final HomeDataModel homeData;
  final SliderModel sliders;

  const SplashSuccess({
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

class SplashError extends SplashState {
  final AppException exception;

  const SplashError({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}
