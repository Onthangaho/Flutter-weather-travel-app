import 'package:flutter/material.dart';
import 'daily_forecast_card.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> forecastData = [
      {'day': 'Monday',    'condition': 'Sunny',  'temp': '22°C', 'icon': Icons.wb_sunny},
      {'day': 'Tuesday',   'condition': 'Cloudy', 'temp': '18°C', 'icon': Icons.cloud},
      {'day': 'Wednesday', 'condition': 'Rainy',  'temp': '15°C', 'icon': Icons.water_drop},
      {'day': 'Thursday',  'condition': 'Sunny',  'temp': '25°C', 'icon': Icons.wb_sunny},
      {'day': 'Friday',    'condition': 'Stormy', 'temp': '13°C', 'icon': Icons.thunderstorm},
      {'day': 'Saturday',  'condition': 'Cloudy', 'temp': '19°C', 'icon': Icons.cloud},
      {'day': 'Sunday',    'condition': 'Clear',  'temp': '27°C', 'icon': Icons.wb_twilight},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Forecast'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This Week',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...forecastData.map((day) => DailyForecastCard(
              dayName: day['day'],
              condition: day['condition'],
              temperature: day['temp'],
              weatherIcon: day['icon'],
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${day['day']}: ${day['condition']}, ${day['temp']}',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}