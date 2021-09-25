import 'package:flutter/material.dart';

enum VLogType { Debug, Error, Info }

extension VLopTypeExtension on VLogType {
  String get separator {
    switch (this) {
      case VLogType.Debug:
        return "-----------🟠🟠🟠🟠🟠🟠-----------";
      case VLogType.Error:
        return "-----------🔴🔴🔴🔴🔴🔴-----------";
      case VLogType.Info:
        return "-----------🔵🔵🔵🔵🔵🔵-----------";
    }
    return "";
  }

  Icon get icon {
    switch (this) {
      case VLogType.Debug:
        return Icon(Icons.adb, color: Colors.amber);
      case VLogType.Error:
        return Icon(Icons.error, color: Colors.redAccent);
      case VLogType.Info:
        return Icon(Icons.info, color: Colors.blueAccent);
    }
    return Icon(Icons.info_outline);
  }
}

class VLog {
  final String? title;
  final String? message;
  final VLogType? type;

  VLog({this.title, this.message, this.type});
}
