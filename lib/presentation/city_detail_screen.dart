import 'package:flutter/material.dart';

class CityDetailScreen extends StatelessWidget {
  final String cityName;
  final String country;
  final String temperature;
  final String condition;

  const CityDetailScreen({
    super.key,
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.condition,
  });

  IconData _getWeatherIcon() {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.water_drop;
      case 'foggy':
        return Icons.foggy;
      case 'clear':
        return Icons.wb_twilight;
      case 'stormy':
        return Icons.thunderstorm;
      default:
        return Icons.thermostat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('$cityName Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    _getWeatherIcon(),
                    size: 96,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    temperature,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    condition,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              cityName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              country,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDetailChip(context, Icons.water_drop, '65%', 'Humidity'),
                _buildDetailChip(context, Icons.air, '12 km/h', 'Wind'),
                _buildDetailChip(
                    context, Icons.visibility, '10 km', 'Visibility'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(
      BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
