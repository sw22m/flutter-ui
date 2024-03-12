import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';                      // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart';
import '../video_feed/video_feed_provider.dart';
import 'package:provider/provider.dart';
import '../snapshot/snapshot_provider.dart';


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

  void takeSnapshot(snapshotState) async {
    final Uint8List? bytes = await player.screenshot();
    if (bytes != null) {
      snapshotState.addImageToSnapshots(Image.memory(bytes));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final videoState = Provider.of<VideoFeedProvider>(context);
    final snapshotState = Provider.of<SnapshotProvider>(context);
    if (videoState.playing) {
      player.play();
    } else {
      player.stop();
    }
    if (snapshotState.snapshotRequested) {
      snapshotState.snapshotRequested = false;
      takeSnapshot(snapshotState);
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