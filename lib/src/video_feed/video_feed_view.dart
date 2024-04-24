import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pyuscope_web/src/snapshot/snapshot_provider.dart';
import 'axes_controls_widget.dart';
import '../common_widgets/nav_drawer.dart';
import '../common_widgets/horizontalsplitview.dart';
import 'video_feed_sidebar.dart';
import '../video_feed/video_player.dart';

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

    VideoPlayer videoPlayer = const VideoPlayer();
    final snapshotState = Provider.of<SnapshotProvider>(context);
    final positionState = Provider.of<PositionProvider>(context);

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
          autofocus: true,
          child: Scaffold(
            body: Stack(
              children: <Widget>[
                snapshotState.selectedSnapshot == -1 ?
                const Text("Live feed"): Text(snapshotState.getSelectedSnapshotName()),
                HorizontalSplitView(
                  left: snapshotState.selectedSnapshot == -1 
                    ? videoPlayer: FittedBox(fit: BoxFit.contain, child: snapshotState.getSelectedSnapshotImage()),
                  right: const VideoFeedSidebar(), ratio: 0.8),
              ]
            ),
            backgroundColor: Colors.black,
            drawer: const NavDrawer(),
            )
        )
      )
    );
  }
}
