part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileChangeAvatarSuccess extends ProfileState {
  const ProfileChangeAvatarSuccess();

  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileError extends ProfileState {
  final AppException exception;

  const ProfileError({
    required this.exception,
  });

  @override
  List<Object> get props => [exception];
}

class ProfileSuccess extends ProfileState {
  final ProfileModel profile;

  const ProfileSuccess({
    required this.profile,
  });

  @override
  List<Object> get props => [profile];
}
