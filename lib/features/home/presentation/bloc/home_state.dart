part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeHappyBirthdayReadSuccess extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeDialogError extends HomeState {
  final AppException exception;

  const HomeDialogError({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}

class HomeDialogLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeError extends HomeState {
  final AppException exception;

  const HomeError({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}

class HomeSuccess extends HomeState {
  final HomeDataModel homeData;
  final ProfileData profileData;
  final SliderModel sliders;

  const HomeSuccess({
    required this.homeData,
    required this.profileData,
    required this.sliders,
  });

  @override
  List<Object?> get props => [
        homeData,
        profileData,
        sliders,
      ];
}
