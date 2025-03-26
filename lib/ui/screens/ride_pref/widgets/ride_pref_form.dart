import 'package:flutter/material.dart';

  import '../../../../model/location/locations.dart';
  import '../../../../model/ride/ride_pref.dart';
  import '../../../theme/theme.dart';
  import '../../../../utils/animations_util.dart';
  import '../../../../utils/date_time_util.dart';
  import '../../../widgets/actions/bla_button.dart';
  import '../../../widgets/display/bla_divider.dart';
  import '../../../widgets/inputs/bla_location_picker.dart';
  import 'ride_pref_input_tile.dart';

  class RidePrefForm extends StatefulWidget {
    const RidePrefForm({
      super.key,
      required this.initialPreference,
      required this.onSubmit,
    });

    final RidePreference? initialPreference;
    final Function(RidePreference preference) onSubmit;

    @override
    State<RidePrefForm> createState() => _RidePrefFormState();
  }

  class _RidePrefFormState extends State<RidePrefForm> {
    Location? departure;
    late DateTime departureDate;
    Location? arrival;
    late int requestedSeats;

    @override
    void initState() {
      super.initState();
      _initializeForm();
    }

    @override
    void didUpdateWidget(RidePrefForm oldWidget) {
      super.didUpdateWidget(oldWidget);
      if (widget.initialPreference != oldWidget.initialPreference) {
        _initializeForm();
      }
    }

    void _initializeForm() {
      if (widget.initialPreference != null) {
        RidePreference current = widget.initialPreference!;
        departure = current.departure;
        arrival = current.arrival;
        departureDate = current.departureDate;
        requestedSeats = current.requestedSeats;
      } else {
        departure = null;
        departureDate = DateTime.now();
        arrival = null;
        requestedSeats = 1;
      }
    }

    void onDeparturePressed() async {
      Location? selectedLocation = await Navigator.of(context).push<Location>(
        AnimationUtils.createBottomToTopRoute(
          BlaLocationPicker(initLocation: departure),
        ),
      );

      if (selectedLocation != null) {
        setState(() {
          departure = selectedLocation;
        });
      }
    }

    void onArrivalPressed() async {
      Location? selectedLocation = await Navigator.of(context).push<Location>(
        AnimationUtils.createBottomToTopRoute(
          BlaLocationPicker(initLocation: arrival),
        ),
      );

      if (selectedLocation != null) {
        setState(() {
          arrival = selectedLocation;
        });
      }
    }

    void onSubmit() {
      bool hasDeparture = departure != null;
      bool hasArrival = arrival != null;
      bool isValid = hasDeparture && hasArrival;

      if (isValid) {
        RidePreference newPreference = RidePreference(
          departure: departure!,
          departureDate: departureDate,
          arrival: arrival!,
          requestedSeats: requestedSeats,
        );

        widget.onSubmit(newPreference);
      }
    }

    void onSwappingLocationPressed() {
      setState(() {
        if (departure != null && arrival != null) {
          Location temp = departure!;
          departure = Location.copy(arrival!);
          arrival = Location.copy(temp);
        }
      });
    }

    String get departureLabel =>
        departure != null ? departure!.name : "Leaving from";
    String get arrivalLabel => arrival != null ? arrival!.name : "Going to";

    bool get showDeparturePLaceHolder => departure == null;
    bool get showArrivalPLaceHolder => arrival == null;

    String get dateLabel => DateTimeUtils.formatDateTime(departureDate);
    String get numberLabel => requestedSeats.toString();

    bool get switchVisible => arrival != null && departure != null;

    @override
    Widget build(BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: BlaSpacings.m),
            child: Column(
              children: [
                RidePrefInputTile(
                  isPlaceHolder: showDeparturePLaceHolder,
                  title: departureLabel,
                  leftIcon: Icons.location_on,
                  onPressed: onDeparturePressed,
                  rightIcon: switchVisible ? Icons.swap_vert : null,
                  onRightIconPressed:
                      switchVisible ? onSwappingLocationPressed : null,
                ),
                const BlaDivider(),
                RidePrefInputTile(
                  isPlaceHolder: showArrivalPLaceHolder,
                  title: arrivalLabel,
                  leftIcon: Icons.location_on,
                  onPressed: onArrivalPressed,
                ),
                const BlaDivider(),
                RidePrefInputTile(
                  title: dateLabel,
                  leftIcon: Icons.calendar_month,
                  onPressed: () => {},
                ),
                const BlaDivider(),
                RidePrefInputTile(
                  title: numberLabel,
                  leftIcon: Icons.person_2_outlined,
                  onPressed: () => {},
                ),
              ],
            ),
          ),
          BlaButton(text: 'Search', onPressed: onSubmit),
        ],
      );
    }
  }