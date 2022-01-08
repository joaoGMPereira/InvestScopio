import 'package:invest_scopio/app/app_foundation/core/data/store_request.dart';
import 'package:invest_scopio/app/app_foundation/core/domain/base_usecase.dart';

import '../model/user_model.dart';

class GetUserUseCase<T> extends BaseUseCase<T?> {
  @override
  Future<void> invoke(
      {required Function(T?) success, required Function error}) async {
    var response = await super.local(StoreRequest("user", Operation.select));
    if (response.isSuccessfully) {
      var data = response.data == null ? null : UserModel.fromJson(response.data) as T ;
      success(data);
    } else {
      error(response.exception);
    }
  }
}