import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

abstract class NetworkConnectivityAbs {
  Future<bool> get isConnected;
}

class NetworkConnectivity implements NetworkConnectivityAbs {
  final InternetConnectionChecker? _internetChecker;

  NetworkConnectivity() : _internetChecker = kIsWeb ? null : InternetConnectionChecker.createInstance(
    addresses: [
      AddressCheckOption(uri: Uri.parse('https://www.google.com')),
    ],
  );

  @override
  Future<bool> get isConnected async {
    if (kIsWeb) {
      // For web platform, we'll assume connection is available
      // You could implement a more sophisticated check if needed
      return true;
    }
    return await _internetChecker!.hasConnection;
  }
}
