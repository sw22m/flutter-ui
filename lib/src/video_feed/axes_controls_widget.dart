// import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config.dart' show apiHost;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Position {
  final double x;
  final double y;
  final double z;

  const Position({
    required this.x,
    required this.y,
    required this.z,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      x: json['data']['x'] as double,
      y: json['data']['y'] as double,
      z: json['data']['z'] as double,
    );
  }
}

Future<Position> fetchPosition() async {
  final response = await http
      .get(Uri.parse(dotenv.get('API_HOST', fallback: "http://localhost:8080") + '/get/pos'));

  if (response.statusCode == 200) {
    return Position.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to fetch position');
  }
}

class AxisControl extends StatefulWidget {
  final String axis;

  const AxisControl({super.key, required this.axis});

  @override
  State<AxisControl> createState() => _AxisState();
}

class _AxisState extends State<AxisControl> {
  int value = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const Color myColor = Colors.white;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Spacer(flex: 2),
        Text(widget.axis, textAlign: TextAlign.center, style: TextStyle(color: myColor)),
        Expanded(
            child: IconButton(
                icon: const Icon(Icons.remove_circle_outline_rounded, color: myColor),
                onPressed: () {
                  decrease();
                })),
        Expanded(child: Text('$value', textAlign: TextAlign.center, style: TextStyle(color: myColor))),
        Expanded(
            child: IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded, color: myColor,),
                onPressed: () {
                  increase();
                })),
        Spacer(flex: 2),
      ]
    );
  }

  void setValue() {

  }

  void decrease() {
    value--;
    setState(() {});
  }

  void increase() {
    value++;
    setState(() {});
  }
}


class _AxesControlsWidgetState extends State<AxesControlsWidget> {
  int value = 1;
  late Future<Position> position;

  @override
  void initState() {
    super.initState();
    position = fetchPosition();
    print(position);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 16.0, 0, 0),
        alignment: Alignment.topCenter,
        height: 200,
        // color: Colors.black,
        child: const Column(children: <Widget>[
          AxisControl(axis: 'x'),
          AxisControl(axis: 'y'),
          AxisControl(axis: 'z'),
        ]));
  }
}


class AxesControlsWidget extends StatefulWidget {
  const AxesControlsWidget({super.key});

  @override
  State<AxesControlsWidget> createState() => _AxesControlsWidgetState();
}

