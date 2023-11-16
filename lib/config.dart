// config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

String get apiHost {
  bool isProd = const bool.fromEnvironment('dart.vm.product');
  // return dotenv.get('API_HOST', fallback: "http://localhost:8080");

  // TODO
  if (isProd) {
    const url = String.fromEnvironment("API_HOST", defaultValue: "http://localhost:8080");
    return url;
  }
  const url = String.fromEnvironment("API_HOST", defaultValue: "http://localhost:8080");
  return url;
}