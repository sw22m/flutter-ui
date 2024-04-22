import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

// https://mtabishk999.medium.com/tls-ssl-connection-using-self-signed-certificates-with-dart-and-flutter-6e7c46ea1a36
// https://medium.com/@Victor.Ahmad/implementing-certificate-pinning-in-a-flutter-app-using-the-http-package-b8c4c927afe8
Future<HttpClient> createHttpClientWithPinnedCertificate() async {
  final SecurityContext securityContext = SecurityContext();
  final String certificate = await rootBundle.loadString('assets/ca/localhost.pem');
  securityContext.setTrustedCertificatesBytes(certificate.codeUnits);
  return HttpClient(context: securityContext);
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        //add your certificate verification logic here
        return true;
      };
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  runApp(MyApp(settingsController: settingsController));
}
