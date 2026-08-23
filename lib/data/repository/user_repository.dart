import 'package:service_provider_umi/core/base/repository.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/data_source/remote/user_remote_data_source.dart';
import 'package:service_provider_umi/data/models/auth_models.dart';
import 'package:service_provider_umi/data/models/favorites_model.dart';
import 'package:service_provider_umi/data/models/mock_misc_models.dart';
import 'package:service_provider_umi/data/models/user_document_model.dart';
import 'package:service_provider_umi/data/models/user_models.dart';
import 'package:service_provider_umi/featured/service/riverpod/verification_provider.dart';

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

  // ── PATCH /auth/change-password ──────────────────────────────────────────────
  Future<Result<void, Failure>> changePassword(ChangePasswordRequest request) =>
      asyncGuard(() => _remote.changePassword(request));

  // ── GET /users/favorites ─────────────────────────────────────────────────────
  Future<Result<List<FavoriteModel>, Failure>> getFavorites({
    int page = 1,
    int limit = 10,
  }) => asyncGuard(() => _remote.getFavorites(page: page, limit: limit));

  Future<Result<void, Failure>> toggleFavorite({required String id}) =>
      asyncGuard(() => _remote.toggleFavorite(id: id));

  // ── GET /support ─────────────────────────────────────────────────────────────
  Future<Result<SupportResponse, Failure>> getSupport() =>
      asyncGuard(() => _remote.getSupport());

  Future<Result<String, Failure>> getStripeConnetedUrl() =>
      asyncGuard(() => _remote.getStripeConnetedUrl());

  Future<Result<bool, Failure>> submitVerification(
    VerificationRequest request,
  ) => asyncGuard(() => _remote.submitVerification(request));

  // ── GET /users/my-documents ──────────────────────────────────────────────
  Future<Result<List<UserDocumentModel>, Failure>> getMyDocuments() =>
      asyncGuard(() => _remote.getMyDocuments());
}
