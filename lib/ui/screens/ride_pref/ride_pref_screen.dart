import 'package:flutter/material.dart';
      import 'package:provider/provider.dart';
      import '../../../model/ride/ride_pref.dart';
      import '../../../provider/asynv_value.dart';
      import '../../../provider/ride_prefs_provider.dart';
      import '../../../utils/animations_util.dart';
      import '../../theme/theme.dart';
      import '../rides/rides_screen.dart';
      import 'widgets/ride_pref_form.dart';
      import 'widgets/ride_pref_history_tile.dart';

      const String blablaHomeImagePath = 'assets/images/blabla_home.png';

      class RidePrefScreen extends StatelessWidget {
        const RidePrefScreen({super.key});

        @override
        Widget build(BuildContext context) {
          return Consumer<RidesPreferencesProvider>(
            builder: (context, ridesPreferencesProvider, child) {
              RidePreference? currentRidePreference = ridesPreferencesProvider.currentPreference;
              final AsyncValue<List<RidePreference>> pastPreferences = ridesPreferencesProvider.pastPreferences;

              void onRidePrefSelected(RidePreference newPreference) async {
                // update the current preference using the provider
                ridesPreferencesProvider.setCurrentPreference(newPreference);

                //navigate to the rides screen (with a bottom-to-top animation)
                await Navigator.of(context)
                    .push(AnimationUtils.createBottomToTopRoute(RidesScreen()));
              }

              return Stack(
                children: [
                  //background Image
                  const BlaBackground(),

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
                            //display the Form to input the ride preferences
                            RidePrefForm(
                              initialPreference: currentRidePreference,
                              onSubmit: onRidePrefSelected,
                            ),
                            SizedBox(height: BlaSpacings.m),

                            //optionally display a list of past preferences
                            SizedBox(
                              height: 200, // Set a fixed height
                              child: _buildPastPreferences(pastPreferences, onRidePrefSelected),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        }

        Widget _buildPastPreferences(AsyncValue<List<RidePreference>> pastPreferences, void Function(RidePreference) onRidePrefSelected) {
          if (pastPreferences.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (pastPreferences.error != null) {
            return Center(child: Text('Error: ${pastPreferences.error}'));
          }

          if (pastPreferences.data != null) {
            List<RidePreference> preferences = pastPreferences.data!;
            return ListView.builder(
              shrinkWrap: true, // Fix ListView height issue
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: preferences.length,
              itemBuilder: (ctx, index) => RidePrefHistoryTile(
                ridePref: preferences[index],
                onPressed: () => onRidePrefSelected(preferences[index]),
              ),
            );
          }

          return Center(child: Text('No ride preferences available.'));
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
              fit: BoxFit.cover,
            ),
          );
        }
      }