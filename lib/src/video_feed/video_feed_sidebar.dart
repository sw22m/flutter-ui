import 'package:flutter/material.dart';
import 'axes_controls_widget.dart';
import 'package:provider/provider.dart';
import '../snapshot/snapshot_view.dart';

class VideoFeedSidebar extends StatelessWidget {
  const VideoFeedSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final positionState = Provider.of<PositionProvider>(context);
    bool jogging = true;
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
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(tabs: [
                Tab(icon: Icon(Icons.mic_external_on), text: "Control"),
                Tab(icon: Icon(Icons.grid_view), text: "Snapshots"),
              ]),
              Expanded(
                  child: TabBarView(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          flex: 0,
                          child: MaterialButton(
                            color: positionState.jogging ? Colors.yellow: Colors.grey,
                            height: 64,
                            onPressed: () {
                              positionState.toggleJogging();
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.run_circle_sharp, size: 32),
                                SizedBox(width: 8),
                                Text('Jog'),
                              ],
                            ),
                          ),
                        ),
                      const Expanded(flex: 1, child: AxesControlsWidget()),  
                      ]),
                  const SnapshotView(),
                ],
              )),
            ],
          ),
        ));
  }
}
