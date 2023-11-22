import 'package:flutter/material.dart';
import 'package:pyuscope_web/src/snapshot/snapshot_provider.dart';
import 'axes_controls_widget.dart';
import '../common_widgets/nav_drawer.dart';
import '../common_widgets/horizontalsplitview.dart';
import 'video_feed_sidebar.dart';
import 'package:provider/provider.dart';
import 'video_feed_provider.dart';
import '../snapshot/snapshot_view.dart';
import 'package:flutter/services.dart';

class IncrementXIntent extends Intent { const IncrementXIntent(); }
class DecrementXIntent extends Intent { const DecrementXIntent(); }
class IncrementYIntent extends Intent { const IncrementYIntent(); }
class DecrementYIntent extends Intent { const DecrementYIntent(); }
class IncrementZIntent extends Intent { const IncrementZIntent(); }
class DecrementZIntent extends Intent { const DecrementZIntent(); }


class VideoFeedView extends StatelessWidget {
  const VideoFeedView({super.key});

  static const routeName = '/video_feed';

  @override
  Widget build(BuildContext context) {
    final videoFeedState = Provider.of<VideoFeedProvider>(context);
    final snapshotState = Provider.of<SnapshotProvider>(context);
    final positionState = Provider.of<PositionProvider>(context);
    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        // X-axis
        SingleActivator(LogicalKeyboardKey.arrowDown): IncrementXIntent(),
        SingleActivator(LogicalKeyboardKey.keyA): DecrementXIntent(),
        // Y-axis
        SingleActivator(LogicalKeyboardKey.keyW): IncrementYIntent(),
        SingleActivator(LogicalKeyboardKey.keyS): DecrementYIntent(),
        // Z-axis
        SingleActivator(LogicalKeyboardKey.keyQ): IncrementZIntent(),
        SingleActivator(LogicalKeyboardKey.keyE): DecrementZIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          IncrementXIntent: CallbackAction<IncrementXIntent>(
            onInvoke: (IncrementXIntent intent) => positionState.increaseAxis("x")),
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
            )
        )
      )
    );
  }
}
