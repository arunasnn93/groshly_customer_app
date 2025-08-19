import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// Abstract class for network information
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

/// Implementation of NetworkInfo using connectivity_plus
@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _isConnected(result);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_isConnected);
  }

  bool _isConnected(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }
}