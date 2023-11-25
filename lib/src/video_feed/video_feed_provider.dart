import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as socketio;
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:rxdart/rxdart.dart';

class StreamSocket {
  final _socketResponse = BehaviorSubject<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}


class VideoFeedProvider with ChangeNotifier {

  late socketio.Socket socket;
  late StreamSocket streamSocket;
  late Timer timer;
  String host = "http://localhost:8080";
  Uint8List imageBytes = Uint8List(0);
  Image image = const Image(image: AssetImage('assets/images/error.png'));
  bool requestImage = false;

  VideoFeedProvider() {
    socket = getSocket();
    checkConnection();
    timer = Timer.periodic(const Duration(seconds: 1), (timer2) {
        checkConnection();
    });
  }

  socketio.Socket getSocket() {
    socketio.Socket s = socketio.io(host, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
      },
    );
    s.onDisconnect((data) => onDisconnection());
    s.on('video_feed_back', (data) => onVideoFeedBack(data));
    return s;
  }

  bool connected() => socket.connected;

  void checkConnection() {
    if (socket.connected) {
      return;
    }
    socket.connect();
    streamSocket = StreamSocket();
    return;
  }

  void onDisconnection() {
    // For manual disconnection required by webserver plugin
    socket.disconnect();
  }

  void onVideoFeedBack(data) {
    imageBytes = base64.decode(data);
    streamSocket.addResponse(data);
  }

  Image requestSnapshot() {
    // TODO: can be replaced by API request
    return image = Image.memory(imageBytes);//, gaplessPlayback: true);
  }

}