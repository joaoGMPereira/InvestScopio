import 'app_service.dart';

abstract class AppRepository {

}

class AppRepositoryImpl implements AppRepository {
  final AppService _service;

  AppRepositoryImpl(this._service);
}