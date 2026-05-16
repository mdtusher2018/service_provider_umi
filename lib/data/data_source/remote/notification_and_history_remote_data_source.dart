import 'package:dio/dio.dart';
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
  Future<void> createCallHistory({
    required String receiverId,
    required CallType type,
  });
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
  Future<void> createCallHistory({
    required String receiverId,
    required CallType type,
  }) async {
    await _dio.patch(
      ApiEndpoints.callHistory,
      data: {
        "receiverId": receiverId,
        //"type": type.name
      },
    );
  }
}
