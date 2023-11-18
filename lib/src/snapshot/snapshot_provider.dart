import 'package:flutter/material.dart';

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

  void takeSnapshot(Image image) {
    DateTime now = DateTime.now();
    String date = DateTime(now.year, now.month, now.day, 
      now.hour, now.minute, now.second).toString(); 
    SnapshotData snapshot = SnapshotData(
      name: "Snapshot $date", 
      // image: Image.memory(imageBytes, gaplessPlayback: true),
      image: image,
      createdOn: now);
    snapshotList.add(snapshot);
    selectedSnapshot = snapshotList.length - 1;
    notifyListeners();
  }

  void clearSnapshots() {
    snapshotList.clear();
    selectedSnapshot = -1;
    notifyListeners();
  }

}