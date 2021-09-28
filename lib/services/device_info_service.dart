
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';


// A service to get device info
class DeviceInfoService {

  // initialization some variables to be used
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  IosDeviceInfo? _iosDeviceInfo;
  AndroidDeviceInfo? _androidDeviceInfo;

  // a flag variable in order to do some checks
  bool _isIOS = false;

  //a function to check if the device is android or iphone then fill the device info variables and the flag variable
  Future<void> _checkPlatform() async {
    //checking if platform is android
    if (Platform.isAndroid) {
      //if so set ios flag to false
      _isIOS = false;
      //then init the android info variable
      _androidDeviceInfo = await _deviceInfoPlugin.androidInfo;
      //checking if platform is ios
    } else if (Platform.isIOS) {
      //if so set ios flag to true
      _isIOS = true;
      //then init the ios info variable
      _iosDeviceInfo = await _deviceInfoPlugin.iosInfo;
    }
  }

  //A function to get the device brand name
  Future<String> getBrandName() async {

    await _checkPlatform();

    String? branName;
    //checking if the device is ios
    if(_isIOS){
      //making sure the ios variable isn't null before accessing it
      if(_iosDeviceInfo != null){
        //setting the brand name of the device
        branName = _iosDeviceInfo!.model;
      }
      //if android
    }else {
      //making sure the ios variable isn't null before accessing it
      if(_androidDeviceInfo != null){
        //setting the brand name of the device
        branName = _androidDeviceInfo!.brand;
      }
    }

    //returning the brand name or a failure message in case it is null
    return branName ?? 'Could\'nt get brand name';
  }

  //A function to get the device name
  Future<String> getDeviceName() async {

    await _checkPlatform();

    String? deviceName;

    //checking if it is ios
    if(_isIOS){
      //making sure the variable isn't null before accessing it
      if(_iosDeviceInfo != null){
        //setting the device name
        deviceName = _iosDeviceInfo!.name;
      }
    }else {
      //making sure the variable isn't null before accessing it
      if(_androidDeviceInfo != null){
        //setting the device name
        deviceName = _androidDeviceInfo!.device;
      }
    }

    //returning either the device name or a failure message
    return deviceName ?? 'Could\'nt get brand name';
  }
}