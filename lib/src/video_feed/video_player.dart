import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
// import '../video_feed/video_feed_provider.dart';
// import 'package:provider/provider.dart';
// import '../snapshot/snapshot_provider.dart';
// import 'package:web_socket_channel/status.dart' as status;

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({Key? key}) : super(key: key);

  @override
  State<VideoPlayer> createState() => VideoPlayerState();
}

class VideoPlayerState extends State<VideoPlayer> {

  String status = "Help";
  static const String serverUrl = "wss://127.0.0.1:8443";
  final RTCVideoRenderer remoteVideo = RTCVideoRenderer();
  late final WebSocketChannel channel;
  late final WebSocketChannel channel2;
  MediaStream? remoteStream;
  RTCPeerConnection? peerConnection;
  var peerId = Random().nextInt(10000) + 10; 

  // Connecting with websocket Server
  void connectToServer() {
    try {
      channel = WebSocketChannel.connect(Uri.parse(serverUrl));
      channel.sink.add("HELLO $peerId");
      // Listening to the socket event as a stream
      channel.stream.listen(
        (message) async {
          if (message == "HELLO") {
            print('Registered with server. Waiting for call');
            String url2 = "$serverUrl/webrtc";
            channel2 = WebSocketChannel.connect(Uri.parse(url2));
            channel2.sink.add("$peerId");
            return;
          }
          // Decoding message
          Map<String, dynamic> decoded = jsonDecode(message);
          // SDP offer received from peer, set remote description and create an answer
          if (decoded.containsKey("sdp")) {
            if (decoded["sdp"]["type"] != "offer") {
              return;
            }
            // print("Got SDP offer");
            // Set the offer SDP to remote description
            await peerConnection?.setRemoteDescription(
              RTCSessionDescription(decoded["sdp"]["sdp"], decoded["sdp"]["type"]),
            );
            // Create an answer
            // print("Got local stream, creating answer");
            RTCSessionDescription answer = await peerConnection!.createAnswer();
            // Set the answer as an local description
            await peerConnection!.setLocalDescription(answer);
            
            // Sending SDP - the answer to the other peer
            channel.sink.add(jsonEncode({"sdp": answer.toMap()}));
          }
          // If client receive an Ice candidate from the peer
          else if (decoded.containsKey("ice")) {
            // It add to the RTC peer connection
          //   peerConnection?.addCandidate(RTCIceCandidate(
          //       decoded["ice"]["candidate"],
          //       "0",
          //       // decoded["ice"]["sdpMid"],
          //       decoded["ice"]["sdpMLineIndex"]));
          }
          // If Client recive an reply of their offer as answer
          else if (decoded["event"] == "answer") {
            await peerConnection?.setRemoteDescription(RTCSessionDescription(
                decoded["sdp"]["sdp"], decoded["sdp"]["type"]));
          }
          // If no condition fulfilled? printout the message
          else {
            print("Errored - $decoded");
          }
        },
        onError: (error) {
          _startConnection();
        },
        onDone: () {
          _startConnection();
        },
      );
      
    } catch (e) {
      _disconnectFromWebSocket();
      // throw "ERROR $e";
    }
  }

  // STUN server configuration
  Map<String, dynamic> configuration = {
    // 'iceServers': [
    //   {
    //     'urls': [
    //       'stun:stun1.l.google.com:19302',
    //     ]
    //   }
    // ]
  };
  
  Map<String, dynamic> mediaConstraints = {
      'mandatory': {
        'OfferToReceiveAudio': false,
        'OfferToReceiveVideo': true,
      },
      'optional': [],
  };

  // This must be done as soon as app loads
  void initialization() async {
    // Getting video feed from the user camera
    // Disabled sending video
    // localStream = await navigator.mediaDevices.getUserMedia({'video': false, 'audio': false});

    // setState(() {
    //   // Set the local video to display
    //   localVideo.srcObject = localStream;
    // });
    // Initializing the peer connecion
    peerConnection = await createPeerConnection(configuration, mediaConstraints);
    registerPeerConnectionListeners();
    
    // Adding the local media to peer connection
    // When connection establish, it send to the remote peer
    // localStream.getTracks().forEach((track) {
    //   peerConnection?.addTrack(track, localStream);
    // });
  }

  void takeSnapshot(snapshotState) async {
    // final Uint8List? bytes = await player.screenshot();
    // if (bytes != null) {
    //   snapshotState.addImageToSnapshots(Image.memory(bytes));
    // }1
  }

  void makeCall() async {
    // Creating a offer for remote peer
    peerConnection!.addTransceiver(
      kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
      init: RTCRtpTransceiverInit(direction: TransceiverDirection.RecvOnly)
    );
    RTCSessionDescription offer = await peerConnection!.createOffer();

    // Setting own SDP as local description
    await peerConnection?.setLocalDescription(offer);
    // print(offer);
    // Sending the offer
    channel.sink.add(
      jsonEncode(
        {"sdp": offer.toMap()},
      ),
    );
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      channel.sink.add(
        jsonEncode({"ice": candidate.toMap()}),
      );
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state change: $state');
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      // print('Signaling state change: $state');
    };

    peerConnection?.onTrack = ((tracks) {
      tracks.streams[0].getTracks().forEach((track) {
        remoteStream?.addTrack(track);
      });
    });

    // When stream is added from the remote peer
    peerConnection?.onAddStream = (MediaStream stream) {
      remoteVideo.srcObject = stream;
      setState(() {});
    };
  }

  @override
  void initState() {
    _startConnection();
    super.initState();
  }

  @override
  void dispose() {
    _disconnectFromWebSocket();
    // localVideo.dispose();
    remoteVideo.dispose();
    super.dispose();
  }

  void _startConnection() {
    connectToServer();
    remoteVideo.initialize();
    initialization(); 
  }

  void _disconnectFromWebSocket() {
    peerConnection?.close();
    // See close codes. Accepts 1000, 3000-4000
    channel.sink.close(1000);
    channel2.sink.close(1000);
  }

  String getStatus() {
    return "";
  }

  @override
  Widget build(BuildContext context) {
    // final videoState = Provider.of<VideoFeedProvider>(context);
    // final snapshotState = Provider.of<SnapshotProvider>(context);
    // if (snapshotState.snapshotRequested) {
    //   snapshotState.snapshotRequested = false;
    //   takeSnapshot(snapshotState);
    //   }
      return Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: RTCVideoView(
              remoteVideo,
              mirror: false,
            ),
          ),
      );
    }
}
