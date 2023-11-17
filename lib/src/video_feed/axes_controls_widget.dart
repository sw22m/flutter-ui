import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config.dart' show apiHost;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

import 'dart:convert';
final log = Logger('AxesControl');

class PositionProvider with ChangeNotifier {

  double x = 0;
  double y = 0;
  double z = 0;

  Future fetchPosition() async {
      // String host = dotenv.get('API_HOST', fallback: "http://localhost:8080");
      String host = apiHost;
      String url = "$host/get/pos";
      log.info(url);
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body) as Map<String, dynamic>;
        x = json['data']['x'] as double;
        y = json['data']['y'] as double;
        z = json['data']['z'] as double;
      } else {
        log.info('Failed to fetch position');
      }
      
      notifyListeners();
  }

  // Future setAbsolutePosition() async {
  //   final response = await http
  //     .get(Uri.parse(dotenv.get('API_HOST', fallback: "http://localhost:8080") + '/set/pos?x=2&relative=1'));
  // }

  Future setPositionRelative(double dx, double dy, double dz) async {
    // String host = dotenv.get('API_HOST', fallback: "http://localhost:8080");
    String host = apiHost;
    String url = "$host/set/pos?x=$dx&y=$dy&z=$dz&relative=1";
    log.info(url);
    final response = await http
      .get(Uri.parse(url));
    if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body) as Map<String, dynamic>;
        x = json['data']['x'] as double;
        y = json['data']['y'] as double;
        z = json['data']['z'] as double;
      } else {
        log.info('Failed to set or fetch position');
      }
    notifyListeners();
  }

  void decreaseAxis(String axis) {
    switch (axis) {
      case 'x':
        setPositionRelative(-0.1, 0, 0);
        break;
      case 'y':
        setPositionRelative(0, -0.1, 0);
        break;
      case 'z':
        setPositionRelative(0, 0, -0.1);
        break;
      default:
    }
  }

  void increaseAxis(String axis) {
    switch (axis) {
      case 'x':
        setPositionRelative(0.1, 0, 0);
        break;
      case 'y':
        setPositionRelative(0, 0.1, 0);
        break;
      case 'z':
        setPositionRelative(0, 0, 0.1);
        break;
      default:
    }
  }
}

Widget _createAxisControl(String label, double value, state) {
  const Color myColor = Colors.green;
  return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(label, textAlign: TextAlign.center, style: TextStyle(color: myColor)),
        Expanded(
            child: IconButton(
                icon: const Icon(Icons.remove_circle_outline_rounded, color: myColor),
                onPressed: () {
                  state.decreaseAxis(label);
                })),
        Expanded(child: Text('$value', textAlign: TextAlign.center, style: TextStyle(color: myColor))),
        Expanded(
            child: IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded, color: myColor,),
                onPressed: () {
                  state.increaseAxis(label);
                })),
        // Spacer(flex: 1),
      ]
    ); 
}


class AxesControlsWidget extends StatelessWidget {

  const AxesControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    
    final positionState = Provider.of<PositionProvider>(context);
    return Container(
        padding: EdgeInsets.fromLTRB(24.0, 16.0, 0, 0),
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
          _createAxisControl('x', positionState.x, positionState),
          _createAxisControl('y', positionState.y, positionState),
          _createAxisControl('z', positionState.z, positionState),
        ]));
  }
}