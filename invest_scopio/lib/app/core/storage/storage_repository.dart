import 'package:get_storage/get_storage.dart';

abstract class StorageRepository {
  Future setToken(String data);

  Future<String> getToken();

  Future setUserId(String data);

  Future<String> getUserId();
}

class StorageRepositoryImpl extends StorageRepository {
  final GetStorage _storage;

  StorageRepositoryImpl(this._storage);

  static const String _token = "@token";
  static const String _userId = "@user_id";

  @override
  Future setToken(String data) => _storage.write(_token, data);

  @override
  Future<String> getToken() => _storage.read(_token);

  @override
  Future setUserId(String data) => _storage.write(_userId, data);

  @override
  Future<String> getUserId() => _storage.read(_userId);
}
