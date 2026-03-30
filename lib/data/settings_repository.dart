import 'package:shared_preferences/shared_preferences.dart';

/// Repository that handles all settings persistence.
///
/// This class is the ONLY place in the entire app that directly
/// touches SharedPreferences for settings data. If we ever swap
/// SharedPreferences for Hive, SQLite, or a remote API, we change
/// ONLY this file — nothing else in the app is affected.
class SettingsRepository {
  // Centralizing key strings as constants prevents typos.
  static const String _keyIsCelsius = 'isCelsius';
  static const String _keyIsDarkMode = 'isDarkMode';
  static const String _keyIsGridView = 'isGridView';

  // --- SAVE METHODS ---

  Future<void> saveTemperatureUnit(bool isCelsius) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsCelsius, isCelsius);
  }

  Future<void> saveThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsDarkMode, isDarkMode);
  }

  Future<void> saveLayoutPreference(bool isGridView) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsGridView, isGridView);
  }

  // --- LOAD METHODS ---

  /// Loads all settings from disk in one call.
  /// Returns a Map with all values (or defaults if not found).
  /// More efficient than calling each load method separately
  /// because it only calls getInstance() once.
  Future<Map<String, bool>> loadAllSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'isCelsius': prefs.getBool(_keyIsCelsius) ?? true,
      'isDarkMode': prefs.getBool(_keyIsDarkMode) ?? false,
      'isGridView': prefs.getBool(_keyIsGridView) ?? true,
    };
  }

  // --- CLEAR ---

  /// Removes all settings keys from SharedPreferences.
  /// Uses remove() on specific keys instead of clear() to avoid
  /// deleting keys from other features.
  Future<void> clearAllSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsCelsius);
    await prefs.remove(_keyIsDarkMode);
    await prefs.remove(_keyIsGridView);
  }
}
