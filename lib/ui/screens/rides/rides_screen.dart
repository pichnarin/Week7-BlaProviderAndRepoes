import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/model/ride/ride.dart';
import '../../../data/model/ride/ride_filter.dart';
import '../../../data/model/ride/ride_pref.dart';
import '../../provider/ride_prefs_provider.dart';
import 'widgets/ride_pref_bar.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ridesPreferencesProvider =
        Provider.of<RidesPreferencesProvider>(context);
    RidePreference currentPreference =
        ridesPreferencesProvider.currentPreference!;
    RideFilter currentFilter = RideFilter();
    List<Ride> matchingRides =
        RidesService.instance.getRidesFor(currentPreference, currentFilter);

    void onBackPressed() {
      Navigator.of(context).pop();
    }

    void onPreferencePressed() async {
      RidePreference? newPreference = await Navigator.of(
        context,
      ).push<RidePreference>(
        AnimationUtils.createTopToBottomRoute(
          RidePrefModal(initialPreference: currentPreference),
        ),
      );

      if (newPreference != null) {
        ridesPreferencesProvider.setCurrentPreference(newPreference);
      }
    }

    void onFilterPressed() {}

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            RidePrefBar(
              ridePreference: currentPreference,
              onBackPressed: onBackPressed,
              onPreferencePressed: onPreferencePressed,
              onFilterPressed: onFilterPressed,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
