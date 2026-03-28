import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/models/notification_models.dart';
import 'package:service_provider_umi/data/repository/notification_repository.dart';

part 'notification_provider.freezed.dart';
part 'notification_provider.g.dart';

// ── State ─────────────────────────────────────────────────────────────────────

@freezed
abstract class NotificationListState with _$NotificationListState {
  const factory NotificationListState.initial() = NotificationListInitial;
  const factory NotificationListState.loading() = NotificationListLoading;
  const factory NotificationListState.success(
      List<NotificationItem> notifications) = NotificationListSuccess;
  const factory NotificationListState.failure(Failure failure) =
      NotificationListFailure;
}

@freezed
abstract class NotificationActionState with _$NotificationActionState {
  const factory NotificationActionState.initial() =
      NotificationActionInitial;
  const factory NotificationActionState.loading() =
      NotificationActionLoading;
  const factory NotificationActionState.success() =
      NotificationActionSuccess;
  const factory NotificationActionState.failure(Failure failure) =
      NotificationActionFailure;
}

// ── GET /notifications ────────────────────────────────────────────────────────

@riverpod
class NotificationsNotifier extends _$NotificationsNotifier {
  @override
  NotificationListState build() => const NotificationListState.initial();

  NotificationRepository get _repo =>
      ref.read(notificationRepositoryProvider);

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
  NotificationActionState build() =>
      const NotificationActionState.initial();

  NotificationRepository get _repo =>
      ref.read(notificationRepositoryProvider);

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
  NotificationActionState build() =>
      const NotificationActionState.initial();

  NotificationRepository get _repo =>
      ref.read(notificationRepositoryProvider);

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
