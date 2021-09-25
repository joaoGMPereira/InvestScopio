import 'package:dio/dio.dart';
import 'package:invest_scopio/app/core/logger/logger_interceptor.dart';
import 'package:invest_scopio/app/core/storage/storage_repository.dart';
import 'package:kotlin_flavor/scope_functions.dart';

extension DioErrorExtension on DioError {
  LoggerRequest get loggerRequest => LoggerRequest(
      method: requestOptions.method,
      uri: requestOptions.uri,
      headers: response?.headers.map,
      statusCode: response?.statusCode,
      data: response?.data);
}

extension RequestOptionsExtension on RequestOptions {
  LoggerRequestOptions get loggerOptions => LoggerRequestOptions(
      method: method, uri: uri, headers: headers, data: data);
}

extension ResponseExtension on Response {
  LoggerRequest get loggerRequest => LoggerRequest(
      method: requestOptions.method,
      uri: requestOptions.uri,
      headers: requestOptions.headers,
      data: data);
}

class LoggingInterceptor extends Interceptor {
  final LoggerInterceptor loggerInterceptor;

  LoggingInterceptor(this.loggerInterceptor);

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    loggerInterceptor.onError(err.loggerRequest);
    super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    loggerInterceptor.onRequest(options.loggerOptions);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    loggerInterceptor.onResponse(response.loggerRequest);
    super.onResponse(response, handler);
  }
}

class TokenInterceptor extends Interceptor {
  final StorageRepository storage;

  TokenInterceptor(this.storage);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers[Headers.contentTypeHeader] = Headers.jsonContentType;
    String token = await storage.getToken();
    token.let((token) => options.headers['Authorization'] = 'Bearer $token}');

    super.onRequest(options, handler);
  }
}
