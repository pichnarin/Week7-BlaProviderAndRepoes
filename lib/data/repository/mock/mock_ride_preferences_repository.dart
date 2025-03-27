import '../../model/location/locations.dart';
import '../../model/ride/ride_pref.dart';
import '../ride_preferences_repository.dart';

class MockRidePreferencesRepository implements RidePreferencesRepository {
  final List<RidePreference> _preferences = [
    RidePreference(
      departure: Location(name: 'Phnom Penh', country: Country.cambodia),
      departureDate: DateTime.now(),
      arrival: Location(name: 'Siem Reap', country: Country.cambodia),
      requestedSeats: 2,
    ),
    RidePreference(
      departure: Location(name: 'Battambang', country: Country.cambodia),
      departureDate: DateTime.now().add(Duration(days: 1)),
      arrival: Location(name: 'Kampot', country: Country.cambodia),
      requestedSeats: 3,
    ),
  ];



  @override
  Future<List<RidePreference>> getPastPreferences() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));
    return _preferences;
  }

  @override
  Future<void> addPastPreference(RidePreference preference) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));
    _preferences.add(preference);
  }
}
