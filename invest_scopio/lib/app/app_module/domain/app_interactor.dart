import 'package:invest_scopio/app/core/storage/storage_repository.dart';
import 'package:invest_scopio/app/app_module/data/app_repository.dart';

abstract class AppInteractor {

}

class AppInteractorImpl extends AppInteractor {
  final AppRepository _repository;
  final StorageRepository _storageRepository;

  AppInteractorImpl(this._repository, this._storageRepository);
}
