import 'package:flutter/material.dart';
import '../../config.dart' show apiHost;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:flutter/services.dart';
final log = Logger('Snapshot');


class SnapshotData {
  String name;
  Image image;
  DateTime createdOn;
  SnapshotData({required this.name, required this.image, required this.createdOn});
}

class SnapshotProvider with ChangeNotifier {

  final List<SnapshotData> snapshotList = [];
  int _selectedSnapshot = -1;
  int get selectedSnapshot => _selectedSnapshot;
  set selectedSnapshot (int index) {
    if (index >= snapshotList.length) {
      index = -1;
    }
    _selectedSnapshot = index;
    notifyListeners();
  }

  bool snapshotRequested = false;
  
  bool get showSnapshot => _selectedSnapshot != -1; 

  Future fetchImage() async {
      String url = "$apiHost/get/image";
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          Map<String, dynamic> json = jsonDecode(response.body) as Map<String, dynamic>;
          Image image = Image.memory(Uint8List.fromList(base64Decode((json['data']['base64']))), gaplessPlayback: true );
          DateTime now = DateTime.now();
          String date = getDateString(now);
          SnapshotData snapshot = SnapshotData(
            name: "Snapshot $date", 
            image: image,
            createdOn: now);
          snapshotList.add(snapshot);
          selectedSnapshot = snapshotList.length - 1;
          notifyListeners();
        } else {
          log.info('Failed to fetch position');
        }
      } on Exception {
          log.info('Failed to fetch position');
      }
  }

  String getDateString(DateTime datetime) {
    return DateTime(datetime.year, datetime.month, datetime.day, 
      datetime.hour, datetime.minute, datetime.second).toString();
  }

  void takeSnapshot() {
    snapshotRequested = true;
    notifyListeners();
  }

  void takeSnapshot2() {
    fetchImage();
  }

  void clearSnapshots() {
    snapshotList.clear();
    selectedSnapshot = -1;
    notifyListeners();
  }

  void addImageToSnapshots(Image image) {
    // Externally insert snapshot
    DateTime now = DateTime.now();
    String date = getDateString(now);
    SnapshotData snapshot = SnapshotData(
      name: "Snapshot $date", 
      image: image,
      createdOn: now);
      snapshotList.add(snapshot);
      selectedSnapshot = snapshotList.length - 1;
      notifyListeners();
    }

    Image getSelectedSnapshotImage() {
      if (_selectedSnapshot == -1) {
        return const Image(image: AssetImage("assets/images/error.png"));
      }
      return snapshotList[_selectedSnapshot].image;
    }

}