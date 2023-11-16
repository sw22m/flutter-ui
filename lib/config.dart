// config.dart
String get apiHost {
  bool isProd = const bool.fromEnvironment('dart.vm.product');
  if (isProd) {
    return String.fromEnvironment("API_HOST");
  }
  return String.fromEnvironment("API_HOST", defaultValue: "http://localhost:8080");
}