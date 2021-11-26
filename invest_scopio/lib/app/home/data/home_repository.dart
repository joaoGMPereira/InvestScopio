import 'home_service.dart';

abstract class HomeRepository {

}

class HomeRepositoryImpl implements HomeRepository {
  final HomeService _service;

  HomeRepositoryImpl(this._service);
}