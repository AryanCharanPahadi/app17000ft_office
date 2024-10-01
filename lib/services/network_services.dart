import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:app17000ft_new/home/home_screen.dart';
import 'package:app17000ft_new/utils/general_screen.dart';

class NetworkStatusService extends GetxService {
  NetworkStatusService() {
   
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _getNetworkStatus(result);
    });
  }

  void _getNetworkStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
      _validateSession(); // After internet connected, redirect to the home page
    } else {
     Get.to( ExceptionClass(
          message: 'No Internet Connection',
          assetsUrl: 'assets/noInternet.webp',
          buttonText: 'Try again')); // is lost, show the NetworkErrorItem widget
    }
    
  }



  void _validateSession() {
   
    // Get.offNamedUntil(AppRoutes.home, (_) => false); // Redirect to the home page
  }
}
