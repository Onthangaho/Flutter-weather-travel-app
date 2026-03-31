import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/travel_provider.dart';
import '../domain/settings_provider.dart';
import '../domain/weather_provider.dart';
import 'city_tile.dart';
import 'add_city_screen.dart';
import 'app_router.dart';
import 'settings_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
// Load default Nairobi weather on startup.
// This does NOT trigger any permission popup — it's just
// a regular API call with hardcoded coordinates.
    Future.microtask(() {
      context.read<WeatherProvider>().loadWeather(-1.2921, 36.8219);
    });
  }
  @override
  Widget build(BuildContext context) {
    final travelProvider = context.watch<TravelProvider>();
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather & Travel'),
        leading: const Icon(Icons.travel_explore),
        actions: [
          // ============================================================
          // NEW: The GPS location button — "Latest Possible Time"
          // ============================================================
          // The permission popup triggers ONLY when this button is tapped.
          // The user knows exactly why we're asking.
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'Use my location',
            onPressed: () {
              context.read<WeatherProvider>().fetchLocalWeather();
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.of(context).pushRoute(AppRoute.forecast);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Check the weather in your saved cities.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // ============================================================
            // Weather display — now shows dynamic location name
            // ============================================================
            Consumer<WeatherProvider>(
              builder: (context, weatherProvider, child) {
                // --- LOADING STATE ---
                if (weatherProvider.isLoading) {
                  return const SizedBox(
                    height: 60,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                // --- ERROR STATE ---
                if (weatherProvider.errorMessage != null) {
                  return Row(
                    children: [
                      Icon(
                        Icons.cloud_off,
                        size: 48,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              weatherProvider.errorMessage!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                color:
                                Theme.of(context).colorScheme.error,
                              ),
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                // Retry with the default coordinates
                                weatherProvider.loadWeather(
                                    -1.2921, 36.8219);
                              },
                              child: Text(
                                'Tap to retry',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                // --- SUCCESS STATE ---
                if (weatherProvider.hasData) {
                  final weather = weatherProvider.currentWeather!;
                  final tempUnit = settings.isCelsius ? '°C' : '°F';
                  final displayTemp = settings.isCelsius
                      ? weather.temperature
                      : (weather.temperature * 9 / 5) + 32;

                  return Row(
                    children: [
                      Icon(
                        _getWeatherIcon(weather.condition),
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${displayTemp.toStringAsFixed(1)}$tempUnit — ${weather.condition}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              // UPDATED: uses dynamic location name
                              // instead of hardcoded "Nairobi, Kenya"
                              weatherProvider.locationName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                // --- DEFAULT STATE ---
                return Text(
                  'Tap to fetch weather',
                  style: Theme.of(context).textTheme.bodyLarge,
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Saved Cities',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${travelProvider.cityCount} cities',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: settings.isGridView
                  ? _buildGridView(travelProvider)
                  : _buildListView(travelProvider),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCityScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGridView(TravelProvider travelProvider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (constraints.maxWidth >= 900) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth >= 600) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 2;
        }

        return GridView.builder(
          itemCount: travelProvider.savedCities.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final city = travelProvider.savedCities[index];
            return CityTile(
              cityName: city['name']!,
              country: city['country']!,
              temperature: city['temp']!,
              condition: city['condition']!,
              onTap: () {
                Navigator.of(context).pushRouteWithArgs(
                  AppRoute.cityDetail,
                  CityDetailArgs(
                    cityName: city['name']!,
                    country: city['country']!,
                    temperature: city['temp']!,
                    condition: city['condition']!,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildListView(TravelProvider travelProvider) {
    return ListView.builder(
      itemCount: travelProvider.savedCities.length,
      itemBuilder: (context, index) {
        final city = travelProvider.savedCities[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: CityTile(
            cityName: city['name']!,
            country: city['country']!,
            temperature: city['temp']!,
            condition: city['condition']!,
            onTap: () {
              Navigator.of(context).pushRouteWithArgs(
                AppRoute.cityDetail,
                CityDetailArgs(
                  cityName: city['name']!,
                  country: city['country']!,
                  temperature: city['temp']!,
                  condition: city['condition']!,
                ),
              );
            },
          ),
        );
      },
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
      case 'mainly clear':
        return Icons.wb_sunny;
      case 'partly cloudy':
        return Icons.cloud_queue;
      case 'overcast':
        return Icons.cloud;
      case 'foggy':
        return Icons.foggy;
      case 'drizzle':
      case 'rainy':
      case 'rain showers':
        return Icons.water_drop;
      case 'snowy':
      case 'snow grains':
        return Icons.ac_unit;
      case 'thunderstorm':
      case 'thunderstorm with hail':
        return Icons.thunderstorm;
      default:
        return Icons.thermostat;
    }
  }
}
