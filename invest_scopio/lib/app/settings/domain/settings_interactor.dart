import 'package:invest_scopio/app/settings/data/settings_repository.dart';

abstract class SettingsInteractor {

}

class SettingsInteractorImpl extends SettingsInteractor {
  final SettingsRepository _repository;

  SettingsInteractorImpl(this._repository);
}
