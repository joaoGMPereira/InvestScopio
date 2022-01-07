import 'package:invest_scopio/app/app_foundation/core/data/http_request.dart';
import 'package:invest_scopio/app/app_foundation/core/data/http_response.dart';

abstract class BaseService {
  final String server = "http://192.168.0.15:8084/";

  Future<HTTPResponse> call(Request request);
}
