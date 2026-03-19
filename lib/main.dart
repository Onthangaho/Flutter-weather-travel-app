import 'package:flutter/material.dart';
import 'city_tile.dart';
import 'forecast_screen.dart';

void main() {
  runApp(const TravelApp());
}
class TravelApp extends StatelessWidget {
  const TravelApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather & Travel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> savedCities = [
    {'name': 'Paris', 'country': 'France', 'temp': '18°C', 'condition': 'Cloudy'},
    {'name': 'Tokyo', 'country': 'Japan', 'temp': '22°C', 'condition': 'Sunny'},
    {'name': 'New York', 'country': 'USA', 'temp': '15°C', 'condition': 'Rainy'},
    {'name': 'Cape Town', 'country': 'South Africa', 'temp': '26°C', 'condition': 'Sunny'},
    {'name': 'Dubai', 'country': 'UAE', 'temp': '38°C', 'condition': 'Clear'},
    {'name': 'London', 'country': 'UK', 'temp': '12°C', 'condition': 'Foggy'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather & Travel'),
        leading: const Icon(Icons.travel_explore),
        actions: [
          // Repurposing the search button to navigate to forecast screen
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // Navigator.push adds a new screen on top of the current one
              // MaterialPageRoute handles the slide-in animation
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForecastScreen(),
                ),
              );
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
              'Welcome Back!          ',
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
                Text(
                  '${savedCities.length} cities',
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
                    itemCount: savedCities.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final city = savedCities[index];
                      return CityTile(
                        cityName: city['name']!,
                        country: city['country']!,
                        temperature: city['temp']!,
                        condition: city['condition']!,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            savedCities.add({
              'name': 'Nairobi',
              'country': 'Kenya',
              'temp': '24°C',
              'condition': 'Warm',
            });
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cities count: ${savedCities.length}')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}