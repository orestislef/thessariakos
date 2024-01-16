import 'package:flutter/material.dart';

class LanguageHelper {
  static String getLanguageUsedInApp(BuildContext context) {
    String languageCode = Localizations.localeOf(context).languageCode;
    return languageCode;
  }

  static String getLanguageUsedInAppISO(BuildContext context) {
    return Localizations.localeOf(context).toLanguageTag().replaceAll('-', "_");
  }

  static String getLanguage(String languageTag) {
    switch (languageTag) {
      case 'en-US':
        return 'English';
      case 'el-GR':
        return 'Ελληνικά';
    // Add more cases for other languages if needed
      default:
        return 'Unknown';
    }
  }

  static List<Locale> getAvailableLocales() {
    return [const Locale('en', 'US'), const Locale('el', 'GR')];
  }
}
