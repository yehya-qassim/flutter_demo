import 'package:carrier_info/carrier_info.dart';
import 'package:demo/services/device_info_service.dart';
import 'package:demo/services/location_service.dart';
import 'package:demo/services/network_info.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sms_autofill/sms_autofill.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //variable for the ip addresses
  String? ip;

  //variables for Phone number and carrier name
  String? mobileNumber, carrierName;

  //variables for Device name and brand name
  String? deviceName, brandName;

  //Location variables
  String? countryName, city;

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
                  child: Text(
                    'Network Info:',
                    style: _style(),
                  )),
              //sized box to make a space for the next widget
              const SizedBox(
                height: 15,
              ),
              Text(
                'Public IP address: ${ip ?? 'Loading ...'}',
                style: _style(),
              ),

              const SizedBox(
                height: 50,
              ),
              Center(
                  child: Text(
                    'Carrier Info:',
                    style: _style(),
                  )),
              const SizedBox(
                height: 15,
              ),

              Text(
                'Carrier Names: ${carrierName ?? 'Loading ...'}',
                style: _style(),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Mobile Number: ${mobileNumber ?? 'Loading ...'}',
                style: _style(),
              ),

              const SizedBox(
                height: 50,
              ),
              Center(
                  child: Text(
                    'Device info:',
                    style: _style(),
                  )),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Device Name: ${deviceName ?? 'Loading ...'}',
                style: _style(),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Brand Name: ${brandName ?? 'Loading ...'}',
                style: _style(),
              ),

              const SizedBox(
                height: 50,
              ),
              Center(
                  child: Text(
                    'Location info:',
                    style: _style(),
                  )),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Country: ${countryName ?? 'Loading ...'}',
                style: _style(),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'City: ${city ?? 'Loading ...'}',
                style: _style(),
              ),

              const SizedBox(
                height: 50,
              ),
              Center(
                  child: Text(
                    'Screen info:',
                    style: _style(),
                  )),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Width: ${width ?? 'Loading ...'}',
                style: _style(),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Height: ${height ?? 'Loading ...'}',
                style: _style(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // a function of text style so we just call it every time instead of writing the style each time
  TextStyle _style() =>
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  //init function to get the ip addresses
  Future<void> _initNetworkInfo() async {
    //getting the ip addresses
    final _ip = await NetworkInfoService.getPublicIP();

    //setting the state for the ip addresses to reload the page with the current data
    setState(() {
      ip = _ip;
    });
  }

  //A function to get the carrier name
  Future<void> initCarrierInfo() async{
    //getting the name
    final String? carrierInfo = await CarrierInfo.carrierName;

    //setting the value to variables to reload the page with the current data
    setState(() {
      carrierName = carrierInfo;
    });
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
    final Placemark? _placeMark = await locationService.getLocationData();

    //setting the state for the variable to reload the page with the current data
    if (_placeMark != null) {
      setState(() {
        countryName = _placeMark.country;
        city = _placeMark.administrativeArea;
      });
    }
  }

  // A function to get screen info
  Future<void> initScreenInfo(BuildContext context) async {
    //getting the width and height
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    //setting the state for the variable to reload the page with the current data
    setState(() {
      width = _width.toStringAsFixed(2);
      height = _height.toStringAsFixed(2);
    });
  }

  // A function to get screen info
  Future<void> initMobileInfo() async {

    final SmsAutoFill autoFill = SmsAutoFill();
    final String? hint = await autoFill.hint;

     setState(() {
       mobileNumber = hint;
     });
  }

  Future<void> initAppFunctions() async {
    //init network info
     _initNetworkInfo();

    //init device info
     initDeviceInfo();

     //init carrier info
     initCarrierInfo();

     //init location
     initLocation();

     //init mobile
    initMobileInfo();

  }
}