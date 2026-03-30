import 'package:flutter/material.dart';
import '../data/travel_repository.dart';

/// Provider that manages the list of saved cities.
///
/// Delegates all persistence to TravelRepository.
/// Holds the in-memory list and notifies listeners on changes.
class TravelProvider extends ChangeNotifier {
  final TravelRepository _repository;

  // --- Private state ---
  List<Map<String, String>> _savedCities = [];
  bool _isLoaded = false;

  // --- Public getters ---
  List<Map<String, String>> get savedCities => List.unmodifiable(_savedCities);
  int get cityCount => _savedCities.length;
  bool get isLoaded => _isLoaded;

  // Constructor — receives repository, loads data from disk
  TravelProvider(this._repository) {
    _init();
  }

  Future<void> _init() async {
    _savedCities = await _repository.loadCities();
    _isLoaded = true;
    notifyListeners();
  }

  /// Adds a new city and persists the updated list.
  Future<void> addCity(Map<String, String> city) async {
    _savedCities.add(city);
    notifyListeners();
    await _repository.saveCities(_savedCities);
  }

  /// Removes a city by index and persists the updated list.
  Future<void> removeCity(int index) async {
    _savedCities.removeAt(index);
    notifyListeners();
    await _repository.saveCities(_savedCities);
  }

  /// Clears all cities and wipes them from disk.
  Future<void> clearAllCities() async {
    _savedCities.clear();
    notifyListeners();
    await _repository.clearCities();
  }
}
