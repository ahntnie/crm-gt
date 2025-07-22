part of '../core.dart';

class AppLanguage {
  final int? id;
  final String? name;
  final String? languageCode;
  final Locale? locale;

  AppLanguage({this.id, this.name, this.languageCode, this.locale});

  static List<AppLanguage> languageList() {
    return AppLocalizations.supportedLocales.map((e) {
      final id = AppLocalizations.supportedLocales.indexOf(e);
      final name = e.languageCode.toUpperCase();
      final languageCode = e.languageCode;
      return AppLanguage(
          id: id, name: name, languageCode: languageCode, locale: Locale(e.languageCode));
    }).toList();
  }

  static AppLanguage getLanguageByCode(String languageCode) {
    return languageList().firstWhere((element) => element.languageCode == languageCode);
  }

  static void changeLanguage(BuildContext context, String languageCode) {}
}

class LanguageType {
  static AppLanguage vietnamese = AppLanguage(
    name: 'VN',
    locale: const Locale('vi'),
  );
  static AppLanguage english = AppLanguage(
    name: 'ENG',
    locale: const Locale('en'),
  );
  static List<AppLanguage> all = [
    vietnamese,
    english,
  ];

  static List<AppLanguage> list(Locale? locale) {
    List<AppLanguage> langList = [];
    for (int i = 0; i < all.length; i++) {
      if (locale != null) {
        if (all[i].locale?.languageCode != locale.languageCode) {
          langList = [...langList, all[i]];
        }
      } else {
        langList = [...langList, all[i]];
      }
    }
    return langList;
  }

  static AppLanguage lang(Locale locale) {
    for (int i = 0; i < all.length; i++) {
      if (all[i].locale?.languageCode == locale.languageCode) {
        return all[i];
      }
    }
    return all[0];
  }
}
