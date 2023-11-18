import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as socketio;
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';


class VideoFeedProvider with ChangeNotifier {

  late Timer timer;
  String host = "http://localhost:8080";
  Uint8List imageBytes = Uint8List(0);
  Image image = const Image(image: AssetImage('assets/images/error.png'));
  bool isConnected = false;

  VideoFeedProvider() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        checkConnection();
      }
    );
  }

  void checkConnection() {
    
    socketio.Socket socket = socketio.io(host, <String, dynamic>{
    'autoConnect': false,
    'transports': ['websocket'],
    });
    // TODO
    // print('VideoFeedProvider: checking connection');
    // print(socket.connected);
    // if (socket.connected) {
    //   return;
    // }
    socket.onConnect((_) {
      print('socket connected');
      isConnected = true;
      notifyListeners();
    });
    socket.onDisconnect((data) {
      isConnected = false; 
      notifyListeners();
      print('reconnection attempt'); // TODO
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (socket.connected) {
          print('reconnected'); 
          isConnected = true;
          timer.cancel();
        }
        socket.connect();
      });
    });
    socket.on('video_feed_back', (data) => onVideoFeedBack(data));
    socket.on('client_connected', (data) {
      print('client connected');
      isConnected = true; 
      notifyListeners(); 
    });
    socket.connect();
  }

  void onVideoFeedBack(data) {
    imageBytes = base64.decode(data.split(',').last);
    image = Image.memory(imageBytes, gaplessPlayback: true);
    notifyListeners();
  }

}