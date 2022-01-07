import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:invest_scopio/app/app_foundation/core/data/local_exception.dart';
import 'package:invest_scopio/app/app_foundation/core/data/store_request.dart';
import 'package:invest_scopio/app/app_foundation/core/data/store_response.dart';
import 'package:localstorage/localstorage.dart';

abstract class RemoteRepository {
  Future<dynamic> call(StoreRequest query);
}

class LocalRepository {
  final LocalStorage storage = LocalStorage('localstorage_app');

  Future<StoreResponse> save({@required key, @required data}) async {
    try {
      await storage.setItem(key, data);
      return StoreResponse(isSuccessfully: true);
    } catch (exception, stacktrace) {
      return StoreResponse(
          isSuccessfully: false,
          exception: LocalException.exception(
              exception, stacktrace, Operation.create));
    }
  }

  Future<StoreResponse> get({@required key}) async {
    try {
      return StoreResponse(
          data: await storage.getItem(key), isSuccessfully: true);
    } catch (exception, stacktrace) {
      return StoreResponse(
          isSuccessfully: false,
          exception: LocalException.exception(
              exception, stacktrace, Operation.select));
    }
  }

  Future<StoreResponse> delete({@required key}) async {
    try {
      await storage.deleteItem(key);
      return StoreResponse(isSuccessfully: true);
    } catch (exception, stacktrace) {
      return StoreResponse(
          isSuccessfully: false,
          exception: LocalException.exception(
              exception, stacktrace, Operation.delete));
    }
  }

  call(StoreRequest query) async {
    await storage.ready;
    switch (query.operation) {
      case Operation.select:
        return get(key: query.key);
      case Operation.create:
        return save(key: query.key, data: query.data);
      case Operation.delete:
        return delete(key: query.key);
    }
  }
}
