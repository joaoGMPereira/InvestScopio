import 'package:flutter/material.dart';
import 'package:invest_scopio/app/core/logger/logger_button.dart';
import 'package:invest_scopio/app/core/logger/logger_list.dart';
import 'package:invest_scopio/app/core/logger/logger_controller.dart';

import 'logger_bottom_sheet.dart';


class VLogger {
  final LoggerController _controller;

  VLogger(this._controller);

  debug({String? title, String? message}) {
    _controller.debug(title: title, message: message);
  }

  error({String? title, String? message}) {
    _controller.error(title: title, message: message);
  }

  info({String? title, String? message}) {
    _controller.info(title: title, message: message);
  }

  toggle() {
    _controller.toggle();
  }

  static Widget logButton() {
    return LoggerButton();
  }

  static showLogList(BuildContext context) {
    LoggerBottomSheet.showDraggable(context, LoggerList());
  }
}
