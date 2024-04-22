import 'package:flutter/material.dart';
import 'package:pyuscope_web/src/snapshot/snapshot_provider.dart';
import '../common_widgets/horizontalsplitview.dart';
import 'package:provider/provider.dart';

class SnapshotThumbnail extends StatefulWidget {
  final String name;
  final Image image;
  final int index;
  final state;

  const SnapshotThumbnail(this.name, this.image, this.index, this.state,
      {super.key});

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
                  fontStyle: FontStyle.italic),
            ),
            AnimatedContainer(
              color: color,
              duration: const Duration(milliseconds: 50),
            )
          ],
        ));
  }
}

Column _createPhotoGrid(
    BuildContext context, List<SnapshotThumbnail> snapshots, int selected) {
  return Column(mainAxisSize: MainAxisSize.min, children: [
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
          return Card(
              // Check if the index is equal to the selected Card integer
              color: selected == index ? Colors.blue : Colors.black,
              child: snapshots[index]
          );
          // return snapshots[index];
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
      snapshots
          .add(SnapshotThumbnail(data.name, data.image, n++, snapshotState));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
              flex: 0,
              child: IconButton(
                iconSize: 32,
                icon: const Icon(Icons.camera_enhance),
                tooltip: 'Snapshot',
                onPressed: () async {
                  snapshotState.takeSnapshot();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: const Text('Snapshot captured'), 
                        backgroundColor: Colors.grey.shade400,
                        duration: const Duration(milliseconds: 40))
                        );
                },
              )),
          Expanded(
            flex: 1,
            child: Container(
                color: const Color.fromARGB(240, 24, 24, 24),
                alignment: Alignment.topCenter,
                child: _createPhotoGrid(context, snapshots, snapshotState.selectedSnapshot)),
          ),
          Expanded(
              flex: 0,
              child: IconButton(
                iconSize: 32,
                color: Colors.black38,
                icon: const Icon(Icons.delete),
                tooltip: 'Snapshot',
                onPressed: () async {
                  snapshotState.clearSnapshots();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: const Text('Snapshots cleared'),
                      backgroundColor: Colors.grey.shade400,
                      duration: const Duration(milliseconds: 40),
                      ));
                },
              )),
        ]);
  }
}
