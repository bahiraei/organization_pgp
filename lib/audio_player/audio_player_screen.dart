import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../core/utils/helper.dart';
import 'domain/params/audio_player_params.dart';

class AudioPlayerScreen extends StatefulWidget {
  final AudioPlayerParams audioPlayerParams;

  const AudioPlayerScreen({
    super.key,
    required this.audioPlayerParams,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen>
    with WidgetsBindingObserver {
  final AudioPlayer player = AudioPlayer();
  bool _isPlaying = false;
  bool _isCompleted = false;
  Duration? _duration = Duration.zero;
  Duration? _position = Duration.zero;

  @override
  void initState() {
    try {
      player
          .setAudioSource(
        AudioSource.uri(
          widget.audioPlayerParams.uri,
          tag: MediaItem(
            // Specify a unique ID for each media item:
            id: '1',
            // Metadata to display in the notification:
            album: widget.audioPlayerParams.album,
            title: widget.audioPlayerParams.title,
            artUri: widget.audioPlayerParams.uri,
          ),
        ),
      )
          .then((value) {
        player.play();
        setState(() {});
      });
    } on PlayerException catch (e) {
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      // Linux/Windows: maps to PlayerErrorCode.index
      Helper.log("Error code: ${e.code}");
      // iOS/macOS: maps to NSError.localizedDescription
      // Android: maps to ExoPlaybackException.getMessage()
      // Web/Linux: a generic message
      // Windows: MediaPlayerError.message
      Helper.log("Error message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      Helper.log("Connection aborted: ${e.message}");
    } catch (e) {
      // Fallback for all other errors
      Helper.log('An error occurred: $e');
    }

    // Catching errors during playback (e.g. lost network connection)
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace st) {
      if (e is PlayerException) {
        Helper.log('Error code: ${e.code}');
        Helper.log('Error message: ${e.message}');
      } else {
        Helper.log('An error occurred: $e');
      }
    });

    player.playerStateStream.listen((event) async {
      setState(() {
        _isPlaying = event.playing;
      });
      if (event.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
          _isCompleted = true;
          player.stop();
        });
      }
    });
    // Listen audio duration
    player.durationStream.listen(
      (newDuration) {
        setState(() {
          _duration = newDuration;
        });
      },
    );

    // Listen audio position
    player.positionStream.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      player.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('پخش کننده صدا'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Slider(
            value: (_position?.inMilliseconds.toDouble() ?? 0) >
                    (_duration?.inMilliseconds.toDouble() ?? 0)
                ? _duration?.inMilliseconds.toDouble() ?? 0
                : _position?.inMilliseconds.toDouble() ?? 0,
            max: _duration?.inMilliseconds.toDouble() ?? 0,
            onChangeStart: (value) {
              player.pause();
            },
            onChangeEnd: (value) {
              player.play();
            },
            onChanged: (value) {
              Helper.log(value.toInt().toString());
              if (_duration != null) {
                if (_duration!.inMilliseconds.toDouble() > value) {
                  player.seek(
                    Duration(seconds: (value / 1000).roundToDouble().round()),
                  );
                }
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (player.playing)
                  Text(
                    _position?.toMinutesSeconds() ?? '00:00',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                Text(
                  _duration?.toMinutesSeconds() ?? '00:00',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                color: Colors.blue,
                iconSize: 54,
                onPressed: () async {
                  if (!_isPlaying) {
                    setState(() {
                      _isPlaying = true;
                      _isCompleted = false;
                    });
                    await player.play();
                    if (_isCompleted) {
                      await player.seek(const Duration(seconds: 0));
                      await player.pause();
                    }
                  }
                  if (_isPlaying) {
                    setState(() {
                      _isPlaying = false;
                    });
                    await player.pause();
                  }
                },
                icon: player.playing
                    ? const Icon(
                        Icons.pause_circle_filled,
                      )
                    : const Icon(
                        Icons.play_circle_fill,
                      ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

T? ambiguate<T>(T? value) => value;

extension DurationExtention on Duration {
  String toMinutesSeconds() {
    String toDigitMinutes = toTowDigits(inMinutes.remainder(60));
    String toDigitSeconds = toTowDigits(inSeconds.remainder(60));

    return "$toDigitMinutes:$toDigitSeconds";
  }

  String toHourMinutesSeconds() {
    String toDigitMinutes = toTowDigits(inMinutes.remainder(60));
    String toDigitSeconds = toTowDigits(inSeconds.remainder(60));

    return "${toTowDigits(inHours)};$toDigitMinutes:$toDigitSeconds";
  }

  String toTowDigits(int n) {
    if (n >= 10) return "$n";

    return "0$n";
  }
}

class AudioPlayerBottomSheet extends StatefulWidget {
  final AudioPlayerParams audioPlayerParams;

  const AudioPlayerBottomSheet({
    super.key,
    required this.audioPlayerParams,
  });

  @override
  State<AudioPlayerBottomSheet> createState() => _AudioPlayerBottomSheetState();
}

class _AudioPlayerBottomSheetState extends State<AudioPlayerBottomSheet>
    with WidgetsBindingObserver {
  final AudioPlayer player = AudioPlayer();
  bool _isPlaying = false;
  bool _isCompleted = false;
  Duration? _duration = Duration.zero;
  Duration? _position = Duration.zero;

  bool isBackTap = false;

  @override
  void initState() {
    try {
      player
          .setAudioSource(
        AudioSource.uri(
          widget.audioPlayerParams.uri,
          tag: MediaItem(
            // Specify a unique ID for each media item:
            id: '1',
            // Metadata to display in the notification:
            album: widget.audioPlayerParams.album,
            title: widget.audioPlayerParams.title,
            artUri: widget.audioPlayerParams.uri,
          ),
        ),
      )
          .then((value) {
        player.play();
        setState(() {});
      });
    } on PlayerException catch (e) {
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      // Linux/Windows: maps to PlayerErrorCode.index
      Helper.log("Error code: ${e.code}");
      // iOS/macOS: maps to NSError.localizedDescription
      // Android: maps to ExoPlaybackException.getMessage()
      // Web/Linux: a generic message
      // Windows: MediaPlayerError.message
      Helper.log("Error message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      Helper.log("Connection aborted: ${e.message}");
    } catch (e) {
      // Fallback for all other errors
      Helper.log('An error occurred: $e');
    }

    // Catching errors during playback (e.g. lost network connection)
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace st) {
      if (e is PlayerException) {
        Helper.log('Error code: ${e.code}');
        Helper.log('Error message: ${e.message}');
      } else {
        Helper.log('An error occurred: $e');
      }
    });

    player.playerStateStream.listen((event) async {
      setState(() {
        _isPlaying = event.playing;
      });
      if (event.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
          _isCompleted = true;
          player.stop();
        });
      }
    });
    // Listen audio duration
    player.durationStream.listen(
      (newDuration) {
        setState(() {
          _duration = newDuration;
        });
      },
    );

    // Listen audio position
    player.positionStream.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      if (player.playing) {
        player.pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!isBackTap) {
          setState(() {
            isBackTap = true;
          });
          Navigator.pop(context);
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.65,
        maxChildSize: 1,
        minChildSize: 0.5,
        builder: (BuildContext context, ScrollController scrollController) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /* Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 24),
                            Container(
                              height: 4,
                              width: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xffdcdcdc),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ],
                        ),*/
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      color: Colors.blue,
                                      iconSize: 54,
                                      onPressed: () async {
                                        if (!_isPlaying) {
                                          setState(() {
                                            _isPlaying = true;
                                            _isCompleted = false;
                                          });
                                          await player.play();
                                          if (_isCompleted) {
                                            await player.seek(
                                                const Duration(seconds: 0));
                                            await player.pause();
                                          }
                                        }
                                        if (_isPlaying) {
                                          setState(() {
                                            _isPlaying = false;
                                          });
                                          await player.pause();
                                        }
                                      },
                                      icon: player.playing
                                          ? const Icon(
                                              Icons.pause_circle_filled,
                                            )
                                          : const Icon(
                                              Icons.play_circle_fill,
                                            ),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Slider(
                                        value: (_position?.inMilliseconds
                                                        .toDouble() ??
                                                    0) >
                                                (_duration?.inMilliseconds
                                                        .toDouble() ??
                                                    0)
                                            ? _duration?.inMilliseconds
                                                    .toDouble() ??
                                                0
                                            : _position?.inMilliseconds
                                                    .toDouble() ??
                                                0,
                                        max: _duration?.inMilliseconds
                                                .toDouble() ??
                                            0,
                                        onChangeStart: (value) {
                                          player.pause();
                                        },
                                        onChangeEnd: (value) {
                                          player.play();
                                        },
                                        onChanged: (value) {
                                          Helper.log(value.toInt().toString());
                                          if (_duration != null) {
                                            if (_duration!.inMilliseconds
                                                    .toDouble() >
                                                value) {
                                              player.seek(
                                                Duration(
                                                    seconds: (value / 1000)
                                                        .roundToDouble()
                                                        .round()),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _position?.toMinutesSeconds() ??
                                                  '00:00',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              _duration?.toMinutesSeconds() ??
                                                  '00:00',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
