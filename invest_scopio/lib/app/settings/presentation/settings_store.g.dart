// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SettingsStore on _SettingsStore, Store {
  final _$isLoadingAtom = Atom(name: '_SettingsStore.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$showToastAtom = Atom(name: '_SettingsStore.showToast');

  @override
  String? get showToast {
    _$showToastAtom.reportRead();
    return super.showToast;
  }

  @override
  set showToast(String? value) {
    _$showToastAtom.reportWrite(value, super.showToast, () {
      super.showToast = value;
    });
  }

  final _$initAsyncAction = AsyncAction('_SettingsStore.init');

  @override
  Future init() {
    return _$initAsyncAction.run(() => super.init());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
showToast: ${showToast}
    ''';
  }
}
