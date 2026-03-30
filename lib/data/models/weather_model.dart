class Weather {
  final double temperature;
  final double windspeed;
  final int weatherCode;
  final String condition;
  final String time;
  Weather({
    required this.temperature,
    required this.windspeed,
    required this.weatherCode,
    required this.condition,
    required this.time,
  });
  /// Factory constructor that creates a Weather object from the API's JSON.
  ///
  /// The Open-Meteo response nests weather data inside 'current_weather':
  /// {
  ///   "current_weather": {
  ///     "temperature": 22.4,
  ///     "windspeed": 11.2,
  ///     "weathercode": 1,
  ///     "time": "2026-03-30T14:00"
  ///   }
  /// }
  ///
  /// This factory navigates that nesting and extracts what we need.
  factory Weather.fromJson(Map<String, dynamic> json) {
// Step 1: Navigate into the nested 'current_weather' object.
// This is a Map<String, dynamic> inside the larger JSON Map.
    final currentWeather = json['current_weather'] as Map<String, dynamic>;
// Step 2: Extract individual fields with proper type casting.
// JSON numbers can be int OR double depending on the value.
// Using toDouble() ensures we always get a double.
    final temp = (currentWeather['temperature'] as num).toDouble();
    final wind = (currentWeather['windspeed'] as num).toDouble();
    final code = currentWeather['weathercode'] as int;
    final timeStr = currentWeather['time'] as String;
// Step 3: Map the weather code to a human-readable condition string.
    final conditionText = _mapWeatherCode(code);
    return Weather(
      temperature: temp,
      windspeed: wind,
      weatherCode: code,
      condition: conditionText,
      time: timeStr,
    );
  }
  /// Maps Open-Meteo WMO weather codes to human-readable strings.
  ///
  /// Full spec: https://open-meteo.com/en/docs
  /// WMO codes: https://www.nodc.noaa.gov/archive/arc0021/0002199/1.1/data/0data/HTML/WMO-CODE/WMO4677.HTM

  static String _mapWeatherCode(int code) {

    switch (code) {
      case 0:
        return 'Clear';
      case 1:
        return 'Mainly Clear';
      case 2:
        return 'Partly Cloudy';
      case 3:
        return 'Overcast';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rainy';
      case 71:
      case 73:
      case 75:
        return 'Snowy';
      case 77:
        return 'Snow Grains';
      case 80:
      case 81:
      case 82:
        return 'Rain Showers';
      case 95:
        return 'Thunderstorm';
      case 96:
      case 99:
        return 'Thunderstorm with Hail';
      default:
        return 'Unknown';
    }
  }
}