import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Section Header: Appearance ---
          Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
          ),
          const SizedBox(height: 8),

          // Dark Mode Toggle
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: Text(
              settings.isDarkMode ? 'Dark theme active' : 'Light theme active',
            ),
            secondary: Icon(
              settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: colorScheme.primary,
            ),
            value: settings.isDarkMode,
            onChanged: (value) {
              settings.toggleTheme(value);
            },
          ),

          const Divider(height: 32),

          // --- Section Header: Display ---
          Text(
            'Display',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
          ),
          const SizedBox(height: 8),

          // Temperature Unit Toggle
          SwitchListTile(
            title: const Text('Temperature Unit'),
            subtitle: Text(
              settings.isCelsius ? 'Celsius (°C)' : 'Fahrenheit (°F)',
            ),
            secondary: Icon(
              Icons.thermostat,
              color: colorScheme.primary,
            ),
            value: settings.isCelsius,
            onChanged: (value) {
              settings.toggleTemperatureUnit(value);
            },
          ),

          // Grid/List View Toggle
          SwitchListTile(
            title: const Text('Grid View'),
            subtitle: Text(
              settings.isGridView
                  ? 'Showing cities in a grid'
                  : 'Showing cities in a list',
            ),
            secondary: Icon(
              settings.isGridView ? Icons.grid_view : Icons.list,
              color: colorScheme.primary,
            ),
            value: settings.isGridView,
            onChanged: (value) {
              settings.toggleLayout(value);
            },
          ),

          const Divider(height: 32),

          // --- Section Header: Data ---
          Text(
            'Data',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
          ),
          const SizedBox(height: 8),

          // Reset Settings Button
          ListTile(
            leading: const Icon(Icons.restore, color: Colors.red),
            title: const Text(
              'Reset All Settings',
              style: TextStyle(color: Colors.red),
            ),
            subtitle: const Text('Restore all settings to their defaults'),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Reset Settings?'),
                  content: const Text(
                    'This will reset all settings to their default values. '
                    'Dark mode will be turned off, temperature unit will '
                    'revert to Celsius, and the layout will return to grid view.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        settings.resetAllSettings();
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Settings have been reset'),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
