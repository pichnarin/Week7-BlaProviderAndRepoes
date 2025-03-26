import 'package:flutter/material.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../provider/ride_prefs_provider.dart';
import '../../../utils/animations_util.dart';
import '../../theme/theme.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';
import 'package:provider/provider.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the provider to get the current preference and history
    var ridesPreferencesProvider = Provider.of<RidesPreferencesProvider>(context);
    RidePreference? currentRidePreference = ridesPreferencesProvider.currentPreference;
    List<RidePreference> pastPreferences = ridesPreferencesProvider.preferencesHistory;

    void onRidePrefSelected(RidePreference newPreference) async {
      // 1 - Update the current preference using the provider
      ridesPreferencesProvider.setCurrentPreference(newPreference);

      // 2 - Navigate to the rides screen (with a bottom-to-top animation)
      await Navigator.of(context)
          .push(AnimationUtils.createBottomToTopRoute(RidesScreen()));

      // setState(() {});
      // No need for setState, the provider will notify listeners and rebuild the widget tree.
    }

    return Stack(
      children: [
        BlaBackground(),

        // foreground content
        Column(
          children: [
            SizedBox(height: BlaSpacings.m),
            Text(
              "Your pick of rides at low price",
              style: BlaTextStyles.heading.copyWith(color: Colors.white),
            ),
            SizedBox(height: 100),
            Container(
              margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //display the form to input the ride preferences
                  RidePrefForm(
                      initialPreference: currentRidePreference,
                      onSubmit: onRidePrefSelected),
                  SizedBox(height: BlaSpacings.m),

                 // display a list of past preferences
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: pastPreferences.length,
                      itemBuilder: (ctx, index) => RidePrefHistoryTile(
                        ridePref: pastPreferences[index],
                        onPressed: () =>
                            onRidePrefSelected(pastPreferences[index]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}
