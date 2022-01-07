import 'package:invest_scopio/app/app_foundation/core/data/local_exception.dart';

class StoreResponse<T> {
  T? data;
  bool isSuccessfully;
  LocalException? exception;

  StoreResponse({this.data, this.isSuccessfully = false, this.exception});

  StoreResponse.onResponse(this.data, this.isSuccessfully);
}
