

import 'package:service_provider_umi/shared/enums/app_enums.dart';

class FlavorConfig {
  final Flavor flavor;
  final String baseUrl;
  final String socketUrl;
  final String googleMapsApiKey;
  final String agoraAppId;
  final String stripePublishableKey;

  FlavorConfig._({
    required this.flavor,
    required this.baseUrl,
    required this.socketUrl,
    required this.googleMapsApiKey,
    required this.agoraAppId,
    required this.stripePublishableKey,
  });

  static late FlavorConfig _instance;

  static FlavorConfig get instance => _instance;

  static bool get isProduction => _instance.flavor == Flavor.prod;
  static bool get isDevelopment => _instance.flavor == Flavor.dev;
  static bool get isStaging => _instance.flavor == Flavor.staging;

  static void initialize({
    required Flavor flavor,
    required String baseUrl,
    required String socketUrl,
    required String googleMapsApiKey,
    required String agoraAppId,
    required String stripePublishableKey,
  }) {
    _instance = FlavorConfig._(
      flavor: flavor,
      baseUrl: baseUrl,
      socketUrl: socketUrl,
      googleMapsApiKey: googleMapsApiKey,
      agoraAppId: agoraAppId,
      stripePublishableKey: stripePublishableKey,
    );
  }
}
