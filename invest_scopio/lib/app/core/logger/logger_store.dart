import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:developer';

import 'log.dart';

part 'logger_store.g.dart';

class LoggerStore = _LoggerStore with _$LoggerStore;

abstract class _LoggerStore with Store {
  @observable
  bool showTopIndicator = false;

  @observable
  bool showBottomIndicator = false;

  @observable
  bool isEnabled = true;

  @observable
  bool isCopying = false;

  @observable
  String filter = "";

  @observable
  bool isDebug = false;

  @observable
  bool isError = false;

  @observable
  bool isInfo = false;

  @computed
  ObservableList<Log> get filteredLogs => _logFiltered();

  @observable
  ObservableList<Log> logs = ObservableList();

  _LoggerStore();

  reset() {
    isDebug = false;
    isError = false;
    isInfo = false;
    filter = "";
  }

  @action
  toggle() {
    isEnabled = !isEnabled;
  }

  @action
  atTop(bool isAtTop) {
    showBottomIndicator = !isAtTop;
    showTopIndicator = isAtTop;
  }

  @action
  copyRequests() {
    _copyLogs(LogType.Debug);
  }

  @action
  copyResponses() {
    _copyLogs(LogType.Info);
  }

  @action
  copyErrors() {
    _copyLogs(LogType.Error);
  }

  _copyLogs(LogType logType) {
    String copiedRequests = "";
    logs
        .where((log) => log.type == logType)
        .toList()
        .asMap()
        .forEach((key, value) {
      copiedRequests +=
      "${value.message ?? ""}${key == logs.length - 1 ? "" : "\n\n"}";
    });
    if (copiedRequests.isNotEmpty) {
      Share.share(copiedRequests);
    } else {
      Fluttertoast.showToast(
        timeInSecForIosWeb: 4,
        msg: "Nenhum dado para ser compartilhado no momento",
        backgroundColor: Colors.black87,
        gravity: ToastGravity.TOP,
      );
    }
  }

  debug({String? title, String? message}) {
    _log(title: title, message: message, type: LogType.Debug);
  }

  error({String? title, String? message}) {
    _log(title: title, message: message, type: LogType.Error);
  }

  info({String? title, String? message}) {
    _log(title: title, message: message, type: LogType.Info);
  }

  _log({String? title, String? message, LogType type = LogType.Debug}) {
    String updatedTitle = "$title\n";
    log(type.separator +
        "\n" +
        updatedTitle +
        (message ?? "") +
        "\n" +
        type.separator);
    logs.add(Log(title: title, message: message, type: type));
  }

  ObservableList<Log> _logFiltered() {
    List<Log> filteredTypeLogs = _logTypeFiltered();
    List<Log> filteredLogs = filteredTypeLogs.where((log) {
      var title = log.title ?? "";
      var message = log.message ?? "";
      return title.toLowerCase().contains(filter) ||
          message.toLowerCase().contains(filter);
    }).toList().reversed.toList();
    return ObservableList<Log>.of(filteredLogs);
  }

  List<Log> _logTypeFiltered() {
    List<Log> filteredTypeLogs = [];
    if (isDebug == false && isError == false && isInfo == false) {
      filteredTypeLogs = logs.toList();
      return filteredTypeLogs;
    }
    if (isDebug)
      filteredTypeLogs.addAll(logs.where((log) => log.type == LogType.Debug));

    if (isError)
      filteredTypeLogs.addAll(logs.where((log) => log.type == LogType.Error));

    if (isInfo)
      filteredTypeLogs.addAll(logs.where((log) => log.type == LogType.Info));

    return filteredTypeLogs;
  }
}