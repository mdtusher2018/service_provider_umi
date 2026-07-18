import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/models/provider_models.dart';
import 'package:service_provider_umi/data/models/user_models.dart';
import 'package:service_provider_umi/data/repository/service_repository.dart';
import 'package:service_provider_umi/data/repository/user_repository.dart';

part 'user_provider.freezed.dart';
part 'user_provider.g.dart';

// ── Generic user async state ──────────────────────────────────────────────────

@freezed
abstract class UserState with _$UserState {
  const factory UserState.initial() = UserStateInitial;
  const factory UserState.loading() = UserStateLoading;
  const factory UserState.success(UserProfile profile) = UserStateSuccess;
  const factory UserState.failure(Failure failure) = UserStateFailure;
}

@freezed
abstract class ActionState with _$ActionState {
  const factory ActionState.initial() = ActionStateInitial;
  const factory ActionState.loading() = ActionStateLoading;
  const factory ActionState.success() = ActionStateSuccess;
  const factory ActionState.failure(Failure failure) = ActionStateFailure;
}

@freezed
abstract class StripeConnectState with _$StripeConnectState {
  const factory StripeConnectState.initial() = StripeConnectStateInitial;
  const factory StripeConnectState.loading() = StripeConnectStateLoading;
  const factory StripeConnectState.success(String url) =
      StripeConnectStateSuccess;
  const factory StripeConnectState.failure(Failure failure) =
      StripeConnectStateFailure;
}

// ── GET /users/:id ────────────────────────────────────────────────────────────

@riverpod
class GetUserByIdNotifier extends _$GetUserByIdNotifier {
  @override
  UserState build() => const UserState.initial();

  UserRepository get _repo => ref.read(userRepositoryProvider);

  Future<void> fetch(String id) async {
    state = const UserState.loading();
    final result = await _repo.getUserById(id);
    if (!ref.mounted) return;
    state = result.when(success: UserState.success, failure: UserState.failure);
  }

  void reset() => state = const UserState.initial();
}

// ── GET /users/my-profile ─────────────────────────────────────────────────────

@riverpod
class MyProfileNotifier extends _$MyProfileNotifier {
  @override
  UserState build() => const UserState.initial();

  UserRepository get _repo => ref.read(userRepositoryProvider);

  Future<void> fetch() async {
    state = const UserState.loading();
    final result = await _repo.getMyProfile();
    if (!ref.mounted) return;
    state = result.when(success: UserState.success, failure: UserState.failure);
  }

  void reset() => state = const UserState.initial();
}

// ── PATCH /users/update-my-profile ───────────────────────────────────────────

@riverpod
class UpdateProfileNotifier extends _$UpdateProfileNotifier {
  @override
  UserState build() => const UserState.initial();

  UserRepository get _repo => ref.read(userRepositoryProvider);

  Future<void> update(UpdateProfileRequest data) async {
    state = const UserState.loading();
    final result = await _repo.updateMyProfile(data);
    if (!ref.mounted) return;
    state = result.when(success: UserState.success, failure: UserState.failure);
  }

  void reset() => state = const UserState.initial();
}

// ── DELETE /users/delete-my-account ──────────────────────────────────────────

@riverpod
class DeleteAccountNotifier extends _$DeleteAccountNotifier {
  @override
  ActionState build() => const ActionState.initial();

  UserRepository get _repo => ref.read(userRepositoryProvider);

  Future<void> deleteAccount() async {
    state = const ActionState.loading();

    final result = await _repo.deleteMyAccount();
    if (!ref.mounted) return;
    state = result.when(
      success: (_) => const ActionState.success(),
      failure: ActionState.failure,
    );
  }

  void reset() => state = const ActionState.initial();
}

@riverpod
class MyReviewNotifier extends _$MyReviewNotifier {
  int _page = 1;
  bool _hasMore = true;
  bool _isFetching = false;

  // 👇 expose to UI
  bool get hasMore => _hasMore;

  @override
  AsyncValue<List<ProviderComment>> build() {
    return const AsyncLoading();
  }

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  // ── Initial fetch ─────────────────────────────
  Future<void> fetch(String providerId) async {
    _page = 1;
    _hasMore = true;

    state = const AsyncLoading();

    final result = await _repo.getProviderReviews(providerId, page: _page);

    if (!ref.mounted) return;

    state = result.when(
      success: (data) {
        _hasMore = data.length == 10;
        return AsyncData(data);
      },
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }

  // ── Pagination ───────────────────────────────
  Future<void> loadMore(String providerId) async {
    if (!_hasMore || _isFetching) return;

    _isFetching = true;
    _page++;

    final current = state.value ?? [];

    final result = await _repo.getProviderReviews(providerId, page: _page);

    if (!ref.mounted) return;

    result.when(
      success: (data) {
        _hasMore = data.isNotEmpty;

        state = AsyncData([...current, ...data]);
      },
      failure: (e) {
        state = AsyncError(e, StackTrace.current);
      },
    );

    _isFetching = false;
  }
}

@riverpod
class StripeConnectNotifier extends _$StripeConnectNotifier {
  @override
  StripeConnectState build() => const StripeConnectState.initial();

  UserRepository get _repo => ref.read(userRepositoryProvider);

  Future<void> getStripeUrl() async {
    state = const StripeConnectState.loading();

    final result = await _repo.getStripeConnetedUrl();

    if (!ref.mounted) return;

    state = result.when(
      success: (url) => StripeConnectState.success(url),
      failure: StripeConnectState.failure,
    );
  }

  void reset() => state = const StripeConnectState.initial();
}

@riverpod
class AddFaqNotifier extends _$AddFaqNotifier {
  @override
  ActionState build() => const ActionState.initial();

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  Future<void> addFaq({
    required String question,
    required String answer,
    required String userId,
  }) async {
    if (!ref.mounted) return;
    state = const ActionState.loading();

    final result = await _repo.createFaq(
      question: question,
      answer: answer,
      userId: userId,
    );

    if (!ref.mounted) return;

    state = result.when(
      success: (_) => const ActionState.success(),
      failure: ActionState.failure,
    );
  }

  void reset() => state = const ActionState.initial();
}
