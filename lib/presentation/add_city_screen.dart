import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/travel_provider.dart';

class AddCityScreen extends StatefulWidget {
  const AddCityScreen({super.key});

  @override
  State<AddCityScreen> createState() => _AddCityScreenState();
}

class _AddCityScreenState extends State<AddCityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cityNameController = TextEditingController();
  final _countryController = TextEditingController();
  final _temperatureController = TextEditingController();

  String _selectedCondition = 'Sunny';
  final List<String> _conditions = [
    'Sunny',
    'Cloudy',
    'Rainy',
    'Foggy',
    'Clear',
    'Stormy',
  ];

  @override
  void dispose() {
    _cityNameController.dispose();
    _countryController.dispose();
    _temperatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a City'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Destination',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a city to your weather dashboard.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _cityNameController,
                    decoration: const InputDecoration(
                      labelText: 'City Name',
                      hintText: 'e.g. Tokyo',
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a city name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _countryController,
                    decoration: const InputDecoration(
                      labelText: 'Country',
                      hintText: 'e.g. Japan',
                      prefixIcon: Icon(Icons.flag),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a country';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _temperatureController,
                    decoration: const InputDecoration(
                      labelText: 'Temperature',
                      hintText: 'e.g. 22',
                      prefixIcon: Icon(Icons.thermostat),
                      suffixText: '°C',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a temperature';
                      }
                      if (double.tryParse(value.trim()) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCondition,
                    decoration: const InputDecoration(
                      labelText: 'Weather Condition',
                      prefixIcon: Icon(Icons.cloud),
                      border: OutlineInputBorder(),
                    ),
                    items: _conditions.map((condition) {
                      return DropdownMenuItem(
                        value: condition,
                        child: Text(condition),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCondition = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final newCity = {
                            'name': _cityNameController.text.trim(),
                            'country': _countryController.text.trim(),
                            'temp':
                                '${_temperatureController.text.trim()}°C',
                            'condition': _selectedCondition,
                          };
                          context.read<TravelProvider>().addCity(newCity);
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add City'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
