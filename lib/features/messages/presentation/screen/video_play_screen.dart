import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  @override
  void initState() {
    loadVideoPlayer();
    super.initState();
  }

  void loadVideoPlayer() {
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl ?? ''),
    )..initialize().then((value) {
        setState(() {});
        videoPlayerController.play();
      });
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: Center(
          child: CustomVideoPlayer(
            customVideoPlayerController: _customVideoPlayerController,
          ),
        ),
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
