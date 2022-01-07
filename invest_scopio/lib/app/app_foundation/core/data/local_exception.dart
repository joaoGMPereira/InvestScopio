import 'dart:async';

import 'dart:io';

import 'package:invest_scopio/app/app_foundation/core/data/store_request.dart';

class LocalException implements Exception {
  final String? message;
  Operation operation;

  LocalException({this.message, this.operation = Operation.select});

  static LocalException exception(
      dynamic cause, StackTrace stacktrace, Operation operation) {
    switch (operation) {
      case Operation.select:
        return LocalException(message: _selectException, operation: operation);
      case Operation.create:
        return LocalException(message: _createException, operation: operation);
      case Operation.delete:
        return LocalException(message: _deleteException, operation: operation);
    }
  }

  static String get _selectException => "Não foi possível encontrar";

  static String get _createException => "Não foi possível fazer a criação";

  static String get _deleteException => "Não foi possível fazer a remoção";
}
