import 'package:service_provider_umi/core/base/repository.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/data_source/remote/user_remote_data_source.dart';
import 'package:service_provider_umi/data/models/user_models.dart';

class UserRepository with SafeCall {
  final UserRemoteDataSource _remote;

  UserRepository({required UserRemoteDataSource remote}) : _remote = remote;

  // ── GET /users/:id ───────────────────────────────────────────────────────────
  Future<Result<UserProfile, Failure>> getUserById(String id) =>
      asyncGuard(() => _remote.getUserById(id));

  // ── GET /users/my-profile ────────────────────────────────────────────────────
  Future<Result<UserProfile, Failure>> getMyProfile() =>
      asyncGuard(() => _remote.getMyProfile());

  // ── PATCH /users/update-my-profile ───────────────────────────────────────────
  Future<Result<UserProfile, Failure>> updateMyProfile(
    UpdateProfileRequest data,
  ) => asyncGuard(() => _remote.updateMyProfile(data));

  // ── DELETE /users/delete-my-account ──────────────────────────────────────────
  Future<Result<void, Failure>> deleteMyAccount() =>
      asyncGuard(() => _remote.deleteMyAccount());
}
