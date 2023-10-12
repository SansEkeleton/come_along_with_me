import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: ConfigurationPage(),
    );
  }
}

class ConfigurationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).configuration),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).chatOptions,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              title: Text(AppLocalizations.of(context).enableChat),
              value:
                  true, // You can set the initial value based on user preferences.
              onChanged: (value) {
                // Implement logic to enable/disable chat here.
              },
            ),
            Divider(),
            Text(
              AppLocalizations.of(context).locationOptions,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              title: Text(AppLocalizations.of(context).enableLocationSharing),
              value:
                  true, // You can set the initial value based on user preferences.
              onChanged: (value) {
                // Implement logic to enable/disable location sharing here.
              },
            ),
          ],
        ),
      ),
    );
  }
}

final List<Locale> supportedLocales = [
  Locale('en', 'US'),
  Locale('es', 'ES'),
];

class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String get configuration =>
      Intl.message('Configuration', name: 'configuration');
  String get chatOptions => Intl.message('Chat Options', name: 'chatOptions');
  String get enableChat => Intl.message('Enable Chat', name: 'enableChat');
  String get locationOptions =>
      Intl.message('Location Options', name: 'locationOptions');
  String get enableLocationSharing =>
      Intl.message('Enable Location Sharing', name: 'enableLocationSharing');

  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.languageCode;
    final String localeName = locale.countryCode;
    final String localeStr =
        (localeName == null || localeName.isEmpty) ? name : '$name_$localeName';
    final String jsonStr = 'assets/i18n/$localeStr.json';
    final String path = jsonStr;

    return initializeMessages(jsonStr).then((_) {
      Intl.defaultLocale = localeStr;
      return AppLocalizations();
    });
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return supportedLocales
        .where((element) => element.languageCode == locale.languageCode)
        .isNotEmpty;
  }

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
