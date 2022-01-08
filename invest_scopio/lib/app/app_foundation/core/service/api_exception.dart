import 'dart:async';

import 'dart:io';

enum ErrorType { Default, Business, Auth }

class ApiException implements Exception {
  final String? message;
  ErrorType errorType;

  ApiException({this.message, this.errorType = ErrorType.Default});

  static ApiException genericException() =>
      ApiException(message: _genericException);

  static ApiException exception(dynamic cause, StackTrace stacktrace) {
    if (_is401Error(cause)) {
      return ApiException(message: _authException, errorType: ErrorType.Auth);
    }
    try {
      var causeNotification = cause.runtimeType;
      switch (causeNotification) {
        case String:
        case NoSuchMethodError:
        case TypeError:
          return ApiException(message: _genericException);
        case TimeoutException:
          return ApiException(message: _timeOutException);
        case SocketException:
          return ApiException(message: _connectionException);
        default:
          return ApiException(message: _genericException);
      }
    } catch (e) {
      return ApiException(message: _genericException);
    }
  }

  bool isBusiness() {
    return errorType == ErrorType.Business;
  }

  static bool _is401Error(dynamic cause) {
    try {
      return (cause.message.contains("401")) ? true : false;
    } catch (e) {
      return false;
    }
  }

  static String get _connectionException => "Sem conexão";

  static String get _authException => "Sessão expirada, faça login novamente";

  static String get _timeOutException =>
      "Esta demorando muito para carregar, tente novamente.";

  static String get _genericException =>
      "Houve um problema com os dados tente novamente.";
}
