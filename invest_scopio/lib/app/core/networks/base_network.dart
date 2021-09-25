import 'package:dio/dio.dart';
import 'package:invest_scopio/app/core/networks/network_base_request_data.dart';
import 'package:invest_scopio/app/core/networks/network_base_request_query.dart';

abstract class BaseNetwork {
  final Dio _dio;

  static const String authenticatedKey = "authenticated";

  BaseNetwork(this._dio);

  Future<Response> post(String url,
      {NetworkBaseRequestQuery? queryParameters, NetworkBaseRequestData? body}) {
    return _dio.post(
      url,
      queryParameters: queryParameters?.toQueryParameters(),
      data: body?.toJson(),
    );
  }

  Future<Response> patch(String url,
      {NetworkBaseRequestQuery? queryParameters, NetworkBaseRequestData? body}) {
    return _dio.patch(
      url,
      data: body != null ? body.toJson() : null,
      queryParameters: queryParameters?.toQueryParameters(),
    );
  }

  Future<Response> get(String url, {NetworkBaseRequestQuery? queryParameters}) {
    return _dio.get(url, queryParameters: queryParameters?.toQueryParameters());
  }

  Future<Response> put(String url,
      {NetworkBaseRequestQuery? queryParameters, NetworkBaseRequestData? body}) {
    return _dio.put(
      url,
      queryParameters: queryParameters?.toQueryParameters(),
      data: body != null ? body.toJson() : null,
    );
  }

  Future<Response> delete(String url,
      {NetworkBaseRequestQuery? queryParameters, NetworkBaseRequestData? body}) {
    return _dio.delete(
      url,
      queryParameters: queryParameters?.toQueryParameters(),
      data: body != null ? body.toJson() : null,
    );
  }
}
