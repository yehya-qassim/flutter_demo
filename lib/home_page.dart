import 'package:demo/services/device_info_service.dart';
import 'package:demo/services/location_service.dart';
import 'package:demo/services/mobile_sim_info.dart';
import 'package:demo/services/network_info.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mobile_number/mobile_number.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //variable for the ip addresses
  String? ipv4, ipv6;

  //variables for Phone number and carrier name
  String? mobileNumber, carrierName;

  //variables for Device name and brand name
  String? deviceName, brandName;

  //Location variable
  LocationData? locationData;

  //variables for screen resolution
  String? width, height;

  @override
  void initState() {

    //Init app functions
    initAppFunctions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Init screen info
    initScreenInfo(context);

    //returning a scaffold as main widget
    return Scaffold(
      appBar: AppBar(
        //setting app bar title to the title was sent to this class
        title: Text(widget.title),
        //centering the title
        centerTitle: true,
      ),
      //returning a padding as body of scaffold
      body: Padding(
        //setting padding to all sides
        padding: const EdgeInsets.all(16.0),
        //returning single child scroll view in order to make the screen scrollable
        child: SingleChildScrollView(
          //returning a column to hold all other widgets in the screen
          child: Column(
            //setting the alignment to start (from left)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //returning widgets containing the data for the app

              //center to center it as title
              Center(
                //text to put the text inside it and giving some styles to the text
                  child: Text('Network Info:', style: _style(),)),
              //sized box to make a space for the next widget
              const SizedBox(height: 15,),
              Text('IPv4: $ipv4', style: _style(),),
              const SizedBox(height: 10,),
              Text('IPv6: $ipv6', style: _style(),),

              const SizedBox(height: 50,),
              Center(child: Text('Carrier Info:', style: _style(),)),
              const SizedBox(height: 15,),
              Text('Mobile Number: ${mobileNumber ?? ''}', style: _style(),),
              const SizedBox(height: 10,),
              Text('Carrier Names: ${carrierName ?? ''}', style: _style(),),

              const SizedBox(height: 50,),
              Center(child: Text('Device info:', style: _style(),)),
              const SizedBox(height: 15,),
              Text('Device Name: $deviceName', style: _style(),),
              const SizedBox(height: 10,),
              Text('Brand Name: $brandName', style: _style(),),

              const SizedBox(height: 50,),
              Center(child: Text('Location info:', style: _style(),)),
              const SizedBox(height: 15,),
              Text('Latitude: ${locationData != null ? locationData!.latitude : ''}', style: _style(),),
              const SizedBox(height: 10,),
              Text('Longitude: ${locationData != null ? locationData!.longitude : ''}', style: _style(),),

              const SizedBox(height: 50,),
              Center(child: Text('Screen info:', style: _style(),)),
              const SizedBox(height: 15,),
              Text('Width: $width', style: _style(),),
              const SizedBox(height: 10,),
              Text('Height: $height', style: _style(),),
            ],
          ),
        ),
      ),
    );
  }

  // a function of text style so we just call it every time instead of writing the style each time
  TextStyle _style() => const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  //init function to get the ip addresses
  Future<void> _initNetworkInfo() async {
    //init a new variable of the service variable
    final NetworkInfoService networkInfoService = NetworkInfoService();

    //getting the ip addresses
    final _ipv4 = await networkInfoService.getIPV4();
    final _ipv6 = await networkInfoService.getIPV6();

    //setting the state for the ip addresses to reload the page with the current data
    setState(() {
      ipv4 = _ipv4;
      ipv6 = _ipv6;
    });
  }

  //A function to init mobile number and carrier names
  Future<void> initMobileNumber() async {
    //initializing the service
    final MobileSimInfo mobileSimInfo = MobileSimInfo();

    final hasPermission = await mobileSimInfo.checkPermission();
    if(hasPermission){
      //getting the values of mobile number and carrier names
      final String _mobileNumber = await mobileSimInfo.getMobileNumber();
      final String _carrierName = await mobileSimInfo.getCarrierName();

      //setting the values to variables to reload the page with the current data
      setState(() {
        mobileNumber = _mobileNumber;
        carrierName = _carrierName;
      });
    }
  }

  // A function to init the device name and brand name
  Future<void> initDeviceInfo() async {
    //init the service
    final DeviceInfoService _deviceInfo = DeviceInfoService();

    //getting the device name and brand name
    final String _deviceName = await _deviceInfo.getDeviceName();
    final String _brandName = await _deviceInfo.getBrandName();

    //setting the values to variables to reload the page with the current data
    setState(() {
      deviceName = _deviceName;
      brandName = _brandName;
    });
  }

  //A function to get location info
  Future<void> initLocation() async {
    //init a new variable of the service variable
    final LocationService locationService = LocationService();

    //getting the location data variable
    final _locationData = await locationService.getLocationData();

    //setting the state for the variable to reload the page with the current data
    setState(() {
      locationData = _locationData;
    });
  }

  // A function to get screen info
  Future<void> initScreenInfo(BuildContext context) async {

    //getting the width and height
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    //setting the state for the variable to reload the page with the current data
    setState(() {
      width = _width.toString();
      height = _height.toString();
    });
  }

  Future<void> initAppFunctions() async {
    //init network info
    await _initNetworkInfo();

    //init device info
    await initDeviceInfo();

    //init Location info
    await initLocation();

    //init mobile info


    MobileNumber.listenPhonePermission((isPermissionGranted) async {
      if (isPermissionGranted) {
        await initMobileNumber();
      } else {}
    });

    await initMobileNumber();

  }
}