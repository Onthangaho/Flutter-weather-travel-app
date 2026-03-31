import 'package:flutter/material.dart';
import '../data/weather_repository.dart';
import '../data/models/weather_model.dart';
import '../data/location_service.dart';
/// Provider that manages weather data state.
///
/// Now has TWO ways to load weather:
///   1. loadWeather(lat, lon) — with explicit coordinates (used on startup)
///   2. fetchLocalWeather()   — using GPS (triggered by user action)
class WeatherProvider extends ChangeNotifier {
  final WeatherRepository _repository;
  final LocationService _locationService;
// --- State variables ---
  Weather? _currentWeather;
  bool _isLoading = false;
  String? _errorMessage;
  String _locationName = 'Nairobi, Kenya'; // Default display name
// --- Public getters ---
  Weather? get currentWeather => _currentWeather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasData => _currentWeather != null;
  String get locationName => _locationName;
// Constructor — now receives BOTH dependencies
  WeatherProvider(this._repository, this._locationService);
  /// Fetches weather for explicit coordinates.
  /// Used for the default Nairobi load on startup.
  Future<void> loadWeather(double latitude, double longitude) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentWeather = await _repository.fetchCurrentWeather(
        latitude,
        longitude,
      );
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _currentWeather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetches weather for the user's CURRENT GPS location.
  ///
  /// This is the method that connects the hardware to the internet:
  ///   Step 1: Ask LocationService for GPS coordinates (triggers permission popup)
  ///   Step 2: Pass coordinates to WeatherRepository (hits the API)
  ///   Step 3: Store the result and notify the UI
  ///
  /// Any error — GPS off, permission denied, no internet, API failure —
  /// is caught and stored in _errorMessage for the UI to display.
  Future<void> fetchLocalWeather() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Step 1: Get coordinates from the GPS hardware.
      // This is where the permission popup appears (if needed).
      // If the user denies permission, this throws an Exception
      // with a descriptive message.
      final position = await _locationService.getCurrentPosition();

      // Step 2: Pass the hardware coordinates to the internet API.
      // The repository doesn't know or care that these came from GPS —
      // it just receives two numbers and fetches weather for them.
      _currentWeather = await _repository.fetchCurrentWeather(
        position.latitude,
        position.longitude,
      );

      // Update the display name to show it's the user's location
      _locationName = 'Your Location '
          '(${position.latitude.toStringAsFixed(2)}, '
          '${position.longitude.toStringAsFixed(2)})';

    } catch (e) {
      // Both GPS errors and network errors end up here.
      // The error message is already descriptive because both
      // LocationService and WeatherRepository throw meaningful Exceptions.
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _currentWeather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}