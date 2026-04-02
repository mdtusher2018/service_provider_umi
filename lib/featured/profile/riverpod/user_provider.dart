import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/models/user_models.dart';
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

// ── GET /users/:id ────────────────────────────────────────────────────────────

@riverpod
class GetUserByIdNotifier extends _$GetUserByIdNotifier {
  @override
  UserState build() => const UserState.initial();

  UserRepository get _repo => ref.read(userRepositoryProvider);

  Future<void> fetch(String id) async {
    state = const UserState.loading();
    final result = await _repo.getUserById(id);
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
    if (!ref.mounted) return;
    state = const UserState.loading();
    final result = await _repo.updateMyProfile(data);
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
    if (!ref.mounted) return;
    state = const ActionState.loading();

    final result = await _repo.deleteMyAccount();
    state = result.when(
      success: (_) => const ActionState.success(),
      failure: ActionState.failure,
    );
  }

  void reset() => state = const ActionState.initial();
}
