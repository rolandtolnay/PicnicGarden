import 'dart:developer' as dev;

import 'package:injectable/injectable.dart';

import '../service_error.dart';
import 'connectivity_checker.dart';
import 'crash_reporting.dart';

@Injectable()
class ApiClient with ConnectivityChecker {
  Future<ServiceError?> execute(Future<void> Function() apiCall) async {
    return (await checkConnectivity()).fold(
      () async {
        try {
          await apiCall();
          return null;
        } catch (e, st) {
          dev.log('[ERROR] ${e.toString()}', error: e, stackTrace: st);
          await CrashReporting.instance
              .recordError(e, st, reason: '$ApiClient error');
          return ServiceError.backend('$e', error: e);
        }
      },
      (error) => error,
    );
  }
}
