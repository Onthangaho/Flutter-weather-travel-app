
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Data layer — repositories
import 'data/settings_repository.dart';
import 'data/travel_repository.dart';
import 'data/weather_repository.dart';
import 'data/location_service.dart';
import 'data/auth_service.dart';
import '../data/notification_service.dart';


// Domain layer — providers
import 'domain/settings_provider.dart';
import 'domain/travel_provider.dart';
import 'domain/weather_provider.dart';
import 'domain/auth_provider.dart';

// Presentation layer — widgets
import 'presentation/auth_gate.dart';

// ← NEW
// ← NEW
// Presentation layer
import 'presentation/home_screen.dart';

// main() is now async because Firebase.initializeApp() returns a Future.
// WidgetsFlutterBinding.ensureInitialized() must be called first —
// it sets up the framework binding so async code can run before runApp().
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// Initialize Firebase using the auto-generated configuration.
// This MUST complete before any Firebase service is used.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize the notification plugin.
// This sets up the Android channel and iOS permission settings.
// The actual iOS permission popup appears the first time
// a notification is triggered, not here.
  await NotificationService().init();
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
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(WeatherRepository(), LocationService()),
        ),
        // NEW: Auth provider with auth service
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthService()),
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
            // CHANGED: home is now AuthGate instead of HomeScreen.
            // AuthGate decides whether to show login or dashboard
            // based on the user's authentication state.
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}