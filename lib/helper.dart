import 'package:connectivity/connectivity.dart';

Future<bool> checkInternetConnection() async {
  ConnectivityResult result = await (new Connectivity().checkConnectivity());

  return result == ConnectivityResult.mobile ||
      result == ConnectivityResult.wifi;
}
