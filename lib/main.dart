import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'repository/mock/mock_locations_repository.dart';
  import 'repository/mock/mock_rides_repository.dart';
  import 'repository/mock/mock_ride_preferences_repository.dart';
  import 'provider/ride_prefs_provider.dart';
  import 'service/locations_service.dart';
  import 'service/rides_service.dart';
  import 'ui/screens/ride_pref/ride_pref_screen.dart';
  import 'ui/theme/theme.dart';

  void main() {
    // Initialize the services
    LocationsService.initialize(MockLocationsRepository());
    RidesService.initialize(MockRidesRepository());

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => RidesPreferencesProvider(MockRidePreferencesRepository()),
          ),
        ],
        child: const MyApp(),
      ),
    );
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: Scaffold(body: RidePrefScreen()),
      );
    }
  }