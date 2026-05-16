import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/models/history_model.dart';
import 'package:service_provider_umi/data/models/notification_models.dart';
import 'package:service_provider_umi/data/repository/notification_and_history_repositiry.dart';
import 'package:service_provider_umi/shared/enums/all_enums.dart';

part 'communication_and_notification_provider.freezed.dart';
part 'communication_and_notification_provider.g.dart';

// ── State ─────────────────────────────────────────────────────────────────────

@freezed
abstract class NotificationListState with _$NotificationListState {
  const factory NotificationListState.initial() = NotificationListInitial;
  const factory NotificationListState.loading() = NotificationListLoading;
  const factory NotificationListState.success(
    List<NotificationItem> notifications,
  ) = NotificationListSuccess;
  const factory NotificationListState.failure(Failure failure) =
      NotificationListFailure;
}

@freezed
abstract class NotificationActionState with _$NotificationActionState {
  const factory NotificationActionState.initial() = NotificationActionInitial;
  const factory NotificationActionState.loading() = NotificationActionLoading;
  const factory NotificationActionState.success() = NotificationActionSuccess;
  const factory NotificationActionState.failure(Failure failure) =
      NotificationActionFailure;
}

// ── GET /notifications ────────────────────────────────────────────────────────

@riverpod
class NotificationsNotifier extends _$NotificationsNotifier {
  @override
  NotificationListState build() => const NotificationListState.initial();

  NotificationAndHistoryRepositiry get _repo =>
      ref.read(notificationAndHistoryRepositiryProvider);

  Future<void> fetch() async {
    state = const NotificationListState.loading();
    final result = await _repo.getMyNotifications();
    state = result.when(
      success: NotificationListState.success,
      failure: NotificationListState.failure,
    );
  }

  void reset() => state = const NotificationListState.initial();
}

// ── PATCH /notifications ──────────────────────────────────────────────────────

@riverpod
class MarkNotificationsNotifier extends _$MarkNotificationsNotifier {
  @override
  NotificationActionState build() => const NotificationActionState.initial();

  NotificationAndHistoryRepositiry get _repo =>
      ref.read(notificationAndHistoryRepositiryProvider);

  /// Pass [ids] to mark specific notifications, or null to mark all as read.
  Future<void> mark({List<String>? ids}) async {
    state = const NotificationActionState.loading();
    final result = await _repo.markNotifications(
      MarkNotificationsRequest(ids: ids),
    );
    state = result.when(
      success: (_) => const NotificationActionState.success(),
      failure: NotificationActionState.failure,
    );
  }

  void reset() => state = const NotificationActionState.initial();
}

// ── DELETE /notifications ─────────────────────────────────────────────────────

@riverpod
class DeleteNotificationsNotifier extends _$DeleteNotificationsNotifier {
  @override
  NotificationActionState build() => const NotificationActionState.initial();

  NotificationAndHistoryRepositiry get _repo =>
      ref.read(notificationAndHistoryRepositiryProvider);

  Future<void> deleteAll() async {
    state = const NotificationActionState.loading();
    final result = await _repo.deleteNotifications();
    state = result.when(
      success: (_) => const NotificationActionState.success(),
      failure: NotificationActionState.failure,
    );
  }

  void reset() => state = const NotificationActionState.initial();
}

// ── GET /Call History ────────────────────────────────────────────────────────
@freezed
abstract class CallHistoryState with _$CallHistoryState {
  const factory CallHistoryState.initial() = _Initial;
  const factory CallHistoryState.loading() = _Loading;
  const factory CallHistoryState.success(List<CallHistoryItem> data) = _Success;
  const factory CallHistoryState.failure(Failure failure) = _Failure;
}

@riverpod
class CallHistoryNotifier extends _$CallHistoryNotifier {
  @override
  CallHistoryState build() => const CallHistoryState.initial();

  NotificationAndHistoryRepositiry get _repo =>
      ref.read(notificationAndHistoryRepositiryProvider);

  Future<void> fetch() async {
    state = const CallHistoryState.loading();

    final result = await _repo.getCallHistory();

    state = result.when(
      success: CallHistoryState.success,
      failure: CallHistoryState.failure,
    );
  }

  /// Silent call history creation (no UI state change)
  Future<void> create({
    required String receiverId,
    required CallType type,
  }) async {
    await _repo.createCallHistory(receiverId: receiverId, type: type);
    fetch();
  }
}
