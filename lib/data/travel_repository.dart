import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository that handles persistence for travel/city data.
///
/// Stores cities as a JSON string in SharedPreferences.
/// In a future iteration, this could be swapped to SQLite or
/// a REST API without touching the Provider or UI.
class TravelRepository {
  static const String _keySavedCities = 'savedCities';

  /// Saves the list of cities to disk.
  /// Converts the list of Maps to a JSON string because
  /// SharedPreferences can only store primitive types.
  Future<void> saveCities(List<Map<String, String>> cities) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(cities);
    await prefs.setString(_keySavedCities, jsonString);
  }

  /// Loads the list of cities from disk.
  /// Returns the default starter cities if nothing is saved.
  Future<List<Map<String, String>>> loadCities() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keySavedCities);

    if (jsonString == null) {
      return _defaultCities();
    }

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((item) => Map<String, String>.from(item)).toList();
    } catch (e) {
      // If stored JSON is corrupted, fall back to defaults
      // rather than crashing the app.
      return _defaultCities();
    }
  }

  /// Default starter cities for first-time launch.
  List<Map<String, String>> _defaultCities() {
    return [
      {'name': 'Paris', 'country': 'France', 'temp': '18°C', 'condition': 'Cloudy'},
      {'name': 'Tokyo', 'country': 'Japan', 'temp': '22°C', 'condition': 'Sunny'},
      {'name': 'New York', 'country': 'USA', 'temp': '15°C', 'condition': 'Rainy'},
      {'name': 'Cape Town', 'country': 'South Africa', 'temp': '26°C', 'condition': 'Sunny'},
      {'name': 'Dubai', 'country': 'UAE', 'temp': '38°C', 'condition': 'Clear'},
      {'name': 'London', 'country': 'UK', 'temp': '12°C', 'condition': 'Foggy'},
    ];
  }

  /// Deletes all saved city data from disk.
  Future<void> clearCities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySavedCities);
  }
}
