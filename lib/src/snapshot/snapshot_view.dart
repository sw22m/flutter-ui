import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pyuscope_web/src/snapshot/snapshot_provider.dart';
import '../common_widgets/nav_drawer.dart';
import '../common_widgets/horizontalsplitview.dart';
import 'package:provider/provider.dart';
import '../video_feed/video_feed_provider.dart';


class SnapshotThumbnail extends StatefulWidget {

  final String name;
  final Image image;
  final int index;
  final state;
  
  const SnapshotThumbnail(this.name, this.image, this.index, this.state);

  @override
  _SnapshotThumbnailState createState() => _SnapshotThumbnailState();

}

class _SnapshotThumbnailState extends State<SnapshotThumbnail> {
  Color color = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (TapDownDetails details) {
          setState(() {
            color = Colors.black.withOpacity(0.2);
          });
        },
        onTapUp: (TapUpDetails details) {
          widget.state.selectedSnapshot = widget.index;
          setState(() {
            color = Colors.transparent;
          });
        },
        onTapCancel: () {
          setState(() {
            color = Colors.transparent;
          });
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            widget.image,
            Text(
                  "(${widget.index}) ${widget.name}",
                  style: const TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.black,
                      fontStyle: FontStyle.italic
                  ),
            ),
            AnimatedContainer(
                color: color,
                duration: const Duration(milliseconds: 50),
            )
          ],
        )
    );
  }
}


GridView _createPhotoGrid(List<SnapshotThumbnail> snapshots) {
  return GridView(
    scrollDirection: Axis.vertical,           //default
    reverse: false,                           //default
    controller: ScrollController(),
    primary: false,
    shrinkWrap: true,
    padding: const EdgeInsets.all(5.0),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5.0,
    ),
    addAutomaticKeepAlives: true,             //default
    addRepaintBoundaries: true,               //default
    addSemanticIndexes: true,                 //default
    semanticChildCount: 0,
    cacheExtent: 0.0,
    dragStartBehavior: DragStartBehavior.start,
    clipBehavior: Clip.hardEdge,
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,      
    children: snapshots
  );
}


class SnapshotView extends StatelessWidget {
  const SnapshotView({super.key});

  static const routeName = '/snapshot';

  @override
  Widget build(BuildContext context) {
    final snapshotState = Provider.of<SnapshotProvider>(context);
    final videoFeedState = Provider.of<VideoFeedProvider>(context);
    List<SnapshotThumbnail> snapshots = [];
    int n = 0;
    for (var data in snapshotState.snapshotList) {
      snapshots.add(SnapshotThumbnail(data.name, data.image, n++, snapshotState));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Snapshot'),
        actions: [
          IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Snapshots cleared')));
                snapshotState.clearSnapshots();
              }),
          IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Snapshot captured')));
                snapshotState.takeSnapshot(videoFeedState.image);
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(alignment: Alignment.topLeft,
            height: 30,
            child: snapshotState.selectedSnapshot != -1 ? 
              Text(snapshots[snapshotState.selectedSnapshot].name, 
              style: const TextStyle(color: Colors.white, backgroundColor: Colors.black))
              : const Center()),
          HorizontalSplitView(
            left: snapshotState.selectedSnapshot != -1 ? 
              snapshots[snapshotState.selectedSnapshot].image 
              : const Center(child: Text('No Snapshot Selected')), 
            right: Container(alignment: Alignment.topCenter, 
              child: Column(children: [
                videoFeedState.image,
                _createPhotoGrid(snapshots)
              ])
            ), 
            ratio: 0.8),
          // NavRailExample(),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 59, 59, 59),
      drawer: const NavDrawer(),
    );
  }
  
}
