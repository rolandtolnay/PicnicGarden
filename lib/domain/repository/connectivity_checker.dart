import 'package:connectivity/connectivity.dart';
import 'package:either_option/either_option.dart';

import '../service_error.dart';

mixin ConnectivityChecker {
  Future<Option<ServiceError>> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return Option.cond(
      connectivityResult == ConnectivityResult.none,
      ServiceError.noInternet(),
    );
  }
}
