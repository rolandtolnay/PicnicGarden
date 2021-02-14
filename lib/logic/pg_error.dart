import 'package:flutter/material.dart';

class PGError implements Exception {
  final PGErrorType type;

  /// Further information about the error if available
  final String message;

  /// Underlying error
  Exception error;

  PGError.noInternet()
      : type = PGErrorType.noInternet,
        message = 'No internet connection.';
  PGError.backend(this.message, {this.error}) : type = PGErrorType.backendError;
  PGError.network(this.message) : type = PGErrorType.networkError;
  PGError.unexpected(this.message) : type = PGErrorType.unexpected;
  PGError.unknown(this.message, {this.error}) : type = PGErrorType.unknown;
  PGError.auth(this.message) : type = PGErrorType.authentication;
  PGError.validation(this.message) : type = PGErrorType.validation;

  @override
  String toString() => message;
}

enum PGErrorType {
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

extension ErrorHandling on PGError {
  Future showInDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Oops!'),
        content: Text(message),
        actions: [
          FlatButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
