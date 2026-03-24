import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/config/flavor_config.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/di/core_providers.dart';
import 'package:service_provider_umi/core/services/storage/hive_service.dart';
import 'package:service_provider_umi/core/services/storage/local_storage_service_impl.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig.initialize(
    flavor: Flavor.dev,
    baseUrl: 'https://dev.api.com',
    socketUrl: 'wss://dev.api.com/socket',
    googleMapsApiKey: 'YOUR_KEY',
    agoraAppId: 'AGORA_ID',
    stripePublishableKey: 'STRIPE_KEY',
  );

  // Init LocalStorageService (SharedPreferences + SecureStorage) + Hive
  final localStorage = LocalStorageServiceImpl();
  await localStorage.init();
  await HiveService.init();

  runApp(
    ProviderScope(
      overrides: [
        appRoleProvider.overrideWith(() => AppRoleNotifier(AppRole.guest)),
        localStorageProvider.overrideWithValue(localStorage),
        hiveStorageProvider.overrideWithValue(HiveService.instance),
      ],
      child: const App(),
    ),
  );
}
