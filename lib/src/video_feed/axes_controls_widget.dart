import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool jogging = false;

  PositionProvider() {
    fetchPosition();
  }

  Future fetchPosition() async {
      String url = "$apiHost/get/position";
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

  Future setPositionRelative(double dx, double dy, double dz) async {
    String url = "$apiHost/run/move_relative?axis.x=$dx&axis.y=$dy&axis.z=$dz";
    log.info(url);
    try {
      final response = await http
        .get(Uri.parse(url));
      if (response.statusCode == 200) {
          fetchPosition();
        } else {
          log.info('Failed to set relative position');
        }
    } on Exception {
        log.info('Failed to set relative position');    
    }  
    notifyListeners();
  }

  Future setPostionAbsolute(String axis, double value) async {
    String url;
    switch (axis) {
      case 'x':
        url = "$apiHost/run/move_absolute?axis.x=$value";
        break;
      case 'y':
        url = "$apiHost/run/move_absolute?axis.y=$value";
        break;
      case 'z':
        url = "$apiHost/run/move_absolute?axis.z=$value";
        break;
      default:
        return;
    }
    log.info(url);
    try {
      final response = await http
        .get(Uri.parse(url));
      if (response.statusCode == 200) {
          fetchPosition();
        } else {
          log.info('Failed to set absolute position');
        }
    } on Exception {
        log.info('Failed to set absolute position');    
    }  

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

  void toggleJogging() {
    jogging = !jogging;
    notifyListeners();

    if (jogging) {
      ServicesBinding.instance.keyboard.addHandler(_onKey);
    } else {
      ServicesBinding.instance.keyboard.removeHandler(_onKey);
    }
  }

  bool _onKey(KeyEvent event) {
    final key = event.logicalKey.keyLabel;

    if (event is KeyDownEvent) {
      if (key == "W") {
        print("Key down: $key");
        increaseAxis('x');
      }
    } else if (event is KeyUpEvent) {
      print("Key up: $key");
    } else if (event is KeyRepeatEvent) {
      print("Key repeat: $key");
    }
    return false;
  }
}

class AxisButton extends StatefulWidget {

  final IconData iconData;
  final String label;
  final callback;
  final color;

  const AxisButton({super.key, required this.iconData, 
    required this.label, required this.callback, required this.color});

  @override
  State<AxisButton> createState() => _AxisButtonState();
}

class _AxisButtonState extends State<AxisButton> {

  bool pressed = false;

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
      child: Center(child:FilledButton.tonal(
        child: Icon(widget.iconData),
        onPressed: () {
          widget.callback(widget.label);
        }
      )
    ));
  }
}

Widget _createAxisControl(BuildContext context, String label, double value, state) {
  Color primary = Theme.of(context).colorScheme.primary;
  Color secondary = Theme.of(context).colorScheme.secondary;

  TextEditingController controller = TextEditingController(text: '$value');
  TextField input = TextField(controller: controller,
    readOnly: true,
    onTap: () {
      if (FocusScope.of(context).hasFocus) {
        controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.value.text.length);
      }
    },
    onSubmitted: (value) {
      try {
        state.setPostionAbsolute(label, double.parse(value));
        log.info(value);
      } on Exception {
        log.info('invalid float');
      }
    },
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
    ],
    textAlign: TextAlign.left, style: TextStyle(color: primary));
    

  return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(flex: 0, child: Text(label, textAlign: TextAlign.end, style: TextStyle(color: primary))),
        Expanded(flex: 0, child: AxisButton(iconData: Icons.remove_outlined, 
              label: label, callback: state.decreaseAxis, color: secondary)),
        Expanded(flex: 1, child: input),
        Expanded(flex: 0, child: AxisButton(iconData: Icons.add_outlined, 
              label: label, callback: state.increaseAxis, color: primary)),
      ]
    ); 
}


class AxesControlsWidget extends StatelessWidget {
  const AxesControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final positionState = Provider.of<PositionProvider>(context);
    return Container(
      color: Theme.of(context).colorScheme.secondaryContainer,
      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 0, 0),
      // height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _createAxisControl(context, 'x', positionState.x, positionState),
          _createAxisControl(context, 'y', positionState.y, positionState),
          _createAxisControl(context, 'z', positionState.z, positionState),
          const Spacer(flex: 1),
        ]
      )
    );
  }
}