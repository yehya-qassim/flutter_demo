import 'package:network_info_plus/network_info_plus.dart';


//A service to get the local ip address
class NetworkInfoService {

  //variable of network info type
  NetworkInfo? _networkInfo;
  NetworkInfoService() {
    //initializing the networkInfo variable
     _networkInfo = NetworkInfo();
  }

  // a function that return the ip v4
  Future<String> getIPV4() async {
    //getting the ip
    final String? ip = await _networkInfo!.getWifiIP();
    //checking if the ip is null or empty
    if(ip != null && ip != ''){
      return ip;
    }
    return 'Could\nt get ip v4';
  }

  // a function that return the ip v6
  Future<String> getIPV6() async {
    //getting the ip
    final String? ip = await _networkInfo!.getWifiIPv6();
    //checking if the ip is null or empty
    if(ip != null && ip != ''){
      return ip;
    }
    return 'Could\nt get ip v6';
  }

}