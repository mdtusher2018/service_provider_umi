import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

@riverpod
AnalyticsService analyticsService(Ref ref) {
  return AnalyticsService();
}

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  Future<void> logLogin({required String method}) async {
    await _analytics.logLogin(loginMethod: method);
  }

  Future<void> logSignUp({required String method}) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
  }

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (kDebugMode) {
      debugPrint('📊 Analytics Event: $name | Params: $parameters');
    }
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> logBookingCreated({
    required String serviceId,
    required double price,
  }) async {
    await logEvent(
      name: 'booking_created',
      parameters: {'service_id': serviceId, 'price': price},
    );
  }

  Future<void> logBookingCancelled({required String bookingId}) async {
    await logEvent(
      name: 'booking_cancelled',
      parameters: {'booking_id': bookingId},
    );
  }

  Future<void> logPaymentCompleted({
    required String paymentId,
    required double amount,
    required String currency,
  }) async {
    await _analytics.logPurchase(
      transactionId: paymentId,
      value: amount,
      currency: currency,
    );
  }

  Future<void> logSearch({required String query}) async {
    await _analytics.logSearch(searchTerm: query);
  }

  Future<void> logServiceViewed({required String serviceId}) async {
    await logEvent(
      name: 'service_viewed',
      parameters: {'service_id': serviceId},
    );
  }

  Future<void> logFavoriteToggled({
    required String serviceId,
    required bool isFavorited,
  }) async {
    await logEvent(
      name: isFavorited ? 'service_favorited' : 'service_unfavorited',
      parameters: {'service_id': serviceId},
    );
  }

  Future<void> logRoleSwitch({required String newRole}) async {
    await logEvent(name: 'role_switched', parameters: {'new_role': newRole});
  }

  Future<void> reset() async {
    await _analytics.resetAnalyticsData();
  }
}
