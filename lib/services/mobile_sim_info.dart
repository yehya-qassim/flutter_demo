import 'package:mobile_number/mobile_number.dart';


// A service to get mobile number and carrier info
class MobileSimInfo {

  // A function to check for permission if granted or not
  //private method so it can't be called outside this class
  Future<bool> checkPermission() async {
    try{
      final permissionGranted = await MobileNumber.hasPhonePermission;
      if (!permissionGranted) {
        //if permission hasn't been granted request a permission
        await MobileNumber.requestPhonePermission;
        return true;
      }
      return true;
    } catch(e) {
      return false;
    }

  }

  //A function to get the mobile number
  Future<String> getMobileNumber() async {

    //getting the mobile number
    final String? mobileNumber = await MobileNumber.mobileNumber;

    //checking if the mobile number is null
    if(mobileNumber != null && mobileNumber != '') {
      //if not null or empty return it
      return mobileNumber;
    }

    //if its null it will return a failure message
    return 'Could\'nt get mobile number';
  }

  //A function to get the carrier name
  Future<String> getCarrierName() async {

    //getting a list of the sims
    final List<SimCard>? simCards = await MobileNumber.getSimCards;

    String? carrierName;
    //if sims are not null or empty
    if(simCards != null && simCards.isNotEmpty){

      //looping through the list of sims
      for(var sim in simCards){
        //for each sim we are adding the name of it to the carrierName variable
        carrierName = '${carrierName ?? ''}-${sim.carrierName}- ';
      }
    }

    //returning either carrierName or failure message in case the carrierName is null
    return carrierName ?? 'Could\'nt get carrier name';
  }
}