import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

const _localePrefsKey = 'selected_locale';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});

class LocaleNotifier extends StateNotifier<Locale> {
  final SharedPreferences _prefs;

  LocaleNotifier(this._prefs) : super(_loadInitialLocale(_prefs));

  static Locale _loadInitialLocale(SharedPreferences prefs) {
    final languageCode = prefs.getString(_localePrefsKey) ?? 'en';
    return Locale(languageCode);
  }

  void setLocale(Locale locale) {
    if (locale == state) return;
    state = locale;
    _prefs.setString(_localePrefsKey, locale.languageCode);
  }

  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'ro':
        return 'Romanian';
      case 'fr':
        return 'French';
      case 'es':
        return 'Spanish';
      case 'de':
        return 'German';
      case 'ar':
        return 'Arabic';
      case 'pt':
        return 'Portuguese';
      case 'it':
        return 'Italian';
      default:
        return 'English';
    }
  }

  static String getLanguageCode(String languageName) {
    switch (languageName) {
      case 'English':
        return 'en';
      case 'Romanian':
        return 'ro';
      case 'French':
        return 'fr';
      case 'Spanish':
        return 'es';
      case 'German':
        return 'de';
      case 'Arabic':
        return 'ar';
      case 'Portuguese':
        return 'pt';
      case 'Italian':
        return 'it';
      default:
        return 'en';
    }
  }
}
