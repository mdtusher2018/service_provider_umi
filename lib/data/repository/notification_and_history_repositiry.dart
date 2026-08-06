import 'package:service_provider_umi/core/base/repository.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/data_source/remote/notification_and_history_remote_data_source.dart';
import 'package:service_provider_umi/data/models/history_model.dart';
import 'package:service_provider_umi/data/models/notification_models.dart';
import 'package:service_provider_umi/shared/enums/all_enums.dart';

class NotificationAndHistoryRepositiry with SafeCall {
  final NotificationAndHistoryRemoteDataSource _remote;

  NotificationAndHistoryRepositiry({
    required NotificationAndHistoryRemoteDataSource remote,
  }) : _remote = remote;

  // ── GET /notifications ───────────────────────────────────────────────────────
  Future<Result<List<NotificationItem>, Failure>> getMyNotifications() =>
      asyncGuard(() => _remote.getMyNotifications());

  // ── PATCH /notifications ─────────────────────────────────────────────────────
  Future<Result<void, Failure>> markNotifications(
    MarkNotificationsRequest request,
  ) => asyncGuard(() => _remote.markNotifications(request));

  // ── DELETE /notifications ────────────────────────────────────────────────────
  Future<Result<void, Failure>> deleteNotifications() =>
      asyncGuard(() => _remote.deleteNotifications());

  // ── GET /notifications ───────────────────────────────────────────────────────
  Future<Result<List<CallHistoryItem>, Failure>> getCallHistory() =>
      asyncGuard(() => _remote.getCallHistory());

  // ── PATCH /notifications ─────────────────────────────────────────────────────
  Future<Result<Map<String, dynamic>?, Failure>> createCallHistory({
    required String receiverId,
    required CallType type,
  }) => asyncGuard(
    () => _remote.createCallHistory(receiverId: receiverId, type: type),
  );

  // ── PATCH /call-history/:callId/accept ───────────────────────────────────────
  Future<Result<void, Failure>> acceptCall(String callId) =>
      asyncGuard(() => _remote.acceptCall(callId));

  // ── PATCH /call-history/:callId/reject ───────────────────────────────────────
  Future<Result<void, Failure>> rejectCall(String callId) =>
      asyncGuard(() => _remote.rejectCall(callId));

  // ── PATCH /call-history/:callId/cancel ───────────────────────────────────────
  Future<Result<void, Failure>> cancelCall(String callId) =>
      asyncGuard(() => _remote.cancelCall(callId));

  // ── PATCH /call-history/:callId/end ──────────────────────────────────────────
  Future<Result<void, Failure>> endCall(String callId) =>
      asyncGuard(() => _remote.endCall(callId));

  // ── GET /agora/token/:callId ───────────────────────────────────────────────
  Future<Result<Map<String, dynamic>, Failure>> getAgoraToken(String callId) =>
      asyncGuard(() => _remote.getAgoraToken(callId));
}
