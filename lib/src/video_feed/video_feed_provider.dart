import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as socketio;
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';


class VideoFeedProvider with ChangeNotifier {

  late socketio.Socket socket;
  late Timer timer;
  String host = "http://localhost:8080";
  Uint8List imageBytes = Uint8List(0);
  Image image = const Image(image: AssetImage('assets/images/error.png'));

  VideoFeedProvider() {
    socket = getSocket();
    checkConnection();
    timer = Timer.periodic(const Duration(seconds: 1), (timer2) {
        // print("connected? ${socket.connected}, socket-id: ${socket.id}");
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
    // s.onConnect((data) => print("connected"));
    s.on('video_feed_back', (data) => onVideoFeedBack(data));
    return s;
  }

  bool connected() => socket.connected;

  void checkConnection() {
    if (socket.connected) {
      return;
    }
    socket.connect();
    return;
  }

  void onDisconnection() {
    // For manual disconnection required by webserver plugin
    socket.disconnect();
  }

  void onVideoFeedBack(data) {
    imageBytes = base64.decode(data.split(',').last);
    image = Image.memory(imageBytes, gaplessPlayback: true);
    notifyListeners();
  }

}