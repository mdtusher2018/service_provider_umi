import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/data/models/address_model.dart';
import 'package:service_provider_umi/data/repository/address_repository.dart';

part 'address_provider.g.dart';

@riverpod
class AddressNotifier extends _$AddressNotifier {
  @override
  AsyncValue<List<AddressModel>> build() {
    fetch();
    return const AsyncLoading();
  }

  AddressRepository get _repo => ref.read(addressRepositoryProvider);

  // ── Fetch all ─────────────────────────────────────────────────────────────────
  Future<void> fetch() async {
    state = const AsyncLoading();

    final result = await _repo.getAllAddresses();

    if (!ref.mounted) return;

    state = result.when(
      success: (res) => AsyncData(res.addresses),
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }

  // ── Create ────────────────────────────────────────────────────────────────────
  Future<String?> createAddress(CreateAddressRequest request) async {
    final result = await _repo.createAddress(request);

    return result.when(
      success: (newAddress) {
        final current = state.value ?? [];
        state = AsyncData([...current, newAddress]);
        return null; // null = success, no error message
      },
      failure: (e) => e.message,
    );
  }

  // ── Update ────────────────────────────────────────────────────────────────────
  Future<String?> updateAddress(
    String addressId,
    UpdateAddressRequest request,
  ) async {
    final result = await _repo.updateAddress(addressId, request);

    return result.when(
      success: (updated) {
        final current = state.value ?? [];
        // If this update sets isDefault=true, clear others
        final updatedList = current.map((a) {
          if (a.id == addressId) return updated;
          if (updated.isDefault) return a.copyWith(isDefault: false);
          return a;
        }).toList();
        state = AsyncData(updatedList);
        return null;
      },
      failure: (e) => e.message,
    );
  }

  // ── Delete ────────────────────────────────────────────────────────────────────
  Future<String?> deleteAddress(String addressId) async {
    final result = await _repo.deleteAddress(addressId);

    return result.when(
      success: (_) {
        final current = state.value ?? [];
        state = AsyncData(current.where((a) => a.id != addressId).toList());
        return null;
      },
      failure: (e) => e.message,
    );
  }

  // ── Set default ───────────────────────────────────────────────────────────────
  Future<String?> setDefault(AddressModel address) async {
    // Build an UpdateAddressRequest carrying the existing data + isDefault:true
    final request = UpdateAddressRequest(
      addressLine1: address.addressLine1,
      addressLine2: address.addressLine2,
      city: address.city,
      state: address.state,
      postalCode: address.postalCode,
      country: address.country,
      lat: address.lat,
      lng: address.lng,
      isDefault: true,
    );

    return updateAddress(address.id, request);
  }
}

/// ── Selected Address Global State ───────────────────────────────────────────────
final selectedAddressIdProvider = StateProvider<String?>((ref) => null);
