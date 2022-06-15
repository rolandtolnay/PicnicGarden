import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'dart:developer' as dev;

class CrashReporting {
  CrashReporting._();
  static CrashReporting? _instance;
  FirebaseCrashlytics get _firebase => FirebaseCrashlytics.instance;

  static CrashReporting get instance {
    _instance ??= CrashReporting._();
    return _instance!;
  }

  Future<void> recordFlutterFatalError(FlutterErrorDetails details) {
    if (kIsWeb || kDebugMode) {
      FlutterError.presentError(details);
      return Future.value();
    } else {
      return _firebase.recordFlutterFatalError(details);
    }
  }

  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<DiagnosticsNode> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) {
    if (kIsWeb || kDebugMode) {
      if (fatal) {
        FlutterError.presentError(
          FlutterErrorDetails(exception: exception, stack: stack),
        );
      } else {
        dev.log('[ERROR] $reason', error: exception, stackTrace: stack);
      }
      return Future.value();
    } else {
      return _firebase.recordError(
        exception,
        stack,
        reason: reason,
        information: information,
        printDetails: printDetails,
        fatal: fatal,
      );
    }
  }
}
