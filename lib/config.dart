// config.dart

String get apiHost {
  bool isProd = const bool.fromEnvironment('dart.vm.product');
  // TODO
  if (isProd) {
    const url = String.fromEnvironment("API_HOST", defaultValue: "https://127.0.0.1:8443");
    return url;
  }
  const url = String.fromEnvironment("API_HOST", defaultValue: "https://127.0.0.1:8443");
  return url;
}