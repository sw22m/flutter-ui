import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Axis {
  final int value;

  const Axis({
    required this.value,
  });

  factory Axis.fromJson(Map<String, dynamic> json) {
    return Axis(
      value: json['data']['value'] as int,
    );
  }
}

Future<Axis> fetchAxis() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Axis.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
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
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Text(widget.axis, textAlign: TextAlign.center),
      Expanded(
          child: IconButton(
              icon: const Icon(Icons.remove_circle_outline_rounded),
              onPressed: () {
                decrease();
              })),
      Expanded(child: Text('$value', textAlign: TextAlign.center)),
      Expanded(
          child: IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded),
              onPressed: () {
                increase();
              })),
    ]);
  }

  void decrease() {
    print(value);
    value--;

    setState(() {});
  }

  void increase() {
    print(value);
    value++;
    // print(root._controller)
    setState(() {});
  }
}

class AxesControlsWidget extends StatelessWidget {
  const AxesControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(20)),
        child: const Column(children: <Widget>[
          AxisControl(axis: 'x'),
          AxisControl(axis: 'y'),
          AxisControl(axis: 'z'),
        ]));
  }
}
