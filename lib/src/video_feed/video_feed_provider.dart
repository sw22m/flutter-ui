// Not ideal, workaround to stop the media player crashing

import 'package:flutter/material.dart';
import 'package:pyuscope_web/src/video_feed/video_feed_view.dart';

class VideoFeedProvider with ChangeNotifier {

  bool _playing = true;
  bool get playing => _playing;
  set playing (bool v) {
    _playing = v;
    notifyListeners();
  }

}