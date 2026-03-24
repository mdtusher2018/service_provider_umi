import 'dart:ui';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/core_providers.dart';
import 'package:service_provider_umi/core/services/storage/storage_key.dart';

import '../config/app_constants.dart';

part 'locale_provider.g.dart';

@riverpod
class LocalizationNotifier extends _$LocalizationNotifier {
  @override
  Future<Locale> build() async {
    final storage = ref.read(localStorageProvider);
    final savedLocale = await storage.read(StorageKey.selectedLocale);
    return Locale(savedLocale ?? AppConstants.defaultLocale);
  }

  Future<void> setLocale(String languageCode) async {
    if (!AppConstants.supportedLocales.contains(languageCode)) return;

    state = AsyncData(Locale(languageCode));
    final storage = ref.read(localStorageProvider);
    await storage.write(StorageKey.selectedLocale, languageCode);
  }

  void setLocaleFromDevice() {
    final deviceLocale = PlatformDispatcher.instance.locale;
    final languageCode = deviceLocale.languageCode;

    if (AppConstants.supportedLocales.contains(languageCode)) {
      state = AsyncData(Locale(languageCode));
    } else {
      state = AsyncData(const Locale(AppConstants.defaultLocale));
    }
  }
}
