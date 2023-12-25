import 'package:equatable/equatable.dart';

class AudioPlayerParams extends Equatable {
  final String? album;
  final String title;
  final Uri uri;

  const AudioPlayerParams({
    required this.uri,
    required this.title,
    this.album,
  });

  @override
  List<Object> get props => [
        uri,
        title,
      ];
}
