import '../../domain/service_error.dart';

class ApiResponse {
  final ApiStatus status;
  final ServiceError? error;

  ApiResponse.initial()
      : status = ApiStatus.initial,
        error = null;
  ApiResponse.loading()
      : status = ApiStatus.loading,
        error = null;
  ApiResponse.completed()
      : status = ApiStatus.completed,
        error = null;
  ApiResponse.error(ServiceError error)
      : status = ApiStatus.error,
        // ignore: prefer_initializing_formals
        error = error;

  ApiResponse.fromErrorResult(ServiceError? result)
      : status = result == null ? ApiStatus.completed : ApiStatus.error,
        error = result;
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
