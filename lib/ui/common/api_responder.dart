import 'api_response.dart';

mixin ApiResponder {
  ApiResponse get response;

  bool get isLoading => response.status == ApiStatus.loading;

  bool get hasError => response.status == ApiStatus.error;

  bool get isComplete => response.status == ApiStatus.completed;

  String? get errorDescription => response.error?.message;
}
