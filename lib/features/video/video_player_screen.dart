import 'package:fl_video/fl_video.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late FlVideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlVideoPlayerController(
      allowedScreenSleep: false,
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(
          widget.videoUrl,
        ),
      ),
      autoPlay: true,
      looping: false,
      controls: MaterialControls(
        hideDuration: const Duration(seconds: 7),
        enablePlay: true,
        enableFullscreen: true,
        enableSpeed: true,
        enableVolume: true,
        enableSubtitle: false,
        enablePosition: true,
        enableBottomBar: true,
        onTap: (FlVideoTapEvent event, FlVideoPlayerController controller) {
          debugPrint(
            event.toString(),
          );
        },
        onDragProgress: (FlVideoDragProgressEvent event, Duration duration) {
          debugPrint('$event===$duration');
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton(
            onSelected: (item) => handleClick(item),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text('دانلود'),
              ),
            ],
          )
        ],
      ),
      body: FlVideoPlayer(
        controller: _controller,
      ),
    );
  }

  Future<void> handleClick(int item) async {
    switch (item) {
      case 0:
        final Uri video = Uri.parse(widget.videoUrl);
        await launchUrl(
          video,
          mode: LaunchMode.externalApplication,
        );
        break;
    }
  }
}
