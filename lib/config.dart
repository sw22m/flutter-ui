// config.dart
String get apiHost {
  bool isProd = const bool.fromEnvironment('dart.vm.product');
  // TODO
  if (isProd) {
    const url = String.fromEnvironment("API_HOST", defaultValue: "http://localhost:8080");
    return url;
  }
  const url = String.fromEnvironment("API_HOST", defaultValue: "http://localhost:8080");
  return url;
}