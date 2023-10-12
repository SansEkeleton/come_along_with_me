import 'package:flutter/widgets.dart';

class AppTranslations {
  static Map<String, Map<String, String>> translations = {
    'en': {
      'chatOptions': 'Chat Options',
      'enableChat': 'Enable Chat',
      'locationOptions': 'Location Options',
      'enableLocationSharing': 'Enable Location Sharing',
    },
    'es': {
      'chatOptions': 'Opciones de Chat',
      'enableChat': 'Activar Chat',
      'locationOptions': 'Opciones de Ubicación',
      'enableLocationSharing': 'Activar Compartir Ubicación',
    },
  };

  static Map<String, String>? currentTranslations = translations['en'];

  static void load(Locale locale) {
    final languageCode = locale.languageCode;
    if (translations.containsKey(languageCode)) {
      currentTranslations = translations[languageCode]!;
    } else {
      currentTranslations = translations['en']!;
    }
  }
}
