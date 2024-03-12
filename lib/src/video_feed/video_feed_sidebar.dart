import 'package:flutter/material.dart';
import 'axes_controls_widget.dart';
import 'package:pyuscope_web/src/snapshot/snapshot_provider.dart';
import 'package:provider/provider.dart';


class VideoFeedSidebar extends StatelessWidget {
  const VideoFeedSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final snapshotState = Provider.of<SnapshotProvider>(context);
    return Container(
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: DefaultTabController(
          length: 1,
          child: Column(
            children: [
              Expanded(
                  child: TabBarView(children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                          flex: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt),
                            tooltip: 'Take Snapshot (Direct from player)',
                            onPressed: () async {
                              snapshotState.takeSnapshot();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Snapshot captured')));
                            },
                          )),
                      Expanded(
                          flex: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_enhance),
                            tooltip: 'Take Snapshot 2 (GET Image Request)',
                            onPressed: () async {
                              snapshotState.takeSnapshot2();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Snapshot captured')));
                            },
                          )),
                      const Expanded(flex: 1, child: AxesControlsWidget())
                    ])
              ])),
            ],
          ),
        ));
  }
}
