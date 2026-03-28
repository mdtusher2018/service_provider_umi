import 'package:service_provider_umi/core/base/repository.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/data_source/remote/notification_remote_data_source.dart';
import 'package:service_provider_umi/data/models/notification_models.dart';

class NotificationRepository with SafeCall {
  final NotificationRemoteDataSource _remote;

  NotificationRepository({required NotificationRemoteDataSource remote})
      : _remote = remote;

  // ── GET /notifications ───────────────────────────────────────────────────────
  Future<Result<List<NotificationItem>, Failure>> getMyNotifications() =>
      asyncGuard(() => _remote.getMyNotifications());

  // ── PATCH /notifications ─────────────────────────────────────────────────────
  Future<Result<void, Failure>> markNotifications(
          MarkNotificationsRequest request) =>
      asyncGuard(() => _remote.markNotifications(request));

  // ── DELETE /notifications ────────────────────────────────────────────────────
  Future<Result<void, Failure>> deleteNotifications() =>
      asyncGuard(() => _remote.deleteNotifications());
}
