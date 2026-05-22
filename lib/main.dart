// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/config/app_config.dart';
import 'package:service_provider_umi/core/config/flavor_config.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/di/core_providers.dart';
// import 'package:service_provider_umi/core/services/call_kit_service.dart';
import 'package:service_provider_umi/core/services/notification_service.dart';
import 'package:service_provider_umi/core/services/storage/local_storage_service_impl.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';

// Top-level — handles FCM when app is KILLED or BACKGROUND
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   if (message.data['type'] == 'incoming_call') {
//     await CallKitService.showIncomingCall(
//       callId: message.data['callId'],
//       callerId: message.data['callerId'],
//       callerName: message.data['callerName'],
//       callerImage: message.data['callerImage'],
//       channelId: message.data['channelId'],
//       isVideo: message.data['callType'] == 'video',
//     );
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig.initialize(
    flavor: Flavor.dev,
    baseUrl: 'http://103.186.20.117:1000/api/v1',
    socketUrl: 'http://103.186.20.117:6005',
    googleMapsApiKey: 'AIzaSyCSZNISQRt33W-FMIM8E-IL8vxo2H',
    agoraAppId: '179414c55d6b478e85009d175097a22e',
    stripePublishableKey:
        'pk_test_51RINl1PG9XHOcPc0EWzFHpb89UURpt1siYriwsWyU3EUfozu15bmm4M0x7t0KBDZ8FMTHGfo7xoD00SjmA5uK11A00htzh5FBi',
  );

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // await NotificationService.init();

  // Init LocalStorageService (SharedPreferences + SecureStorage) + Hive
  final localStorage = LocalStorageServiceImpl();
  await localStorage.init();

  // Stripe.publishableKey =
  //     "pk_test_51QThD1QBqUnkaNjmyEqpPBiRlHVBNAmKPAVOCqLEJp5xWEu9o6d65h21lLZNtr7V6ACNG9AkMh8qMUZUIVFTwYNj00xFV4BmxB";
  Stripe.publishableKey = AppConfig.stripePublishableKey;
  if (!kIsWeb) {
    await Stripe.instance.applySettings();
  }

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
