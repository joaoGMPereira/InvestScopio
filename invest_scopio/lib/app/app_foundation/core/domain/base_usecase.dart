import 'package:invest_scopio/app/app_foundation/core/data/http_request.dart';
import 'package:invest_scopio/app/app_foundation/core/data/http_response.dart';
import 'package:invest_scopio/app/app_foundation/core/data/local_repository.dart';
import 'package:invest_scopio/app/app_foundation/core/data/remote_repository.dart';
import 'package:invest_scopio/app/app_foundation/core/data/store_request.dart';
import 'package:invest_scopio/app/app_foundation/core/data/store_response.dart';

abstract class BaseUseCase<T> {
  final _remote = RemoteRepositoryImpl();
  final _local = LocalRepository();

  void invoke({required Function(T?) success, required Function error});

  Future<HTTPResponse> remote(Request request) async {
    return await _remote.call(request);
  }

  Future<StoreResponse> local(StoreRequest request) async {
    return await _local.call(request);
  }
}
