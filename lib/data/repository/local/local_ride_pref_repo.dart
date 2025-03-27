import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../dto/ride_pref_dto.dart';
import '../../model/ride/ride_pref.dart';
import '../ride_preferences_repository.dart';

class LocalRidePreferencesRepository extends RidePreferencesRepository {
  static const String _preferencesKey = "ride_preferences";

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final prefsList = prefs.getStringList(_preferencesKey) ?? [];

    print('Loaded preferences from SharedPreferences: $prefsList'); // Debugging

    return prefsList.map((json) => RidePreferenceDto.fromJson(jsonDecode(json))).toList();
  }

  @override
  Future<void> addPastPreference(RidePreference newPreference) async {
    final pastPreferences = await getPastPreferences();

    print('Before adding new preference: $pastPreferences'); // Debugging

    pastPreferences.add(newPreference);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _preferencesKey,
      pastPreferences.map((pref) => jsonEncode(RidePreferenceDto.toJson(pref))).toList(),
    );

    print('After adding new preference: $pastPreferences'); // Debugging
  }
}
