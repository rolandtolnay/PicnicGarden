import 'package:connectivity/connectivity.dart';

import 'pg_error.dart';

class ApiResponse {
  final ApiStatus status;
  final PGError error;

  ApiResponse.initial()
      : status = ApiStatus.initial,
        error = null;
  ApiResponse.loading()
      : status = ApiStatus.loading,
        error = null;
  ApiResponse.completed()
      : status = ApiStatus.completed,
        error = null;
  ApiResponse.error(PGError error)
      : status = ApiStatus.error,
        error = error;
}

enum ApiStatus {
  /// Default state when provider is created
  initial,

  /// Network request in progress
  loading,

  /// Provider contains data from backend (can be empty)
  completed,

  /// An error occured while performing request
  error
}

Future<bool> hasInternet() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}
