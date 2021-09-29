import 'package:dart_ipify/dart_ipify.dart';


//A service to get the local ip address
class NetworkInfoService {
  //to prevent initializing this class so all methods in this class are static
  NetworkInfoService._();

  // a function that return the ip v4
  static Future<String> getPublicIP() async {
    //getting the ip
    final String? ip = await Ipify.ipv4(format: Format.TEXT);
    //checking if the ip is null or empty
    if(ip != null && ip != ''){
      return ip;
    }
    return 'Could not get ip address';
  }

}