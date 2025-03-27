import '../../data/model/location/locations.dart';
import '../../data/repository/mock/mock_locations_repository.dart';

class LocationProvider extends MockLocationsRepository{

  //fetch all the current location that create dynamic in the location_mock_repo
  List<Location> fetchAllLocations(){
    return getLocations();
  }
}


