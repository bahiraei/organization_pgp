part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class ProfileChangeAvatarStarted extends ProfileEvent {
  final String filename;
  final Uint8List image;

  const ProfileChangeAvatarStarted({
    required this.filename,
    required this.image,
  });

  @override
  List<Object?> get props => [
        filename,
        image,
      ];
}

class ProfileStarted extends ProfileEvent {
  const ProfileStarted();

  @override
  List<Object?> get props => [];
}
