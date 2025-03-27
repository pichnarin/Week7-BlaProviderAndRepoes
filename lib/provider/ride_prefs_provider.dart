// provider/rides_preferences_provider.dart
import 'package:flutter/material.dart';
import '../model/location/locations.dart';
import '../model/ride/ride_pref.dart';
import '../repository/mock/mock_ride_preferences_repository.dart';
import '../repository/ride_preferences_repository.dart';
import 'asynv_value.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  final RidePreferencesRepository repository;
  RidePreference? _currentPreference;
  late AsyncValue<List<RidePreference>> pastPreferences;

  RidesPreferencesProvider(this.repository) {
    _initializePreferences();
  }

  RidePreference? get currentPreference => _currentPreference;

  Future<void> _initializePreferences() async {
    await fetchPastPreferences();
  }

  Future<void> fetchPastPreferences() async {
    pastPreferences = AsyncValue.loading(); // Set to loading initially
    notifyListeners();
    try {
      List<RidePreference> pastPrefs = await repository.getPastPreferences();
      pastPreferences = AsyncValue.data(pastPrefs); // Update with fetched data
    } catch (error) {
      pastPreferences = AsyncValue.error(error.toString()); // Set error if something goes wrong
    }
    notifyListeners();
  }


  Future<void> addPreference(RidePreference preference) async {
    await repository.addPreference(preference);
    await fetchPastPreferences();
  }

  void setCurrentPreference(RidePreference newPreference) {
    if (newPreference != _currentPreference) {
      _currentPreference = newPreference;
      addPreference(newPreference);
      notifyListeners();
    }
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
  print(ridesPreferencesProvider.pastPreferences);
}

