import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo_ocation;

//A service for getting the location
class LocationService {

  //some variables for using in the service
  late Location _location;
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;

  //initializing the location
  LocationService() {
    _location = Location();
  }

  //A function to check for permission
  Future<bool> _checkPermission() async {
    //check if the location service is enabled
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled!) {
      //if not request enabling it
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled!) {
        return false;
      }
    }

    //check if permission is granted
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      //if not request permission
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  //A function to get the location data
  Future<geo_ocation.Placemark?> getLocationData() async {
    //first check permission
    if(await _checkPermission()){
      //return the location data
      final LocationData? locationData = await _location.getLocation();

      //getting place mark such as country name
      List<geo_ocation.Placemark> placeMarks = await geo_ocation.placemarkFromCoordinates(
          locationData!.latitude!, locationData.longitude!);
      final place = placeMarks[0];
      return place;
    }

    return null;

  }

}