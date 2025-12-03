import 'package:flutter/foundation.dart';
import '../core/utils/app_strings.dart';

class LanguageProvider with ChangeNotifier {
  String _language = AppStrings.languageFr;

  String get currentLanguage => _language;

  void setLanguage(String language) {
    if (language == AppStrings.languageFr || language == AppStrings.languageEn) {
      _language = language;
      notifyListeners();
    }
  }

  String getText(String key) {
    return AppStrings.get(key, _language);
  }
}