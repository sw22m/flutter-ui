import 'package:flutter/material.dart';
import 'settings_service.dart';

class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;
  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;
  late String _baseURL;
  String get baseURL => _baseURL;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _baseURL = await _settingsService.baseURL();
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;
    _themeMode = newThemeMode;
    notifyListeners();
    await _settingsService.updateThemeMode(newThemeMode);
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateBaseURL(String? newBaseURL) async {
    if (newBaseURL == null) return;
    _baseURL = newBaseURL;
    notifyListeners();
    await _settingsService.updateBaseURL(newBaseURL);
  }
}
