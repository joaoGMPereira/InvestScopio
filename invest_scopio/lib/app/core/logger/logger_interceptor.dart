import 'dart:convert';
import 'package:invest_scopio/app/core/logger/logger.dart';

class LoggerRequest {
  final String? method;
  final Uri? uri;
  final Map<String, dynamic>? headers;
  final int? statusCode;
  final dynamic data;

  LoggerRequest({this.method,
    this.uri,
    this.headers,
    this.statusCode,
    this.data});
}


class LoggerRequestOptions {
  final String? method;
  final Uri? uri;
  final Map<String, dynamic>? headers;
  final dynamic data;

  LoggerRequestOptions({this.method, this.uri, this.headers, this.data});
}


class LoggerInterceptor {
  final Logger logger;

  LoggerInterceptor(this.logger);

  onError(LoggerRequest request) async {
    logger.error(title: "ERROR:", message: """URL: ${request.uri}\n
    Method: ${request.method} 
    Headers: ${json.encode(request.headers)}
    StatusCode: ${request.statusCode}
    Data: ${json.encode(request.data)}
    <-- END HTTP""");
  }

  onRequest(LoggerRequestOptions options) async {
    logger.debug(
        title: "REQUEST:",
        message: """${_cURLRepresentation(options)}""");
  }

  onResponse(LoggerRequest request) async {
    logger.info(title: "RESPONSE:", message: """URL: ${request.uri}
    Method: ${request.method}
    Headers: ${json.encode(request.headers)}
    Data: ${json.encode(request.data)}""");
  }

  String _cURLRepresentation(LoggerRequestOptions? options) {
    List<String> components = ["\$ curl -i"];
    if (options?.method != null) {
      components.add("-X ${options?.method}");
    }

    if (options?.headers != null) {
      options?.headers?.forEach((k, v) {
        if (k != "Cookie") {
          components.add("-H \"$k: $v\"");
        }
      });
    }
    if (options?.data != null) {
      var data = json.encode(options?.data);
      if (data != "null") {
        data = data.replaceAll('\"', '\\\"');
        components.add("-d \"$data\"");
      }

      components.add("\"${options?.uri.toString()}\"");
    }

    return components.join('\\\n\t');
  }
}