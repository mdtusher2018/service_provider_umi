import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/services/network/dio_client.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Provider Monthly Analytics Model
/// ─────────────────────────────────────────────────────────────────────────────
class ProviderMonthlyAnalytics {
  final int requestsReceived;
  final int bookingsAccepted;
  final String acceptanceRate;

  const ProviderMonthlyAnalytics({
    required this.requestsReceived,
    required this.bookingsAccepted,
    required this.acceptanceRate,
  });

  factory ProviderMonthlyAnalytics.fromJson(Map<String, dynamic> json) {
    final requests = json['requestsReceived'] ?? json['requests_received'] ?? 0;
    final bookings = json['bookingsAccepted'] ?? json['bookings_accepted'] ?? 0;
    final rate = json['acceptanceRate'] ?? json['acceptance_rate'];

    String rateStr;
    if (rate is num) {
      rateStr = '${rate.toStringAsFixed(0)}%';
    } else if (rate is String) {
      rateStr = rate.contains('%') ? rate : '$rate%';
    } else {
      // Calculate from requests and bookings
      if (requests > 0) {
        rateStr = '${((bookings / requests) * 100).toStringAsFixed(0)}%';
      } else {
        rateStr = '0%';
      }
    }

    return ProviderMonthlyAnalytics(
      requestsReceived: requests is int ? requests : (requests as num).toInt(),
      bookingsAccepted: bookings is int ? bookings : (bookings as num).toInt(),
      acceptanceRate: rateStr,
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// Provider for fetching monthly analytics
/// ─────────────────────────────────────────────────────────────────────────────
final providerMonthlyAnalyticsProvider = FutureProvider<ProviderMonthlyAnalytics>((ref) async {
  final dio = ref.watch(dioClientProvider);
  try {
    debugPrint('📡 [MonthlyAnalytics] Fetching /bookings/provider-monthly-analytics...');
    final response = await dio.get('/bookings/provider-monthly-analytics');
    debugPrint('📡 [MonthlyAnalytics] Status Code: ${response.statusCode}');
    debugPrint('📡 [MonthlyAnalytics] Response Data: ${response.data}');
    if (response.statusCode == 200) {
      final data = response.data;
      // Handle both { data: {...} } and direct {...} response shapes
      final json = data is Map<String, dynamic> && data.containsKey('data')
          ? data['data'] as Map<String, dynamic>
          : data as Map<String, dynamic>;
      debugPrint('📡 [MonthlyAnalytics] Parsed JSON: $json');
      final analytics = ProviderMonthlyAnalytics.fromJson(json);
      debugPrint('✅ [MonthlyAnalytics] Requests: ${analytics.requestsReceived}, Bookings: ${analytics.bookingsAccepted}, Rate: ${analytics.acceptanceRate}');
      return analytics;
    }
    throw Exception('Failed to fetch analytics. Status: ${response.statusCode}');
  } catch (e) {
    debugPrint('❌ [MonthlyAnalytics] Error: $e');
    rethrow;
  }
});
