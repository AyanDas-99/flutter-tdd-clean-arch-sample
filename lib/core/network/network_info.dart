import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}

class NetworkInfoWebImpl implements NetworkInfo {
  final InternetConnection connection;

  NetworkInfoWebImpl(this.connection);
  @override
  Future<bool> get isConnected async => connection.hasInternetAccess;
}
