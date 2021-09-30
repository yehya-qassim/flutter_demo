import 'package:flutter/services.dart';
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
    await _checkService();

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
    List<geo_ocation.Placemark> placeMarks = await geo_ocation.placemarkFromCoordinates(
        locationData!.latitude!, locationData.longitude!);
    final place = placeMarks[0];
    return place;
  }

  //checking if service is enabled
  _checkService() async {
    try {
      _serviceEnabled = await _location.serviceEnabled();
    } on PlatformException catch (err) {
      //on some android devices the check may take a little longer so we should wait till this function works without exception
      _serviceEnabled = false;

      // location service is still not created
      await _checkService(); // re-invoke itself every time the error is catch, so until the location service setup is complete
    }
  }


}