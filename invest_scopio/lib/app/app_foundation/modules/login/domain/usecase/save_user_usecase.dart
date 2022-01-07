import 'package:invest_scopio/app/app_foundation/core/data/store_request.dart';
import 'package:invest_scopio/app/app_foundation/core/domain/base_usecase.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/domain/model/auth_model.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/domain/model/profile_model.dart';
import 'package:invest_scopio/app/app_foundation/modules/login/domain/model/user_model.dart';

class SaveUserUseCase<T> extends BaseUseCase<T> {
  late String _email;
  late String _password;

  SaveUserUseCase<T> params({required String email, required String password}) {
    _email = email;
    _password = password;
    return this;
  }

  @override
  Future<void> invoke(
      {required Function(T) success, required Function error}) async {
    var response = await super.local(StoreRequest("user", Operation.create,
        data: UserModel(
            profile: ProfileModel(email: _email),
            auth: AuthModel(password: _password))));
    if (response.isSuccessfully) {
      success(UserModel.fromJson(response.data ?? {}) as T);
    } else {
      error(response.exception);
    }
  }
}
