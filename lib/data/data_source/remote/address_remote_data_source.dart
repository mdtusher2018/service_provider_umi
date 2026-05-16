import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/address_model.dart';

abstract class AddressRemoteDataSource {
  Future<AddressListResponse> getAllAddresses({int page, int limit});
  Future<AddressModel> createAddress(CreateAddressRequest request);
  Future<AddressModel> updateAddress(
    String addressId,
    UpdateAddressRequest request,
  );
  Future<void> deleteAddress(String addressId);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final Dio _dio;

  AddressRemoteDataSourceImpl({required Dio apiService}) : _dio = apiService;

  // ── GET /address ─────────────────────────────────────────────────────────────
  @override
  Future<AddressListResponse> getAllAddresses({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.addresses,
      queryParameters: {'page': page, 'limit': limit},
    );
    final json = response.data as Map<String, dynamic>;
    final success = json['success'] as bool? ?? false;
    if (!success) {
      throw Exception(json['message'] ?? 'Failed to fetch addresses');
    }
    return AddressListResponse.fromJson(json);
  }

  // ── POST /address ────────────────────────────────────────────────────────────
  @override
  Future<AddressModel> createAddress(CreateAddressRequest request) async {
    final response = await _dio.post(
      ApiEndpoints.addresses,
      data: request.toJson(),
    );
    return _parseAddress(response);
  }

  // ── PATCH /address/:id ───────────────────────────────────────────────────────
  @override
  Future<AddressModel> updateAddress(
    String addressId,
    UpdateAddressRequest request,
  ) async {
    final url = ApiEndpoints.addressById(addressId);
    final response = await _dio.patch(url, data: request.toJson());
    return _parseAddress(response);
  }

  // ── DELETE /address/:id ──────────────────────────────────────────────────────
  @override
  Future<void> deleteAddress(String addressId) async {
    final url = ApiEndpoints.addressById(addressId);
    await _dio.delete(url);
  }

  // ── Helper ───────────────────────────────────────────────────────────────────
  AddressModel _parseAddress(Response response) {
    final json = response.data as Map<String, dynamic>;
    final success = json['success'] as bool? ?? false;
    if (!success) {
      throw Exception(json['message'] ?? 'Request failed');
    }
    // Support both { data: {...} } and { data: { data: {...} } }
    final raw = json['data'];
    final Map<String, dynamic> dataMap;
    if (raw is Map<String, dynamic> && raw.containsKey('data')) {
      dataMap = raw['data'] as Map<String, dynamic>;
    } else {
      dataMap = raw as Map<String, dynamic>;
    }
    return AddressModel.fromJson(dataMap);
  }
}
