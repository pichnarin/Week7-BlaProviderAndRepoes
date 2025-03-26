import 'package:week_3_blabla_project/model/location/locations.dart';
import 'package:week_3_blabla_project/repository/mock/mock_locations_repository.dart';

class LocationProvider extends MockLocationsRepository{

  //fetch all the current location that create dynamic in the location_mock_repo
  List<Location> fetchAllLocations(){
    return getLocations();
  }
}


