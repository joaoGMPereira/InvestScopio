import 'package:invest_scopio/app/app_foundation/core/data/store_request.dart';
import 'package:invest_scopio/app/app_foundation/core/domain/base_usecase.dart';

class DeleteUserUseCase<T> extends BaseUseCase<T> {
  @override
  Future<void> invoke(
      {required Function(T) success, required Function error}) async {
    var response = await super.local(StoreRequest("user", Operation.delete));
    if (response.isSuccessfully) {
      success(response.data as T);
    } else {
      error(response.exception);
    }
  }
}
