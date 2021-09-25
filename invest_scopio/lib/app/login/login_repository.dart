import 'package:invest_scopio/app/core/networks/network.dart';
import 'package:kotlin_flavor/scope_functions.dart';

abstract class LoginRepositoryProtocol {

}

class LoginRepository extends LoginRepositoryProtocol {
  final Network _network;
  LoginRepository(this._network);
}