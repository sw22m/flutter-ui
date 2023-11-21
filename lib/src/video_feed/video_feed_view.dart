import 'package:flutter/material.dart';
import 'package:pyuscope_web/src/snapshot/snapshot_provider.dart';
import 'axes_controls_widget.dart';
import '../common_widgets/nav_drawer.dart';
import '../common_widgets/horizontalsplitview.dart';
import 'video_feed_sidebar.dart';
import 'package:provider/provider.dart';
import 'video_feed_provider.dart';
import '../snapshot/snapshot_view.dart';
import '../util.dart'; 

class VideoFeedView extends StatelessWidget {
  const VideoFeedView({super.key});

  static const routeName = '/video_feed';

  @override
  Widget build(BuildContext context) {
    final videoFeedState = Provider.of<VideoFeedProvider>(context);
    final snapshotState = Provider.of<SnapshotProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PositionProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Video Feed'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.camera_alt),
              tooltip: 'Take Snapshot',
              onPressed: () {
                  snapshotState.takeSnapshot(videoFeedState.image);
                  Navigator.pushNamed(context, SnapshotView.routeName);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Snapshot captured')));
              },
            )],
        ),
        body: Stack(
          children: <Widget>[
            HorizontalSplitView(left: videoFeedState.image, right: const VideoFeedSidebar(), ratio: 0.8)
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 59, 59, 59),
        drawer: const NavDrawer(),
      ));
  }
}
