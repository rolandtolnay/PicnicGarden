import 'dart:developer' as dev;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';

import '../service_error.dart';
import 'connectivity_checker.dart';

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
          await FirebaseCrashlytics.instance
              .recordError(e, st, reason: '$ApiClient error');
          return ServiceError.backend('$e', error: e);
        }
      },
      (error) => error,
    );
  }
}
