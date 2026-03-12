import 'dart:ui';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/local_storage.dart';
import '../storage/storage_keys.dart';
import '../config/app_constants.dart';

part 'locale_provider.g.dart';

@riverpod
class LocalizationNotifier extends _$LocalizationNotifier {
  @override
  Locale build() {
    final storage = ref.read(localStorageProvider).value;
    final savedLocale = storage?.getString(StorageKeys.selectedLocale);
    return Locale(savedLocale ?? AppConstants.defaultLocale);
  }

  Future<void> setLocale(String languageCode) async {
    if (!AppConstants.supportedLocales.contains(languageCode)) return;

    state = Locale(languageCode);
    final storage = await ref.read(localStorageProvider.future);
    await storage.setString(StorageKeys.selectedLocale, languageCode);
  }

  void setLocaleFromDevice() {
    final deviceLocale = PlatformDispatcher.instance.locale;
    final languageCode = deviceLocale.languageCode;

    if (AppConstants.supportedLocales.contains(languageCode)) {
      state = Locale(languageCode);
    } else {
      state = const Locale(AppConstants.defaultLocale);
    }
  }
}
