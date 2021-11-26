import 'package:invest_scopio/app/core/storage/storage_repository.dart';
import 'package:invest_scopio/app/home/data/home_repository.dart';

abstract class HomeInteractor {

}

class HomeInteractorImpl extends HomeInteractor {
  final HomeRepository _repository;
  final StorageRepository _storageRepository;

  HomeInteractorImpl(this._repository, this._storageRepository);
}
