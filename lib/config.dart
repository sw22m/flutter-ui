// config.dart

String get apiHost {
  bool isProd = const bool.fromEnvironment('dart.vm.product');
  // return dotenv.get('API_HOST', fallback: "http://localhost:8080");

  // TODO
  if (isProd) {
    const url = String.fromEnvironment("API_HOST", defaultValue: "http://127.0.0.1:8080");
    return url;
  }
  const url = String.fromEnvironment("API_HOST", defaultValue: "http://127.0.0.1:8080");
  return url;
}