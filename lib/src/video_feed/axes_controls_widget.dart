import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config.dart' show apiHost;
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'dart:async';

final log = Logger('AxesControl');

class PositionProvider with ChangeNotifier {

  double x = 0;
  double y = 0;
  double z = 0;

  PositionProvider() {
    fetchPosition();
  }

  Future fetchPosition() async {
      String url = "$apiHost/get/pos";
      log.info(url);
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          Map<String, dynamic> json = jsonDecode(response.body) as Map<String, dynamic>;
          x = json['data']['x'] as double;
          y = json['data']['y'] as double;
          z = json['data']['z'] as double;
        } else {
          log.info('Failed to fetch position');
        }
      } on Exception {
        log.info('Failed to fetch position');    
      }
      notifyListeners();
  }

  // Future setAbsolutePosition() async {
  //   final response = await http
  //     .get(Uri.parse(dotenv.get('API_HOST', fallback: "http://localhost:8080") + '/set/pos?x=2&relative=1'));
  // }

  Future setPositionRelative(double dx, double dy, double dz) async {
    String url = "$apiHost/set/pos?x=$dx&y=$dy&z=$dz&relative=1";
    log.info(url);
    try {
      final response = await http
        .get(Uri.parse(url));
      if (response.statusCode == 200) {
          Map<String, dynamic> json = jsonDecode(response.body) as Map<String, dynamic>;
          x = json['data']['x'] as double;
          y = json['data']['y'] as double;
          z = json['data']['z'] as double;
        } else {
          log.info('Failed to set position');
        }
    } on Exception {
        log.info('Failed to set position');    
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

class AxisButton extends StatefulWidget {

  final IconData iconData;
  final String label;
  final callback;

  const AxisButton({super.key, required this.iconData, 
    required this.label, required this.callback});

  @override
  State<AxisButton> createState() => _AxisButtonState();
}

class _AxisButtonState extends State<AxisButton> {

  bool pressed = false;
  Color myColor = Colors.lightGreen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPress: () {
          pressed = true;
          Timer timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
            if (pressed == false) {
              timer.cancel();
            }
            widget.callback(widget.label);
          });
        },   
        onLongPressUp: () {
          pressed = false;
        },
        child: IconButton(
            icon: Icon(widget.iconData, color: myColor),
            onPressed: () {
              widget.callback(widget.label);
            })
      );
  }
}

Widget _createAxisControl(String label, double value, state) {
  const Color myColor = Colors.green;
  return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(label, textAlign: TextAlign.center, style: const TextStyle(color: myColor)),
        Expanded(child: AxisButton(iconData: Icons.remove_circle_outline, 
              label: label, callback: state.decreaseAxis)),
        Expanded(child: Text('$value', textAlign: TextAlign.center, style: const TextStyle(color: myColor))),
        Expanded(child: AxisButton(iconData: Icons.add_circle_outline, 
              label: label, callback: state.increaseAxis)),
      ]
    ); 
}


class AxesControlsWidget extends StatelessWidget {
  const AxesControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final positionState = Provider.of<PositionProvider>(context);
    return Container(
        padding: const EdgeInsets.fromLTRB(24.0, 16.0, 0, 0),
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