import 'package:invest_scopio/app/app_foundation/core/service/api_service.dart';
import 'package:invest_scopio/app/app_foundation/core/service/base/base_service.dart';

import '../data/http_request.dart';
import 'http_response.dart';

abstract class RemoteRepository {
  Future<HTTPResponse> call(Request request);
}

class RemoteRepositoryImpl extends RemoteRepository {
  final BaseService _service = ApiService();

  @override
  Future<HTTPResponse> call(Request request) async {
    return await _service.call(request);
  }
}
