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
import '../common_widgets/horizontalsplitview.dart';
import 'video_feed_sidebar.dart';
import '../../config.dart' show apiHost;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

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
  // Image image = Image.network("https://docs.flutter.dev/assets/images/dash/dash-fainting.gif");
  Image image = Image(image: AssetImage('assets/images/error.png'));
  @override
  void initState() {
    initSocket();
    super.initState();
  }

  void initSocket() {
    socket = IO.io(dotenv.get('API_HOST', fallback: "http://localhost:8080"), <String, dynamic>{
    'autoConnect': false,
    'transports': ['websocket'],
  });
    socket.onConnect((_) {
      socket.emit('video_feed');
      // timer = Timer.periodic(new Duration(milliseconds: 1000), (timer) {
      //   onTimer(timer);
      // });
    });
    socket.on('video_feed_back', (data) => onVideoFeedBack(data));
    socket.connect();
    // socket.disconnect();
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
      image = Image.memory(imageBytes, gaplessPlayback: true);
    });
  }
}


// Displays detailed information about a SampleItem.
class VideoFeedView extends StatelessWidget {
  const VideoFeedView({super.key});

  static const routeName = '/video_feed';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PositionProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Video Feed'),
        ),
        body: Stack(
          children: <Widget>[
            HorizontalSplitView(left: VideoFeed(), right: VideoFeedSidebar(), ratio: 0.8),
            // NavRailExample(),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 59, 59, 59),
        drawer: NavDrawer(),
      ));
  }

  void test() {
    print(121212);
  }

  void takeSnapshot() {
    print(121212);
  }

  
}
