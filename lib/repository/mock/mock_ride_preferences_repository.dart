// repository/mock/mock_ride_preferences_repository.dart
import 'dart:async';
import '../../model/ride/ride_pref.dart';
import '../ride_preferences_repository.dart';

class MockRidePreferencesRepository implements RidePreferencesRepository {
  final List<RidePreference> _preferences = [];

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));
    return _preferences;
  }

  @override
  Future<void> addPreference(RidePreference preference) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));
    _preferences.add(preference);
  }
}