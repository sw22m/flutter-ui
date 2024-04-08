import 'dart:io';

import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true; // add your localhost detection logic here if you want
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  runApp(MyApp(settingsController: settingsController));
}
