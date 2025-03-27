import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/model/ride/ride_pref.dart';
import '../../../utils/animations_util.dart';
import '../../provider/asynv_value.dart';
import '../../provider/ride_prefs_provider.dart';
import '../../theme/theme.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

class RidePrefScreen extends StatefulWidget {
  const RidePrefScreen({super.key});

  @override
  _RidePrefScreenState createState() => _RidePrefScreenState();
}

class _RidePrefScreenState extends State<RidePrefScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<RidesPreferencesProvider>(context, listen: false)
          .fetchPastPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RidesPreferencesProvider>(
      builder: (context, ridesPreferencesProvider, child) {
        RidePreference? currentRidePreference = ridesPreferencesProvider
            .currentPreference;
        final AsyncValue<
            List<RidePreference>> pastPreferences = ridesPreferencesProvider
            .pastPreferences;

        void onRidePrefSelected(RidePreference newPreference) async {
          ridesPreferencesProvider.setCurrentPreference(newPreference);
          await Navigator.of(context)
              .push(AnimationUtils.createBottomToTopRoute(RidesScreen()));
        }

        return Stack(
          children: [
            const BlaBackground(),
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
                      RidePrefForm(
                        initialPreference: currentRidePreference,
                        onSubmit: onRidePrefSelected,
                      ),
                      SizedBox(height: BlaSpacings.m),
                      SizedBox(
                        height: 200,
                        child: _buildPastPreferences(
                            pastPreferences, onRidePrefSelected),
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

  Widget _buildPastPreferences(AsyncValue<List<RidePreference>> pastPreferences,
      void Function(RidePreference) onRidePrefSelected) {
    if (pastPreferences.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (pastPreferences.error != null) {
      return Center(child: Text('Error: ${pastPreferences.error}'));
    }

    if (pastPreferences.value != null && pastPreferences.value!.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: pastPreferences.value!.length,
        itemBuilder: (ctx, index) =>
            RidePrefHistoryTile(
              ridePref: pastPreferences.value![index],
              onPressed: () =>
                  onRidePrefSelected(pastPreferences.value![index]),
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