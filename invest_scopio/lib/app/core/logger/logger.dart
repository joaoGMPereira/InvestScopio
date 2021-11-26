import 'package:flutter/material.dart';
import 'package:invest_scopio/app/core/logger/logger_button.dart';
import 'package:invest_scopio/app/core/logger/logger_list.dart';
import 'package:invest_scopio/app/core/logger/logger_store.dart';

import 'logger_bottom_sheet.dart';


class Logger {
  final LoggerStore _store;

  Logger(this._store);

  debug({String? title, String? message}) {
    _store.debug(title: title, message: message);
  }

  error({String? title, String? message}) {
    _store.error(title: title, message: message);
  }

  info({String? title, String? message}) {
    _store.info(title: title, message: message);
  }

  toggle() {
    _store.toggle();
  }

  static Widget logButton(LoggerStore store) {
    return LoggerButton(store);
  }

  static showLogList(BuildContext context, LoggerStore store) {
    LoggerBottomSheet.showDraggable(context, VLoggerList(store));
  }
}
