import 'package:flutter/material.dart';
// ================================================================
// THE CHANGENOTIFIER — the single source of truth for city data
// ================================================================
// This class:
//
//
//
//
//
//1. Holds the data (the list of cities)
//2. Exposes read access via getters
//3. Exposes write access via methods
//4. Calls notifyListeners() after every change
// ChangeNotifier is a built-in Flutter class that implements
// the Observer pattern. Widgets can "subscribe" to it, and when
// notifyListeners() fires, all subscribers rebuild.
class TravelProvider extends ChangeNotifier {
// ============================================================
// THE DATA — private, prefixed with underscore
// ============================================================
// The underscore (_) makes this field PRIVATE to this file.
// No other file can directly access or modify _savedCities.
// This is encapsulation — we control all access through
// public getters and methods below.
final List<Map<String, String>> _savedCities = [
{'name': 'Paris', 'country': 'France', 'temp': '18°C', 'condition': 'Cloudy'},
{'name': 'Tokyo', 'country': 'Japan', 'temp': '22°C', 'condition': 'Sunny'},
{'name': 'New York', 'country': 'USA', 'temp': '15°C', 'condition': 'Rainy'},
{'name': 'Cape Town', 'country': 'South Africa', 'temp': '26°C', 'condition': 'Sunny'},
{'name': 'Dubai', 'country': 'UAE', 'temp': '38°C', 'condition': 'Clear'},
{'name': 'London', 'country': 'UK', 'temp': '12°C', 'condition': 'Foggy'},
];
// ============================================================
// GETTER — read-only access to the list
// ============================================================
// An UnmodifiableListView would be even safer, but for this demo
// a simple getter is sufficient. External code can READ the list
// but cannot call .add() or .remove() on it directly — they
// must go through our methods below.
List<Map<String, String>> get savedCities => _savedCities;
// A convenience getter for the count (used in the UI header)
int get cityCount => _savedCities.length;
// ============================================================
// METHODS — the only way to modify the data
// ============================================================
/// Adds a new city to the list and notifies all listeners.
///
/// notifyListeners() is the KEY line. Without it, the data changes
/// but no widget knows about it — the UI stays stale.
/// With it, every widget watching this provider rebuilds instantly.
void addCity(Map<String, String> city) {
_savedCities.add(city);
notifyListeners(); // ← "Hey everyone! The data changed! Rebuild!"
}
/// Removes a city by index and notifies all listeners.
void removeCity(int index) {
_savedCities.removeAt(index);
notifyListeners();
}
}