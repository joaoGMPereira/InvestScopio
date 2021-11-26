import 'package:flutter/material.dart';

enum LogType { Debug, Error, Info }

extension LopTypeExtension on LogType {
  String get separator {
    switch (this) {
      case LogType.Debug:
        return "-----------🟠🟠🟠🟠🟠🟠-----------";
      case LogType.Error:
        return "-----------🔴🔴🔴🔴🔴🔴-----------";
      case LogType.Info:
        return "-----------🔵🔵🔵🔵🔵🔵-----------";
    }
    return "";
  }

  Icon get icon {
    switch (this) {
      case LogType.Debug:
        return Icon(Icons.adb, color: Colors.amber);
      case LogType.Error:
        return Icon(Icons.error, color: Colors.redAccent);
      case LogType.Info:
        return Icon(Icons.info, color: Colors.blueAccent);
    }
    return Icon(Icons.info_outline);
  }
}

class Log {
  final String? title;
  final String? message;
  final LogType? type;

  Log({this.title, this.message, this.type});
}
