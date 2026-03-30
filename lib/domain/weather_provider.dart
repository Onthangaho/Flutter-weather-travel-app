import 'package:flutter/material.dart';
import '../data/weather_repository.dart';
import '../data/models/weather_model.dart';
/// Provider that manages weather data state.
///
/// Handles the three states: Loading, Success, and Error.
/// Delegates all networking to WeatherRepository.
class WeatherProvider extends ChangeNotifier {
  final WeatherRepository _repository;
// --- State variables ---
  Weather? _currentWeather;
  bool _isLoading = false;
  String? _errorMessage;
// --- Public getters ---
  Weather? get currentWeather => _currentWeather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  /// Whether we have successfully loaded weather data.
  bool get hasData => _currentWeather != null;
// Constructor — receives repository via dependency injection
  WeatherProvider(this._repository);
  /// Fetches current weather for the given coordinates.
  ///
  /// This method manages the full loading lifecycle:
  ///   1. Set loading → true  (UI shows spinner)
  ///   2. Call repository      (wait for internet)
  ///   3. Store result or error
  ///   4. Set loading → false (UI shows data or error)
  Future<void> loadWeather(double latitude, double longitude) async {
// --- Enter loading state ---
    _isLoading = true;
    _errorMessage = null; // Clear any previous error
    notifyListeners();    // UI rebuilds → shows spinner
    try {
// --- Await the network call ---
// This line PAUSES this function until the server responds.
// But the UI keeps running — the spinner keeps spinning.
      // That is the power of async/await.
      _currentWeather = await _repository.fetchCurrentWeather(
        latitude,
        longitude,
      );
    } catch (e) {
      // --- Error state ---
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _currentWeather = null;
    } finally {
      // --- Exit loading state ---
      // 'finally' runs whether the try succeeded or failed.
      // This guarantees we always stop the spinner.
      _isLoading = false;
      notifyListeners(); // UI rebuilds → shows data or error
    }
  }
}