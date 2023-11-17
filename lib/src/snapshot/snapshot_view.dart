import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'axes_controls_widget.dart';
import '../sample_feature/sample_item_list_view.dart';
import '../settings/settings_view.dart';
import '../common_widgets/nav_drawer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import 'dart:convert';
// import 'video_feed_controls.dart';
import '../common_widgets/horizontalsplitview.dart';
// import 'video_feed_sidebar.dart';
import '../../config.dart' show apiHost;



class SnapshotImage extends StatelessWidget {

  const SnapshotImage({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Text('snapshot placeholder');
  }
}


Image _createSnapshotImage() {
  Uint8List imageBytes = Uint8List(0);
  Image image = Image(image: AssetImage('assets/images/error.png'));
  return image;
}
  

// Displays detailed information about a SampleItem.
class SnapshotView extends StatelessWidget {
  const SnapshotView({super.key});

  static const routeName = '/snapshot';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snapshot'),
        actions: [
          // IconButton(
          //     icon: const Icon(Icons.camera_alt_outlined),
          //     onPressed: () {
          //       Navigator.restorablePushNamed(
          //           context, SampleItemListView.routeName);
          //       takeSnapshot();
          //     }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          // Center(
          //     child: VideoFeed()),
          HorizontalSplitView(left: _createSnapshotImage(), right: Text('Snapshot Sidebar'), ratio: 0.8),
          // NavRailExample(),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 59, 59, 59),
      drawer: NavDrawer(),
    );
  }

  void test() {
    print(121212);
  }

  void takeSnapshot() {
    print(121212);
  }

  
}
