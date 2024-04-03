import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';                    
import '../video_feed/video_feed_provider.dart';
import 'package:provider/provider.dart';
import '../snapshot/snapshot_provider.dart';


class VideoPlayer extends StatefulWidget {
  const VideoPlayer({Key? key}) : super(key: key);

  @override
  State<VideoPlayer> createState() => VideoPlayerState();
}

class VideoPlayerState extends State<VideoPlayer> {
  final RTCVideoRenderer localVideo = RTCVideoRenderer();
  final RTCVideoRenderer remoteVideo = RTCVideoRenderer();
  late final MediaStream localStream;
  late final WebSocketChannel channel;
  late final WebSocketChannel channel2;
  MediaStream? remoteStream;
  RTCPeerConnection? peerConnection;

  // Connecting with websocket Server
  void connectToServer() {
    try {
      const String url = "ws://127.0.0.1:8080";
      channel = WebSocketChannel.connect(Uri.parse(url));
      channel.sink.add("HELLO 100");
      // Listening to the socket event as a stream
      channel.stream.listen(
        (message) async {
          if (message == "HELLO") {
            print('Registered with server. Waiting for call');
            const String url2 = "ws://127.0.0.1:8080/webrtc";
            channel2 = WebSocketChannel.connect(Uri.parse(url2));
            channel2.sink.add("HEY");
            return;
          }
          // Decoding message
          Map<String, dynamic> decoded = jsonDecode(message);
          // SDP offer received from peer, set remote description and create an answer
          if (decoded.containsKey("sdp")) {
            if (decoded["sdp"]["type"] != "offer") {
              return;
            }
            print("Got SDP offer");
            // Set the offer SDP to remote description
            await peerConnection?.setRemoteDescription(
              RTCSessionDescription(decoded["sdp"]["sdp"], decoded["sdp"]["type"]),
            );
            // Create an answer
            print("Got local stream, creating answer");
            RTCSessionDescription answer = await peerConnection!.createAnswer();
            // Set the answer as an local description
            await peerConnection!.setLocalDescription(answer);
            
            // Sending SDP - the answer to the other peer
            channel.sink.add(jsonEncode({"sdp": answer.toMap()}));
          }
          // If client receive an Ice candidate from the peer
          else if (decoded.containsKey("ice")) {
            // It add to the RTC peer connection
            peerConnection?.addCandidate(RTCIceCandidate(
                decoded["ice"]["candidate"],
                "0",
                // decoded["ice"]["sdpMid"],
                decoded["ice"]["sdpMLineIndex"]));
          }
          // If Client recive an reply of their offer as answer
          else if (decoded["event"] == "answer") {
            await peerConnection?.setRemoteDescription(RTCSessionDescription(
                decoded["sdp"]["sdp"], decoded["sdp"]["type"]));
          }
          // If no condition fulfilled? printout the message
          else {
            print(decoded);
          }
        },
      );
      
    } catch (e) {
      throw "ERROR $e";
    }
  }

  // STUN server configuration
  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
        ]
      }
    ]
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
    localStream = await navigator.mediaDevices
        .getUserMedia({'video': false, 'audio': false});

    // Set the local video to display
    localVideo.srcObject = localStream;
    // Initializing the peer connecion
    peerConnection = await createPeerConnection(configuration, mediaConstraints);
    registerPeerConnectionListeners();
    setState(() {});
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
    print(offer);
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
      print('Signaling state change: $state');
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
    connectToServer();
    localVideo.initialize();
    remoteVideo.initialize();
    initialization();
    super.initState();
  }

  @override
  void dispose() {
    peerConnection?.close();
    localVideo.dispose();
    remoteVideo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoState = Provider.of<VideoFeedProvider>(context);
    final snapshotState = Provider.of<SnapshotProvider>(context);
    if (snapshotState.snapshotRequested) {
      snapshotState.snapshotRequested = false;
      takeSnapshot(snapshotState);
      }
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

    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text("Flutter webrtc websocket"),
    //   ),
    //   body: Stack(
    //     children: [
    //       SizedBox(
    //         height: MediaQuery.of(context).size.height,
    //         width: MediaQuery.of(context).size.width,
    //         child: RTCVideoView(
    //           remoteVideo,
    //           mirror: false,
    //         ),
    //       ),
    //       Positioned(
    //         left: 10,
    //         child: SizedBox(
    //           height: 200,
    //           width: 200,
    //           child: RTCVideoView(
    //             localVideo,
    //             mirror: false,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    //   floatingActionButton: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       FloatingActionButton(
    //         backgroundColor: Colors.amberAccent,
    //         onPressed: () => registerPeerConnectionListeners(),
    //         child: const Icon(Icons.settings_applications_rounded),
    //       ),
    //       const SizedBox(width: 10),
    //       FloatingActionButton(
    //         backgroundColor: Colors.green,
    //         onPressed: () => {makeCall()},
    //         child: const Icon(Icons.call_outlined),
    //       ),
    //       const SizedBox(width: 10),
    //       FloatingActionButton(
    //         backgroundColor: Colors.redAccent,
    //         onPressed: () {
    //           channel.sink.add("HELLO 100");
    //         },
    //         child: const Icon(
    //           Icons.call_end_outlined,
    //         ),
    //       ),
    //     ],
    //   ),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    // );
  // }
}
