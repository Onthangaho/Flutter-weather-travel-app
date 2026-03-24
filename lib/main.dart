import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ← NEW: import the provider package
import 'city_tile.dart';
import 'add_city_screen.dart';
import 'forecast_screen.dart';
import 'city_detail_screen.dart';
import 'app_router.dart';
import 'travel_provider.dart'; // ← NEW: import our provider class

void main() {
  // Removed 'const' because ChangeNotifierProvider is not a const widget
  runApp(const TravelApp());
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // THE RADIO TOWER — ChangeNotifierProvider wraps everything
    // ============================================================
    // ChangeNotifierProvider does two things:
    //   1. Creates a single instance of TravelProvider
    //   2. Makes it available to every widget below it in the tree
    //
    // 'create:' takes a function that returns a new instance.
    // Provider will call dispose() on it automatically when the
    // app is destroyed — we don't need to manage its lifecycle.
    return ChangeNotifierProvider(
      create: (context) => TravelProvider(), //this is how we maintain "single source of truth"
      child: MaterialApp(
        title: 'Weather & Travel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

// ================================================================
// HomeScreen is now MUCH simpler — no more local state!
// ================================================================
// We can even consider making this a StatelessWidget since it
// no longer manages any local state. But we'll keep StatefulWidget
// for now because the FAB navigation uses async/await.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
// ============================================================
// NOTICE: The savedCities list is GONE from here.
  // It now lives in TravelProvider.
  // ============================================================

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // WATCH — subscribe to the provider so this widget rebuilds
    // whenever notifyListeners() fires
    // ============================================================
    // context.watch<TravelProvider>() does two things:
    //   1. Returns the TravelProvider instance
    //   2. Registers this widget as a LISTENER — when
    //      notifyListeners() fires, this build() method re-runs
    final travelProvider = context.watch<TravelProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather & Travel'),
        leading: const Icon(Icons.travel_explore),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.of(context).pushRoute(AppRoute.forecast);
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.surface,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
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
            Row(
              children: [
                Icon(
                  Icons.wb_sunny,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '28°C — Sunny',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Nairobi, Kenya',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
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
                // ============================================
                // NOW READS FROM PROVIDER instead of local list
                // ============================================
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
              child: LayoutBuilder(
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
                    // ============================================
                    // NOW READS FROM PROVIDER instead of local list
                    // ============================================
                    itemCount: travelProvider.savedCities.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      // Reading from the provider's list
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
              ),
            ),
          ],
        ),
      ),

      // ============================================================
      // FAB — now navigates to AddCityScreen
      // The form screen will write to the Provider directly (Step 5),
      // so we no longer need to await a result here.
      // ============================================================
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCityScreen(),
            ),
          );
          // NOTICE: No 'await', no catching a result, no setState!
          // The AddCityScreen writes to the Provider directly,
          // and this screen auto-updates because it's watching.
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}