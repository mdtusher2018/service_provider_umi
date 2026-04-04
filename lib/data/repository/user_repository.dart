import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_provider_umi/core/base/repository.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/data_source/remote/user_remote_data_source.dart';
import 'package:service_provider_umi/data/models/address_model.dart';
import 'package:service_provider_umi/data/models/auth_models.dart';
import 'package:service_provider_umi/data/models/misc_models.dart';
import 'package:service_provider_umi/data/models/search_models.dart';
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
  ) =>
      asyncGuard(() => _remote.updateMyProfile(data));

  // ── DELETE /users/delete-my-account ──────────────────────────────────────────
  Future<Result<void, Failure>> deleteMyAccount() =>
      asyncGuard(() => _remote.deleteMyAccount());

  // ── GET /users/addresses ─────────────────────────────────────────────────────
  Future<Result<List<AddressModel>, Failure>> getSavedAddresses() =>
      asyncGuard(() => _remote.getSavedAddresses());

  // ── POST /users/addresses ────────────────────────────────────────────────────
  Future<Result<void, Failure>> addAddress({
    required String name,
    required String address,
    required LatLng coordinates,
  }) =>
      asyncGuard(
        () => _remote.addAddress(
          name: name,
          address: address,
          coordinates: coordinates,
        ),
      );

  // ── PATCH /auth/change-password ──────────────────────────────────────────────
  Future<Result<void, Failure>> changePassword(
    ChangePasswordRequest request,
  ) =>
      asyncGuard(() => _remote.changePassword(request));

  // ── GET /users/favorites ─────────────────────────────────────────────────────
  Future<Result<List<ProviderSearchResult>, Failure>> getFavorites({
    int page = 1,
    int limit = 10,
  }) =>
      asyncGuard(() => _remote.getFavorites(page: page, limit: limit));

  // ── GET /support ─────────────────────────────────────────────────────────────
  Future<Result<SupportResponse, Failure>> getSupport() =>
      asyncGuard(() => _remote.getSupport());
}
