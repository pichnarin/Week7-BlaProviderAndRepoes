import 'package:flutter/material.dart';
import '../model/location/locations.dart';
import '../model/ride/ride_pref.dart';
import '../repository/mock/mock_ride_preferences_repository.dart';
import '../repository/ride_preferences_repository.dart';


class RidesPreferencesProvider extends ChangeNotifier {
  final RidePreferencesRepository repository;
  RidePreference? _currentPreference;
  List<RidePreference> _preferencesHistory = [];

  // Constructor to inject the repository
  RidesPreferencesProvider(this.repository) {
    _initializePreferences();
  }

  // Getter for current preference
  RidePreference? get currentPreference => _currentPreference;

  // Getter for preferences history (from newest to oldest)
  List<RidePreference> get preferencesHistory => List.unmodifiable(_preferencesHistory);

  // Set the current preference
  void setCurrentPreference(RidePreference newPreference) {
    if (newPreference != _currentPreference) {
      _currentPreference = newPreference;

      if (!_preferencesHistory.contains(newPreference)) {
        _preferencesHistory.insert(0, newPreference);
      }

      repository.addPreference(newPreference);

      notifyListeners();
    }
  }

  // Initialize preferences by loading past preferences from the repository
  void _initializePreferences() {
    _preferencesHistory = repository.getPastPreferences();
    if (_preferencesHistory.isNotEmpty) {
      _currentPreference = _preferencesHistory.first;
    }
    notifyListeners();
  }
}


void main() {
  final repository = MockRidePreferencesRepository();
  final ridesPreferencesProvider = RidesPreferencesProvider(repository);

  // Example locations
  final departure = Location(name: "Phnom Penh", country: Country.cambodia);
  final arrival = Location(name: "Paris", country: Country.france);

  // Initialize preferences (automatically done in the provider constructor)
  print(ridesPreferencesProvider.currentPreference);

  // Add a new preference
  final newPreference = RidePreference(
    departure: departure,
    departureDate: DateTime(2025, 3, 21, 10, 30),
    arrival: arrival,
    requestedSeats: 2,
  );

  // Set the new preference as the current one
  ridesPreferencesProvider.setCurrentPreference(newPreference);

  // Access the current preference and history
  print(ridesPreferencesProvider.currentPreference);
  print(ridesPreferencesProvider.preferencesHistory);
}

