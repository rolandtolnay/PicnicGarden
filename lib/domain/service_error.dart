import 'package:flutter/material.dart';

import '../ui/common/api_responder.dart';

class ServiceError implements Exception {
  final ServiceErrorType type;

  /// Further information about the error if available
  final String message;

  /// Underlying error
  Object? error;

  ServiceError.noInternet()
      : type = ServiceErrorType.noInternet,
        message = 'No internet connection.';
  ServiceError.backend(this.message, {this.error})
      : type = ServiceErrorType.backendError;
  ServiceError.network(this.message) : type = ServiceErrorType.networkError;
  ServiceError.unexpected(this.message) : type = ServiceErrorType.unexpected;
  ServiceError.unknown(this.message, {this.error})
      : type = ServiceErrorType.unknown;
  ServiceError.auth(this.message) : type = ServiceErrorType.authentication;
  ServiceError.validation(this.message) : type = ServiceErrorType.validation;

  @override
  String toString() => message;
}

enum ServiceErrorType {
  /// timeout, cannot connect to server, could not establish trusted connection
  networkError,

  /// server server response with incorrect status, such as 404, 503, etc.
  backendError,

  /// no internet connection
  noInternet,

  /// malformed response format, developer errors which shouldn't happen
  unexpected,

  /// authentication error
  authentication,

  /// invalid user input
  validation,

  /// unknown error
  unknown
}

extension ErrorHandling on ServiceError {
  Future showInDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Oops!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

extension BuildContextExt on BuildContext {
  Future showError(
    ApiResponder apiResponder, {
    VoidCallback? onPressed,
  }) {
    return showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: Text('Oops!'),
        content: Text(
          apiResponder.errorDescription ?? 'An unknown error occured',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
