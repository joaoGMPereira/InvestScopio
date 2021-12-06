import "package:i18n_extension/i18n_extension.dart";

class Strings {
  Strings._();

  static const String title_PT_BR = "Title";
  static const String simulations_tab_PT_BR = "Simulação";
  static const String simulation_creation_tab_PT_BR = "Criação";
  static const String settings_tab_PT_BR = "Configurações";
}

extension Localization on String {
  static var _t = Translations("pt_br") +
      {
        "en_us": Strings.title_PT_BR,
        "pt_br": Strings.title_PT_BR,
        "es_es": Strings.title_PT_BR,
      } +
      {
        "en_us": Strings.simulations_tab_PT_BR,
        "pt_br": Strings.simulations_tab_PT_BR,
        "es_es": Strings.simulations_tab_PT_BR,
      } +
      {
        "en_us": Strings.simulation_creation_tab_PT_BR,
        "pt_br": Strings.simulation_creation_tab_PT_BR,
        "es_es": Strings.simulation_creation_tab_PT_BR,
      } +
      {
        "en_us": Strings.settings_tab_PT_BR,
        "pt_br": Strings.settings_tab_PT_BR,
        "es_es": Strings.settings_tab_PT_BR,
      };

  String get i18n => localize(this, _t);
}
