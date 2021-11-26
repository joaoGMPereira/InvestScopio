import 'package:invest_scopio/app/core/storage/storage_core.dart';

abstract class StorageRepository {
  Future setToken(String data);

  Future<String?> getToken();

  Future setUserId(String data);

  Future<String?> getUserId();
}

class StorageRepositoryImpl extends StorageRepository {
  final StorageCore _storageCore;

  StorageRepositoryImpl(this._storageCore);

  static const String _token = "@token";
  static const String _userId = "@user_id";

  @override
  Future setToken(String data) => _storageCore.setString(_token, data);

  @override
  Future<String?> getToken() => _storageCore.getString(_token);

  @override
  Future setUserId(String data) =>
      _storageCore.setString(_userId, data);

  @override
  Future<String?> getUserId() => _storageCore.getString(_userId);
}
