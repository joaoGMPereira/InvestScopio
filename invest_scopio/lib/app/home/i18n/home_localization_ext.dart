import "package:i18n_extension/i18n_extension.dart";

class Strings {
  Strings._();

  static const String title_PT_BR = "Title";
}

extension Localization on String {
  static var _t = Translations("pt_br") +
      {
        "en_us": Strings.title_PT_BR,
        "pt_br": Strings.title_PT_BR,
        "es_es": Strings.title_PT_BR,
      };

  String get i18n => localize(this, _t);
}
