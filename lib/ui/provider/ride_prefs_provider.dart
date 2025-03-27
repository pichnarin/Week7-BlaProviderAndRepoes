import 'package:flutter/cupertino.dart';
import '../../data/model/ride/ride_pref.dart';
import '../../data/repository/local/local_ride_pref_repo.dart';
import 'asynv_value.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  final LocalRidePreferencesRepository repository = LocalRidePreferencesRepository();
  RidePreference? _currentPreference;
  AsyncValue<List<RidePreference>> pastPreferences = AsyncValue.loading();

  RidesPreferencesProvider() {
    _initializePreferences();
  }

  RidePreference? get currentPreference => _currentPreference;

  Future<void> _initializePreferences() async {
    await fetchPastPreferences();
  }

  Future<void> fetchPastPreferences() async {
    pastPreferences = AsyncValue.loading();
    notifyListeners(); // Ensure UI updates immediately

    try {
      List<RidePreference> pastPrefs = await repository.getPastPreferences();
      print('Fetched preferences: $pastPrefs'); // Debugging line
      pastPreferences = AsyncValue.data(pastPrefs);
    } catch (error) {
      print('Error fetching preferences: $error'); // Debugging line
      pastPreferences = AsyncValue.error('Failed to fetch preferences: $error');
    }
    notifyListeners(); // Make sure UI updates after fetching data
  }

  Future<void> addPreference(RidePreference preference) async {
    try {
      await repository.addPastPreference(preference);
      await fetchPastPreferences();
    } catch (error) {
      // Optionally show an error to the UI
      print('Error adding preference: $error');
    }
  }

  void setCurrentPreference(RidePreference newPreference) {
    if (newPreference != _currentPreference) {
      _currentPreference = newPreference;
      addPreference(newPreference);
      notifyListeners();
    }
  }
}
