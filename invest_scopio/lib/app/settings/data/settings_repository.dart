import 'settings_service.dart';

abstract class SettingsRepository {

}

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsService _service;

  SettingsRepositoryImpl(this._service);
}