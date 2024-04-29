import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pyuscope_web/src/snapshot/snapshot_provider.dart';
import '../common_widgets/nav_drawer.dart';
import '../common_widgets/horizontalsplitview.dart';
import 'video_feed_sidebar.dart';
import '../video_feed/video_player.dart';


class VideoFeedView extends StatelessWidget {
  const VideoFeedView({super.key});

  static const routeName = '/video_feed';

  @override
  Widget build(BuildContext context) {
    VideoPlayer videoPlayer = const VideoPlayer();
    final snapshotState = Provider.of<SnapshotProvider>(context);
    return Focus(
        autofocus: true,
        child: Scaffold(
          body: Stack(children: <Widget>[
            snapshotState.selectedSnapshot == -1
                ? const Text("Live feed")
                : Text(snapshotState.getSelectedSnapshotName()),
            HorizontalSplitView(
                left: snapshotState.selectedSnapshot == -1
                    ? videoPlayer
                    : FittedBox(
                        fit: BoxFit.contain,
                        child: snapshotState.getSelectedSnapshotImage()),
                right: const VideoFeedSidebar(),
                ratio: 0.8),
          ]),
          backgroundColor: Colors.black,
          drawer: const NavDrawer(),
        ));
  }
}
