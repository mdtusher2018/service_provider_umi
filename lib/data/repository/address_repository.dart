import 'package:service_provider_umi/core/base/repository.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/data_source/remote/address_remote_data_source.dart';
import 'package:service_provider_umi/data/models/address_model.dart';

class AddressRepository with SafeCall {
  final AddressRemoteDataSource _remote;

  AddressRepository({required AddressRemoteDataSource remote})
      : _remote = remote;

  // ── GET /address ─────────────────────────────────────────────────────────────
  Future<Result<AddressListResponse, Failure>> getAllAddresses({
    int page = 1,
    int limit = 10,
  }) => asyncGuard(() => _remote.getAllAddresses(page: page, limit: limit));

  // ── POST /address ─────────────────────────────────────────────────────────────
  Future<Result<AddressModel, Failure>> createAddress(
    CreateAddressRequest request,
  ) => asyncGuard(() => _remote.createAddress(request));

  // ── PATCH /address/:id ────────────────────────────────────────────────────────
  Future<Result<AddressModel, Failure>> updateAddress(
    String addressId,
    UpdateAddressRequest request,
  ) => asyncGuard(() => _remote.updateAddress(addressId, request));

  // ── DELETE /address/:id ───────────────────────────────────────────────────────
  Future<Result<void, Failure>> deleteAddress(String addressId) =>
      asyncGuard(() => _remote.deleteAddress(addressId));
}
