import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';                      // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart';
import 'package:pyuscope_web/src/video_feed/video_feed_view.dart';
import '../video_feed/video_feed_provider.dart';
import 'package:provider/provider.dart';


class VideoPlayer extends StatefulWidget {
  const VideoPlayer({Key? key}) : super(key: key);
  @override
  State<VideoPlayer> createState() => VideoPlayerState();
}

class VideoPlayerState extends State<VideoPlayer> {
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    MediaKit.ensureInitialized();
    super.initState();
    player.open(Media('rtsp://127.0.0.1:8554/feed'));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final videoState = Provider.of<VideoFeedProvider>(context);
    if (videoState.playing) {
      player.play();
    } else {
      player.stop();
    }
    return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 9.0 / 16.0,
          child: Video(controller: controller, controls: null), // hide controls
          // child: Video(controller: controller),
        ),
    );
  }
}