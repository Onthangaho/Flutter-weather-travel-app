
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Data layer — repositories
import 'data/settings_repository.dart';
import 'data/travel_repository.dart';
import 'data/weather_repository.dart';
import 'data/location_service.dart';
// Domain layer — providers
import 'domain/settings_provider.dart';
import 'domain/travel_provider.dart';
import 'domain/weather_provider.dart';
// ← NEW
// ← NEW
// Presentation layer
import 'presentation/home_screen.dart';

void main() {
  runApp(const TravelApp());
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TravelProvider(TravelRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(SettingsRepository()),
        ),
        // NEW: WeatherProvider with dependency injection
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(WeatherRepository(), LocationService()),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'Weather & Travel',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.teal,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}