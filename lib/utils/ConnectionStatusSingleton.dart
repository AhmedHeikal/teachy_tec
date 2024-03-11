// import 'dart:io'; //InternetAddress utility
// import 'dart:async'; //For StreamController/Stream

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:network_info_plus/network_info_plus.dart';

// class ConnectionStatusSingleton extends ChangeNotifier {
//   //This creates the single instance by calling the `_internal` constructor specified below
//   static final ConnectionStatusSingleton _singleton =
//       new ConnectionStatusSingleton._internal();
//   ConnectionStatusSingleton._internal();

//   //This is what's used to retrieve the instance through the app
//   static ConnectionStatusSingleton getInstance() => _singleton;

//   //This tracks the current connection status
//   bool hasConnection = false;
//   ValueNotifier<bool> isAppOnline = ValueNotifier(true);
//   // ValueNotifier<bool> currentLocationPassedGeoSecuritySecurity =
//   //     ValueNotifier(true);
//   // ValueNotifier<bool> currentVersionIsUpToDate = ValueNotifier(true);
//   // bool currentLocationPassedGeoSecuritySecurity = true;
//   ConnectivityResult connectionStatus = ConnectivityResult.none;
//   final NetworkInfo _networkInfo = NetworkInfo();
//   String? wifiName;
//   String? wifiBSSID;
//   double? longitude;
//   double? latitude;

//   //This is how we'll allow subscribing to connection changes
//   StreamController connectionChangeController = StreamController.broadcast();

//   //flutter_connectivity
//   final Connectivity _connectivity = Connectivity();

//   //Hook into flutter_connectivity's Stream to listen for changes
//   //And check the connection status out of the gate
//   void initialize() {
//     _connectivity.onConnectivityChanged.listen(_connectionChange);
//     checkConnection();
//   }

//   Stream get connectionChange => connectionChangeController.stream;

//   //A clean up method to close our StreamController
//   //   Because this is meant to exist through the entire application life cycle this isn't
//   //   really an issue
//   void dispose() {
//     super.dispose();
//     connectionChangeController.close();
//   }

//   registerNetworkConnectionListener(Function() func) {
//     isAppOnline.addListener(func);
//   }

//   unRegisterNetworkConnectionListener(Function() func) {
//     isAppOnline.removeListener(func);
//   }

//   //flutter_connectivity's listener
//   void _connectionChange(ConnectivityResult result) async {
//     if (connectionStatus != result) {
//       connectionStatus = result;
//       // isAppOnline.value = result;

//       // if (!currentNetworkPassedWifiSecurity.value)
//       await _initNetworkInfo();
//       // if (!currentLocationPassedGeoSecurity.value)
//       notifyListeners();
//     }
//     checkConnection();
//   }

//   // getCurrentPosition() async {
//   //   LocationPermission permission = await Geolocator.requestPermission();
//   //   if (permission == LocationPermission.denied) {
//   //     return null;
//   //   }
//   //   var position = await Geolocator.getCurrentPosition(
//   //       desiredAccuracy: LocationAccuracy.medium);
//   //   longitude = position.longitude;
//   //   latitude = position.latitude;
//   //   // notifyListeners();
//   // }

//   //The test to actually see if there is a connection
//   Future<bool> checkConnection() async {
//     bool previousConnection = hasConnection;

//     try {
//       final result = await InternetAddress.lookup('google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         hasConnection = true;
//         isAppOnline.value = true;
//       } else {
//         hasConnection = false;
//         isAppOnline.value = false;
//       }
//     } on SocketException catch (_) {
//       hasConnection = false;
//       isAppOnline.value = false;
//     }

//     //The connection status changed send out an update to all listeners
//     if (previousConnection != hasConnection) {
//       connectionChangeController.add(hasConnection);
//       notifyListeners();
//     }

//     return hasConnection;
//   }

//   Future<void> _initNetworkInfo() async {
//     try {
//       if (Platform.isIOS) {
//         var status = await _networkInfo.getLocationServiceAuthorization();
//         // var status = await _networkInfo.getLocationServiceAuthorization();
//         if (status == LocationAuthorizationStatus.notDetermined) {
//           status = await _networkInfo.requestLocationServiceAuthorization();
//         }
//         if (status == LocationAuthorizationStatus.authorizedAlways ||
//             status == LocationAuthorizationStatus.authorizedWhenInUse) {
//           wifiName = await _networkInfo.getWifiName();
//         } else {
//           wifiName = await _networkInfo.getWifiName();
//         }
//       } else {
//         wifiName = await _networkInfo.getWifiName();
//       }
//     } catch (e) {
//       // debugPrint('Failed to get Wifi Name $e');
//       wifiName = 'Failed to get Wifi Name';
//     }

//     wifiName = wifiName?.replaceAll("\"", "");

//     // debugPrint('Wifi name - $wifiName');

//     try {
//       if (Platform.isIOS) {
//         var status = await _networkInfo.getLocationServiceAuthorization();
//         if (status == LocationAuthorizationStatus.notDetermined) {
//           status = await _networkInfo.requestLocationServiceAuthorization();
//         }
//         if (status == LocationAuthorizationStatus.authorizedAlways ||
//             status == LocationAuthorizationStatus.authorizedWhenInUse) {
//           wifiBSSID = await _networkInfo.getWifiBSSID();
//         } else {
//           wifiBSSID = await _networkInfo.getWifiBSSID();
//         }
//       } else {
//         wifiBSSID = await _networkInfo.getWifiBSSID();
//       }
//     } catch (e) {
//       // debugPrint('Failed to get Wifi BSSID $e');
//       wifiBSSID = 'Failed to get Wifi BSSID';
//     }
//   }
// }
