// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logger_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoggerStore on _LoggerStore, Store {
  Computed<ObservableList<Log>>? _$filteredLogsComputed;

  @override
  ObservableList<Log> get filteredLogs => (_$filteredLogsComputed ??=
          Computed<ObservableList<Log>>(() => super.filteredLogs,
              name: '_LoggerStore.filteredLogs'))
      .value;

  final _$showTopIndicatorAtom = Atom(name: '_LoggerStore.showTopIndicator');

  @override
  bool get showTopIndicator {
    _$showTopIndicatorAtom.reportRead();
    return super.showTopIndicator;
  }

  @override
  set showTopIndicator(bool value) {
    _$showTopIndicatorAtom.reportWrite(value, super.showTopIndicator, () {
      super.showTopIndicator = value;
    });
  }

  final _$showBottomIndicatorAtom =
      Atom(name: '_LoggerStore.showBottomIndicator');

  @override
  bool get showBottomIndicator {
    _$showBottomIndicatorAtom.reportRead();
    return super.showBottomIndicator;
  }

  @override
  set showBottomIndicator(bool value) {
    _$showBottomIndicatorAtom.reportWrite(value, super.showBottomIndicator, () {
      super.showBottomIndicator = value;
    });
  }

  final _$isEnabledAtom = Atom(name: '_LoggerStore.isEnabled');

  @override
  bool get isEnabled {
    _$isEnabledAtom.reportRead();
    return super.isEnabled;
  }

  @override
  set isEnabled(bool value) {
    _$isEnabledAtom.reportWrite(value, super.isEnabled, () {
      super.isEnabled = value;
    });
  }

  final _$isCopyingAtom = Atom(name: '_LoggerStore.isCopying');

  @override
  bool get isCopying {
    _$isCopyingAtom.reportRead();
    return super.isCopying;
  }

  @override
  set isCopying(bool value) {
    _$isCopyingAtom.reportWrite(value, super.isCopying, () {
      super.isCopying = value;
    });
  }

  final _$filterAtom = Atom(name: '_LoggerStore.filter');

  @override
  String get filter {
    _$filterAtom.reportRead();
    return super.filter;
  }

  @override
  set filter(String value) {
    _$filterAtom.reportWrite(value, super.filter, () {
      super.filter = value;
    });
  }

  final _$isDebugAtom = Atom(name: '_LoggerStore.isDebug');

  @override
  bool get isDebug {
    _$isDebugAtom.reportRead();
    return super.isDebug;
  }

  @override
  set isDebug(bool value) {
    _$isDebugAtom.reportWrite(value, super.isDebug, () {
      super.isDebug = value;
    });
  }

  final _$isErrorAtom = Atom(name: '_LoggerStore.isError');

  @override
  bool get isError {
    _$isErrorAtom.reportRead();
    return super.isError;
  }

  @override
  set isError(bool value) {
    _$isErrorAtom.reportWrite(value, super.isError, () {
      super.isError = value;
    });
  }

  final _$isInfoAtom = Atom(name: '_LoggerStore.isInfo');

  @override
  bool get isInfo {
    _$isInfoAtom.reportRead();
    return super.isInfo;
  }

  @override
  set isInfo(bool value) {
    _$isInfoAtom.reportWrite(value, super.isInfo, () {
      super.isInfo = value;
    });
  }

  final _$logsAtom = Atom(name: '_LoggerStore.logs');

  @override
  ObservableList<Log> get logs {
    _$logsAtom.reportRead();
    return super.logs;
  }

  @override
  set logs(ObservableList<Log> value) {
    _$logsAtom.reportWrite(value, super.logs, () {
      super.logs = value;
    });
  }

  final _$_LoggerStoreActionController = ActionController(name: '_LoggerStore');

  @override
  dynamic toggle() {
    final _$actionInfo =
        _$_LoggerStoreActionController.startAction(name: '_LoggerStore.toggle');
    try {
      return super.toggle();
    } finally {
      _$_LoggerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic atTop(bool isAtTop) {
    final _$actionInfo =
        _$_LoggerStoreActionController.startAction(name: '_LoggerStore.atTop');
    try {
      return super.atTop(isAtTop);
    } finally {
      _$_LoggerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic copyRequests() {
    final _$actionInfo = _$_LoggerStoreActionController.startAction(
        name: '_LoggerStore.copyRequests');
    try {
      return super.copyRequests();
    } finally {
      _$_LoggerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic copyResponses() {
    final _$actionInfo = _$_LoggerStoreActionController.startAction(
        name: '_LoggerStore.copyResponses');
    try {
      return super.copyResponses();
    } finally {
      _$_LoggerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic copyErrors() {
    final _$actionInfo = _$_LoggerStoreActionController.startAction(
        name: '_LoggerStore.copyErrors');
    try {
      return super.copyErrors();
    } finally {
      _$_LoggerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
showTopIndicator: ${showTopIndicator},
showBottomIndicator: ${showBottomIndicator},
isEnabled: ${isEnabled},
isCopying: ${isCopying},
filter: ${filter},
isDebug: ${isDebug},
isError: ${isError},
isInfo: ${isInfo},
logs: ${logs},
filteredLogs: ${filteredLogs}
    ''';
  }
}
