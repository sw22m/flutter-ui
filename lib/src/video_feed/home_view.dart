import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'axes_controls_widget.dart';
import '../common_widgets/nav_drawer.dart';
import '../common_widgets/horizontalsplitview.dart';
import 'video_feed_sidebar.dart';
import '../snapshot/snapshot_view.dart';
import '../video_feed/video_player.dart';

class IncrementXIntent extends Intent { const IncrementXIntent(); }
class DecrementXIntent extends Intent { const DecrementXIntent(); }
class IncrementYIntent extends Intent { const IncrementYIntent(); }
class DecrementYIntent extends Intent { const DecrementYIntent(); }
class IncrementZIntent extends Intent { const IncrementZIntent(); }
class DecrementZIntent extends Intent { const DecrementZIntent(); }


class HomeView extends StatelessWidget {

  const HomeView({super.key});

  static const routeName = '/index';

  @override
  Widget build(BuildContext context) {

    VideoPlayer videoPlayer = const VideoPlayer();
    // final snapshotState = Provider.of<SnapshotProvider>(context);
    final positionState = Provider.of<PositionProvider>(context);
    // final videoFeedState = Provider.of<VideoFeedProvider>(context);

    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        // X-axis
        SingleActivator(LogicalKeyboardKey.keyD): IncrementXIntent(),
        SingleActivator(LogicalKeyboardKey.keyA): DecrementXIntent(),
        // Y-axis
        SingleActivator(LogicalKeyboardKey.keyW): IncrementYIntent(),
        SingleActivator(LogicalKeyboardKey.keyS): DecrementYIntent(),
        // Z-axis
        SingleActivator(LogicalKeyboardKey.keyE): IncrementZIntent(),
        SingleActivator(LogicalKeyboardKey.keyQ): DecrementZIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          IncrementXIntent: CallbackAction<IncrementXIntent>(
            onInvoke: (IncrementXIntent intent) {
              return positionState.increaseAxis("x");
            }
          ),
          DecrementXIntent: CallbackAction<DecrementXIntent>(
            onInvoke: (DecrementXIntent intent) => positionState.decreaseAxis("x")),
          IncrementYIntent: CallbackAction<IncrementYIntent>(
            onInvoke: (IncrementYIntent intent) => positionState.increaseAxis("y")),
          DecrementYIntent: CallbackAction<DecrementYIntent>(
            onInvoke: (DecrementYIntent intent) => positionState.decreaseAxis("y")),
          IncrementZIntent: CallbackAction<IncrementZIntent>(
            onInvoke: (IncrementZIntent intent) => positionState.increaseAxis("z")),
          DecrementZIntent: CallbackAction<DecrementZIntent>(
            onInvoke: (DecrementZIntent intent) => positionState.decreaseAxis("z"))
        }, 
        child: Focus(
          autofocus: true,
          child: Scaffold(
            // appBar: AppBar(
            //   title: const Text('Pyuscope'),
            //   actions: <Widget>[
            //     IconButton(
            //       icon: const Icon(Icons.camera_alt),
            //       tooltip: 'Take Snapshot',
            //       onPressed: () async {
            //           snapshotState.takeSnapshot();
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             const SnackBar(content: Text('Snapshot captured')));
            //       },
            //     )],
            // ),
            body: Stack(
              children: <Widget>[
                DefaultTabController(
                  length: 2, 
                  child: Column(
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(icon: Icon(Icons.mic_external_on), text: "Video Feed"),
                          Tab(icon: Icon(Icons.grid_view), text: "Snapshots"),
                      ]),
                      Expanded(
                        child: TabBarView(
                          children: [
                            HorizontalSplitView(left: videoPlayer,  right: const VideoFeedSidebar(), ratio: 0.8),
                            const SnapshotView(),
                          ]
                        )
                      )
                    ],
                  )
            )]),
            backgroundColor: Colors.black,
            drawer: const NavDrawer(),
            )
        )
      )
    );
  }
}
