import 'package:invest_scopio/app/app_foundation/core/service/api_exception.dart';

class HTTPResponse<T> {
  T? data;
  bool safe;
  bool isSuccessfully;
  ApiException? exception;
  Response? response;

  HTTPResponse({this.safe = false, this.isSuccessfully = false});

  HTTPResponse.onResponse(
      this.data, this.response, this.safe, this.isSuccessfully,
      {this.exception});

  HTTPResponse.onError(
      {this.safe = false,
      this.response,
      this.exception,
      this.isSuccessfully = false});
}

class Response {
  final String? status;
  final int? code;

  Response({this.status, this.code});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
        status: json['status'] as String?, code: json['code'] as int?);
  }
}
