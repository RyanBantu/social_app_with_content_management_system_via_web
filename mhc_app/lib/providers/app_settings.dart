import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_strings.dart';

class AppSettings extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  AppLanguage _language = AppLanguage.english;
  bool _onboardingComplete = false;

  ThemeMode get themeMode => _themeMode;
  AppLanguage get language => _language;
  bool get onboardingComplete => _onboardingComplete;
  bool get isDark => _themeMode == ThemeMode.dark;
  bool get isKannada => _language == AppLanguage.kannada;

  String t(String key) => AppStrings.get(_language, key);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = prefs.getBool('isDark') ?? true
        ? ThemeMode.dark
        : ThemeMode.light;
    _language = prefs.getString('language') == 'kannada'
        ? AppLanguage.kannada
        : AppLanguage.english;
    _onboardingComplete = prefs.getBool('onboardingComplete') ?? false;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', mode == ThemeMode.dark);
  }

  Future<void> setLanguage(AppLanguage lang) async {
    if (_language == lang) return;
    _language = lang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'language',
      lang == AppLanguage.kannada ? 'kannada' : 'english',
    );
  }

  Future<void> completeOnboarding() async {
    _onboardingComplete = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
    notifyListeners();
  }

  void toggleTheme() {
    setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }

  void toggleLanguage() {
    setLanguage(
      _language == AppLanguage.english
          ? AppLanguage.kannada
          : AppLanguage.english,
    );
  }
}
