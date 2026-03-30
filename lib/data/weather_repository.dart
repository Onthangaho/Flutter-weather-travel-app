import 'package:dio/dio.dart';
import 'models/weather_model.dart';

class WeatherRepository {
  // Dio instance — created once, reused for all requests.
  // In production, you might configure this with base URLs,
  // timeouts, and interceptors for logging/auth.
  final Dio _dio = Dio();

  // Base URL as a constant — easy to find, easy to change.
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  /// Fetches current weather for a given latitude and longitude.
  ///
  /// Returns a [Weather] object on success.
  /// Throws an [Exception] on failure (no internet, server error, etc.).
  ///
  /// The caller (the Provider) does NOT need to know about HTTP,
  /// JSON, or dio. It just gets back a Weather object.
  Future<Weather> fetchCurrentWeather(double latitude, double longitude) async {
    try {
      // 1. Build the URL with query parameters.
      //    Open-Meteo uses query params for lat/lon and data options.
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'current_weather': true,
        },

      );

      // 2. dio automatically parses the JSON string into a Map!
      //    With the basic http package, you would need to manually call
      //    jsonDecode(response.body) — dio does this for you.
      final Map<String, dynamic> data = response.data;

      // 3. Translate the raw Map into a typed Weather object
      //    using our factory constructor.
      return Weather.fromJson(data);

    } on DioException catch (e) {
      // DioException gives us structured error info:
      //   - e.type tells us WHAT went wrong (timeout, no connection, bad status)
      //   - e.response?.statusCode tells us the HTTP status (404, 500, etc.)
      //   - e.message gives us a human-readable description
      //
      // We rethrow as a generic Exception so the Provider doesn't
      // need to import dio just to catch its error type.
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timed out. Check your internet.');
      } else if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode}');
      } else {
        throw Exception('No internet connection.');
      }
    } catch (e) {
      // Catch-all for unexpected errors (JSON parsing failures, etc.)
      throw Exception('Failed to load weather: $e');
    }
  }
}