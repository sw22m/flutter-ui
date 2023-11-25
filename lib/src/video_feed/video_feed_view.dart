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
import 'dart:convert';

class IncrementXIntent extends Intent { const IncrementXIntent(); }
class DecrementXIntent extends Intent { const DecrementXIntent(); }
class IncrementYIntent extends Intent { const IncrementYIntent(); }
class DecrementYIntent extends Intent { const DecrementYIntent(); }
class IncrementZIntent extends Intent { const IncrementZIntent(); }
class DecrementZIntent extends Intent { const DecrementZIntent(); }


Widget createVideoFeedWidget(BuildContext context) {
  final videoFeedState = Provider.of<VideoFeedProvider>(context);
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Center(
      child: 
        videoFeedState.connected()
          ? StreamBuilder(
              stream: videoFeedState.streamSocket.getResponse,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return const Center(
                    child: Text("Connection Closed !"),
                  );
                }
                return Image.memory(
                  Uint8List.fromList(base64Decode((snapshot.data.toString()))),
                  gaplessPlayback: true,
                );
              },
            )
          : const Text("Initiate Connection")
      ),
    );
  }


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
            appBar: AppBar(
              title: const Text('Video Feed'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  tooltip: 'Take Snapshot',
                  onPressed: () async {
                      snapshotState.takeSnapshot(videoFeedState.requestSnapshot());
                      Navigator.pushNamed(context, SnapshotView.routeName);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Snapshot captured')));
                  },
                )],
            ),
            body: Stack(
              children: <Widget>[
                HorizontalSplitView(left: createVideoFeedWidget(context), right: const VideoFeedSidebar(), ratio: 0.8)
              ],
            ),
            backgroundColor: Colors.black,
            drawer: const NavDrawer(),
            )
        )
      )
    );
  }
}
