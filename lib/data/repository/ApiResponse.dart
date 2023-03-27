import 'package:meta/meta.dart';

@immutable
abstract class ApiResponse<T> {}

class ApiResponseSuccess<T> extends ApiResponse<T> {
  final T payload;
  ApiResponseSuccess(this.payload);
}

class ApiFailure<T> extends ApiResponse<T> {
  final ApiException error;
  ApiFailure(this.error);
}

enum ApiExceptionType { timeOutException, authException, badResponse, unKnown }

class ApiException implements Exception {
  final ApiExceptionType apiExceptionType;
  ApiException(this.apiExceptionType);
  @override
  String toString() => "ApiException $apiExceptionType";
}