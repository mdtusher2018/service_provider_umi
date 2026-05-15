import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/config/flavor_config.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/di/core_providers.dart';
import 'package:service_provider_umi/core/services/storage/local_storage_service_impl.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig.initialize(
    flavor: Flavor.dev,
    baseUrl: 'http://103.186.20.117:1000/api/v1',
    socketUrl: 'http://103.186.20.117:6005',
    // baseUrl: 'http://10.10.10.21:3000',
    // socketUrl: 'http://10.10.10.21:3000',
    googleMapsApiKey: 'YOUR_KEY',
    agoraAppId: '87317ef9a331453ca1463797ba82cd41',
    stripePublishableKey: 'STRIPE_KEY',
  );

  // Init LocalStorageService (SharedPreferences + SecureStorage) + Hive
  final localStorage = LocalStorageServiceImpl();
  await localStorage.init();

  Stripe.publishableKey =
      "pk_test_51RINl1PG9XHOcPc0EWzFHpb89UURpt1siYriwsWyU3EUfozu15bmm4M0x7t0KBDZ8FMTHGfo7xoD00SjmA5uK11A00htzh5FBi";
  await Stripe.instance.applySettings();

  if (kDebugMode) {
    /// 🔴 Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);

      debugPrint('🔥 FLUTTER ERROR: ${details.exception}');
      debugPrint('STACK: ${details.stack}');
    };

    /// 🔴 Platform / async errors (Flutter 3.3+)
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('🔥 PLATFORM ERROR: $error');
      debugPrint('STACK: $stack');
      return true;
    };
  }
  setPathUrlStrategy();
  runApp(
    ProviderScope(
      overrides: [
        appRoleProvider.overrideWith(() => AppRoleNotifier()),
        localStorageProvider.overrideWithValue(localStorage),
      ],
      child: const App(),
    ),
  );
}
