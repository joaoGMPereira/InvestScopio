import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:invest_scopio/app/core/logger/log.dart';
import 'dart:developer';
import 'package:share_plus/share_plus.dart';

class LoggerController extends GetxController {

  final xPosition = 20.0.obs;
  final yPosition = 50.0.obs;

  final showTopIndicator = false.obs;

  final showBottomIndicator = false.obs;

  final isEnabled = true.obs;

  final isCopying = false.obs;

  final filter = "".obs;

  final isDebug = false.obs;

  final isError = false.obs;

  final isInfo = false.obs;

  List<VLog> get filteredLogs => _logFiltered();

  RxList<VLog> logs = RxList<VLog>([]);

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  onInit() {
    reset();
    textEditingController.addListener(() {
      filter.value = textEditingController.text;
    });

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        atTop(true);
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        atTop(false);
      }
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
          atTop(true);
        } else {
          atTop(false);
        }
      }
    });
    super.onInit();
  }

  reset() {
    isDebug.value = false;
    isError.value = false;
    isInfo.value = false;
    filter.value = "";
  }

  toggle() {
    isEnabled.value = !isEnabled.value;
  }

  atTop(bool isAtTop) {
    showBottomIndicator.value = !isAtTop;
    showTopIndicator.value = isAtTop;
  }

  copyRequests() {
    _copyLogs(VLogType.Debug);
  }

  copyResponses() {
    _copyLogs(VLogType.Info);
  }

  copyErrors() {
    _copyLogs(VLogType.Error);
  }

  _copyLogs(VLogType logType) {
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
    _log(title: title, message: message, type: VLogType.Debug);
  }

  error({String? title, String? message}) {
    _log(title: title, message: message, type: VLogType.Error);
  }

  info({String? title, String? message}) {
    _log(title: title, message: message, type: VLogType.Info);
  }

  _log({String? title, String? message, VLogType type = VLogType.Debug}) {
    String updatedTitle = "$title\n";
    log(type.separator +
        "\n" +
        updatedTitle +
        (message ?? "") +
        "\n" +
        type.separator);
    logs.add(VLog(title: title, message: message, type: type));
  }

  List<VLog> _logFiltered() {
    List<VLog> filteredTypeLogs = _logTypeFiltered();
    List<VLog> filteredLogs = filteredTypeLogs
        .where((log) {
          var title = log.title ?? "";
          var message = log.message ?? "";
          return title.toLowerCase().contains(filter) ||
              message.toLowerCase().contains(filter);
        })
        .toList()
        .reversed
        .toList();
    return filteredLogs;
  }

  List<VLog> _logTypeFiltered() {
    List<VLog> filteredTypeLogs = [];
    if (isDebug.value == false &&
        isError.value == false &&
        isInfo.value == false) {
      filteredTypeLogs = logs.toList();
      return filteredTypeLogs;
    }
    if (isDebug.value)
      filteredTypeLogs.addAll(logs.where((log) => log.type == VLogType.Debug));

    if (isError.value)
      filteredTypeLogs.addAll(logs.where((log) => log.type == VLogType.Error));

    if (isInfo.value)
      filteredTypeLogs.addAll(logs.where((log) => log.type == VLogType.Info));

    return filteredTypeLogs;
  }
}