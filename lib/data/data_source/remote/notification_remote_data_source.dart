import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/notification_models.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationItem>> getMyNotifications();
  Future<void> markNotifications(MarkNotificationsRequest request);
  Future<void> deleteNotifications();
}

class NotificationRemoteDataSourceImpl
    implements NotificationRemoteDataSource {
  final Dio _dio;

  NotificationRemoteDataSourceImpl({required Dio apiService})
      : _dio = apiService;

  // ── GET /notifications (bearer) ───────────────────────────────────────────
  @override
  Future<List<NotificationItem>> getMyNotifications() async {
    final response = await _dio.get(ApiEndpoints.notifications);
    final apiResponse = ApiResponse<List<NotificationItem>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => (data as List)
          .map((e) =>
              NotificationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    if (!apiResponse.success) {
      throw Exception(
          apiResponse.error?.message ?? 'Failed to fetch notifications');
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
}
