import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'axes_controls_widget.dart';
import '../sample_feature/sample_item_list_view.dart';
import '../settings/settings_view.dart';
import '../common_widgets/nav_drawer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import 'dart:convert';
import 'video_feed_controls.dart';


class VideoFeed extends StatefulWidget {
  const VideoFeed({
    super.key
  });

  @override
  State<VideoFeed> createState() => _VideoFeedState();

  
}

class _VideoFeedState extends State<VideoFeed> {
  final TextEditingController _controller = TextEditingController();
  late IO.Socket socket;
  late Timer timer;
  Uint8List imageBytes = Uint8List(0);
  Image image = Image.network("https://docs.flutter.dev/assets/images/dash/dash-fainting.gif");

  @override
  void initState() {
    initSocket();
    super.initState();
  }

  void initSocket() {
    socket = IO.io('http://localhost:8080', <String, dynamic>{
    'autoConnect': false,
    'transports': ['websocket'],
  });
    socket.onConnect((_) {
      timer = Timer.periodic(new Duration(seconds: 1), (timer) {
        onTimer(timer);
      });
    });
    socket.on('video_feed_back', (data) => onVideoFeedBack(data));
    socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    return image;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onTimer(timer) {
    // Request new image
    socket.emit('video_feed');
  }

  void onVideoFeedBack(data) {    
    setState(() {
      // Remove the URI e.g. data:image/jpg;base64,...'
      imageBytes = base64.decode(data.split(',').last);
      image = Image.memory(imageBytes);
    });
 
  }
}


// Displays detailed information about a SampleItem.
class VideoFeedView extends StatelessWidget {
  const VideoFeedView({super.key});

  static const routeName = '/video_feed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Feed'),
        actions: [
          IconButton(
              icon: const Icon(Icons.camera_alt_outlined),
              onPressed: () {
                Navigator.restorablePushNamed(
                    context, SampleItemListView.routeName);
                takeSnapshot();
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
              child: VideoFeed()),
          AxesControlsWidget(),
          // NavRailExample(),
          
        ],
      ),
      drawer: NavDrawer(),
    );
  }

  void test() {
    print(121212);
  }

  void takeSnapshot() {
    print(121212);
  }

  
}
