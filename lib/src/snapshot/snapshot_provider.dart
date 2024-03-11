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

  Future fetchImage() async {
      String url = "$apiHost/get/image";
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          Map<String, dynamic> json = jsonDecode(response.body) as Map<String, dynamic>;
          // Image image = Image.memory(json['data']['base64'], gaplessPlayback: true );
          Image image = Image.memory(Uint8List.fromList(base64Decode((json['data']['base64']))), gaplessPlayback: true );
       
          DateTime now = DateTime.now();
          String date = DateTime(now.year, now.month, now.day, 
            now.hour, now.minute, now.second).toString(); 
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

  void takeSnapshot() {
    fetchImage();
  }

  void clearSnapshots() {
    snapshotList.clear();
    selectedSnapshot = -1;
    notifyListeners();
  }

}