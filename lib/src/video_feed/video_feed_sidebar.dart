import 'package:flutter/material.dart';
import 'axes_controls_widget.dart';
import 'package:pyuscope_web/src/snapshot/snapshot_provider.dart';
import 'package:provider/provider.dart';
import '../snapshot/snapshot_view.dart';


class VideoFeedSidebar extends StatelessWidget {
  const VideoFeedSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final snapshotState = Provider.of<SnapshotProvider>(context);
    return Container(
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          boxShadow: const [
            BoxShadow(
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),

        //   children: <Widget>[
            //     DefaultTabController(
            //       length: 2, 
            //       child: Column(
            //         children: [
            //           const TabBar(
            //             tabs: [
            //               Tab(icon: Icon(Icons.mic_external_on), text: "Video Feed"),
            //               Tab(icon: Icon(Icons.grid_view), text: "Snapshots"),
            //           ]),
            //           Expanded(
            //             child: TabBarView(
            //               children: [
            //                 HorizontalSplitView(left: videoPlayer,  right: const VideoFeedSidebar(), ratio: 0.8),
            //                 const SnapshotView(),
            //               ]
            //             )
            //           )
            //         ],
            //       )
            // )]
        child: const DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.mic_external_on), text: "Control"),
                  Tab(icon: Icon(Icons.grid_view), text: "Snapshots"),
              ]),
              Expanded(
                  child: TabBarView(children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(flex: 1, child: AxesControlsWidget())
                    ]), 
              SnapshotView(),
              ],
              )),
            ],
          ),
        ));
  }
}
