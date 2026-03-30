import 'package:flutter/material.dart';
import '../data/settings_repository.dart';

/// Provider that manages application settings state.
///
/// All disk operations are delegated to SettingsRepository.
/// This class has NO IDEA that SharedPreferences exists.
class SettingsProvider extends ChangeNotifier {
  final SettingsRepository _repository;

  // --- Private state variables with safe defaults ---
  bool _isDarkMode = false;
  bool _isCelsius = true;
  bool _isGridView = true;
  bool _isLoaded = false;

  // --- Public getters (read-only access for the UI) ---
  bool get isDarkMode => _isDarkMode;
  bool get isCelsius => _isCelsius;
  bool get isGridView => _isGridView;
  bool get isLoaded => _isLoaded;

  // Constructor — receives repository and kicks off loading
  SettingsProvider(this._repository) {
    _init();
  }

  // Load all saved settings from the repository on startup
  Future<void> _init() async {
    final settings = await _repository.loadAllSettings();
    _isCelsius = settings['isCelsius']!;
    _isDarkMode = settings['isDarkMode']!;
    _isGridView = settings['isGridView']!;
    _isLoaded = true;
    notifyListeners();
  }

  // Toggle dark mode — update RAM, notify UI, then persist via repository
  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    await _repository.saveThemeMode(value);
  }

  // Toggle temperature unit
  Future<void> toggleTemperatureUnit(bool value) async {
    _isCelsius = value;
    notifyListeners();
    await _repository.saveTemperatureUnit(value);
  }

  // Toggle layout
  Future<void> toggleLayout(bool value) async {
    _isGridView = value;
    notifyListeners();
    await _repository.saveLayoutPreference(value);
  }

  // Reset all settings to defaults and clear disk
  Future<void> resetAllSettings() async {
    _isDarkMode = false;
    _isCelsius = true;
    _isGridView = true;
    notifyListeners();
    await _repository.clearAllSettings();
  }
}
