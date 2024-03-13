import 'package:flutter/material.dart';
import 'package:pyuscope_web/src/snapshot/snapshot_provider.dart';
import '../common_widgets/horizontalsplitview.dart';
import 'package:provider/provider.dart';


class SnapshotThumbnail extends StatefulWidget {

  final String name;
  final Image image;
  final int index;
  final dynamic state;
  
  const SnapshotThumbnail(this.name, this.image, this.index, this.state, {super.key});

  @override
  SnapshotThumbnailState createState() => SnapshotThumbnailState();

}

class SnapshotThumbnailState extends State<SnapshotThumbnail> {
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


Column _createPhotoGrid(BuildContext context, List<SnapshotThumbnail> snapshots) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemCount: snapshots.length,
            itemBuilder: (BuildContext context, int index) {
              return snapshots[index];
            },
          ),
        ),
    ]);
}

class SnapshotView extends StatelessWidget {
  const SnapshotView({super.key});

  static const routeName = '/snapshot';

  @override
  Widget build(BuildContext context) {
    final snapshotState = Provider.of<SnapshotProvider>(context);
    List<SnapshotThumbnail> snapshots = [];
    int n = 0;
    for (var data in snapshotState.snapshotList) {
      snapshots.add(SnapshotThumbnail(data.name, data.image, n++, snapshotState));
    }
    return Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            height: 30,
            child: snapshotState.selectedSnapshot != -1 ? 
              Text(snapshots[snapshotState.selectedSnapshot].name, 
              style: const TextStyle(color: Colors.white, backgroundColor: Colors.black))
              : const Center()),
          HorizontalSplitView(
            left: snapshotState.selectedSnapshot != -1 ? 
              snapshots[snapshotState.selectedSnapshot].image 
              : const Center(child: Text('No Snapshot Selected')), 
            right: Container(
              color: const Color.fromARGB(240, 24, 24, 24),
              alignment: Alignment.topCenter,
              child: _createPhotoGrid(context, snapshots)
            ), 
            ratio: 0.8),
          // NavRailExample(),
        ],
      );
  }
}
