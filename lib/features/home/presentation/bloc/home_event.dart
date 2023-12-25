part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeHappyBirthdayRead extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {
  final HomeDataModel? homData;
  final ProfileModel? profileData;
  final SliderModel? sliders;
  final bool isRefreshing;

  const HomeStarted({
    this.homData,
    this.profileData,
    this.sliders,
    this.isRefreshing = false,
  });

  @override
  List<Object?> get props => [homData, profileData, sliders, isRefreshing];
}
