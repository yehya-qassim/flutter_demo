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
  Future<void> _checkPermission() async {
    //check if the location service is enabled
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled!) {
      //if not request enabling it
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    //check if permission is granted
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      //if not request permission
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  //A function to get the location data
  Future<geo_ocation.Placemark?> getLocationData() async {
    //first check permission
    await _checkPermission();

    //return the location data
    final LocationData? locationData = await _location.getLocation();

    //getting place mark such as country name
    List<geo_ocation.Placemark> placemarks = await geo_ocation.placemarkFromCoordinates(
        locationData!.latitude!, locationData.longitude!);
    final place = placemarks[0];
    return place;
  }

}