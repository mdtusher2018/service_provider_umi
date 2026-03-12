import 'flavor_config.dart';

class AppConfig {
  AppConfig._();

  static String get baseUrl => FlavorConfig.instance.baseUrl;
  static String get socketUrl => FlavorConfig.instance.socketUrl;
  static String get googleMapsApiKey => FlavorConfig.instance.googleMapsApiKey;
  static String get agoraAppId => FlavorConfig.instance.agoraAppId;
  static String get stripePublishableKey =>
      FlavorConfig.instance.stripePublishableKey;

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Pagination
  static const int defaultPageSize = 20;

  // Cache
  static const int cacheMaxAge = 7; // days

  // File Upload
  static const int maxImageSizeInMB = 5;
  static const int maxVideoSizeInMB = 50;
}
