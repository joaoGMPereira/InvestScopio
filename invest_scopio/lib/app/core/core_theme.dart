import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoreTheme {
  // DESIGN SYSTEM
  static TextStyle? get headingMedium1 {
    return Get.textTheme.headline1?.copyWith(fontWeight: FontWeight.w500);
  }

  static TextStyle? get headingMedium2 {
    return Get.textTheme.headline2?.copyWith(fontWeight: FontWeight.w500);
  }

  static TextStyle? get headingMedium3 {
    return Get.textTheme.headline3?.copyWith(fontWeight: FontWeight.w500);
  }

  static TextStyle? get headingMedium4 {
    return Get.textTheme.headline4?.copyWith(fontWeight: FontWeight.w500);
  }

  static TextStyle? get headingMedium5 {
    return Get.textTheme.headline5?.copyWith(fontWeight: FontWeight.w500);
  }

  static TextStyle? get headingMedium6 {
    return Get.textTheme.headline6?.copyWith(fontWeight: FontWeight.w500);
  }

  static TextStyle? get titlePrimary {
    return Get.textTheme.headline3?.copyWith(
        fontWeight: FontWeight.w500,
        color: Get.theme.colorScheme.primaryVariant);
  }

  static TextStyle? get titleWhite {
    return Get.textTheme.headline3?.copyWith(
        fontWeight: FontWeight.w500,
        color: Get.theme.colorScheme.onPrimary);
  }
}
