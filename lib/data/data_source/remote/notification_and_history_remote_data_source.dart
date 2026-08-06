import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/history_model.dart';
import 'package:service_provider_umi/data/models/notification_models.dart';
import 'package:service_provider_umi/shared/enums/all_enums.dart';

abstract class NotificationAndHistoryRemoteDataSource {
  Future<List<NotificationItem>> getMyNotifications();
  Future<void> markNotifications(MarkNotificationsRequest request);
  Future<void> deleteNotifications();
  Future<List<CallHistoryItem>> getCallHistory();
  Future<Map<String, dynamic>?> createCallHistory({
    required String receiverId,
    required CallType type,
  });
  Future<void> acceptCall(String callId);
  Future<void> rejectCall(String callId);
  Future<void> cancelCall(String callId);
  Future<void> endCall(String callId);
  Future<Map<String, dynamic>> getAgoraToken(String callId);
}

class NotificationAndHistoryRemoteDataSourceImpl
    implements NotificationAndHistoryRemoteDataSource {
  final Dio _dio;

  NotificationAndHistoryRemoteDataSourceImpl({required Dio apiService})
    : _dio = apiService;

  // ── GET /notifications (bearer) ───────────────────────────────────────────
  @override
  Future<List<NotificationItem>> getMyNotifications() async {
    final response = await _dio.get(ApiEndpoints.notifications);
    final apiResponse = ApiResponse<List<NotificationItem>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => (data as List)
          .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    if (!apiResponse.success) {
      throw Exception(
        apiResponse.error?.message ?? 'Failed to fetch notifications',
      );
    }
    return apiResponse.data ?? [];
  }

  // ── PATCH /notifications (bearer) ─────────────────────────────────────────
  @override
  Future<void> markNotifications(MarkNotificationsRequest request) async {
    await _dio.patch(ApiEndpoints.notifications, data: request.toJson());
  }

  // ── DELETE /notifications (bearer) ────────────────────────────────────────
  @override
  Future<void> deleteNotifications() async {
    await _dio.delete(ApiEndpoints.notifications);
  }

  // ── GET /notifications (bearer) ───────────────────────────────────────────
  @override
  Future<List<CallHistoryItem>> getCallHistory() async {
    final response = await _dio.get(ApiEndpoints.callHistory);
    final apiResponse = ApiResponse<List<CallHistoryItem>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => (data['data'] as List)
          .map((e) => CallHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    if (!apiResponse.success) {
      throw Exception(
        apiResponse.error?.message ?? 'Failed to fetch notifications',
      );
    }
    return apiResponse.data ?? [];
  }

  // ── PATCH /notifications (bearer) ─────────────────────────────────────────
  @override
  Future<Map<String, dynamic>?> createCallHistory({
    required String receiverId,
    required CallType type,
  }) async {
    final typeString = type == CallType.audio ? 'audio_call' : 'video_call';
    debugPrint('📞 [Call API] POST ${ApiEndpoints.callHistory}');
    debugPrint('📞 [Call API] Request Body: {"receiverId": "$receiverId", "type": "$typeString"}');
    final response = await _dio.post(
      ApiEndpoints.callHistory,
      data: {
        "receiverId": receiverId,
        "type": typeString, // video_call or audio_call
      },
    );
    debugPrint('📞 [Call API] Response: ${response.data}');
    
    final data = response.data;
    if (data is Map<String, dynamic> && data['data'] != null) {
      return Map<String, dynamic>.from(data['data'] as Map);
    }
    return null;
  }

  @override
  Future<void> acceptCall(String callId) async {
    final endpoint = '${ApiEndpoints.callHistory}/$callId/accept';
    debugPrint('📞 [Call API] PATCH $endpoint');
    final response = await _dio.patch(endpoint);
    debugPrint('📞 [Call API] Response: ${response.data}');
  }

  @override
  Future<void> rejectCall(String callId) async {
    final endpoint = '${ApiEndpoints.callHistory}/$callId/reject';
    debugPrint('📞 [Call API] PATCH $endpoint');
    final response = await _dio.patch(endpoint);
    debugPrint('📞 [Call API] Response: ${response.data}');
  }

  @override
  Future<void> cancelCall(String callId) async {
    final endpoint = '${ApiEndpoints.callHistory}/$callId/cancel';
    debugPrint('📞 [Call API] PATCH $endpoint');
    final response = await _dio.patch(endpoint);
    debugPrint('📞 [Call API] Response: ${response.data}');
  }

  @override
  Future<void> endCall(String callId) async {
    final endpoint = '${ApiEndpoints.callHistory}/$callId/end';
    debugPrint('📞 [Call API] PATCH $endpoint');
    final response = await _dio.patch(endpoint);
    debugPrint('📞 [Call API] Response: ${response.data}');
  }

  @override
  Future<Map<String, dynamic>> getAgoraToken(String callId) async {
    final endpoint = ApiEndpoints.getAgoraToken(callId);
    debugPrint('📞 [Call API] GET $endpoint');
    final response = await _dio.get(endpoint);
    debugPrint('📞 [Call API] Response: ${response.data}');
    
    if (response.data != null && response.data['success'] == true) {
      return response.data['data'] as Map<String, dynamic>;
    }
    throw Exception('Failed to get Agora token');
  }
}
