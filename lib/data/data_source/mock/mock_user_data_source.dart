import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_provider_umi/data/data_source/remote/user_remote_data_source.dart';
import 'package:service_provider_umi/data/models/address_model.dart';
import 'package:service_provider_umi/data/models/search_models.dart';
import 'package:service_provider_umi/data/models/user_models.dart';
import 'package:service_provider_umi/data/models/auth_models.dart';

class MockUserDataSource implements UserRemoteDataSource {
  final UserProfile _profile = const UserProfile(
    id: 'user_123',
    name: 'Mr. Raju',
    email: 'raju@example.com',
    phoneNumber: '+8801840-560614',
    profileImage: 'https://i.pravatar.cc/300?img=3',
    role: 'User',
    bio: 'I love getting things done around the house.',
    address: '301 Parker Rd, Dhaka, Bangladesh',
  );

  final List<AddressModel> _addresses = [
    const AddressModel(
      id: '1',
      address: '1901 Thorner Rd, Allentown, New Mexico 31134',
      lat: 45.5,
      lng: 90.5,
    ),
    const AddressModel(
      id: '1',
      address: '1901 Thorner Rd, Allentown, New Mexico 31134',
      lat: 45.5,
      lng: 90.5,
    ),
  ];

  final List<ProviderSearchResult> _favorites = [
    ProviderSearchResult(
      id: 'provider_002',
      name: 'Sarah Ahmed',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      verified: true,
      isLiked: true,
      rating: 4.8,
      reviewsCount: 27,
      servicesCount: 2,
      pricePerHour: 18.0,
      repeatedCount: 9,
    ),
    ProviderSearchResult(
      id: 'provider_004',
      name: 'Fatima Begum',
      avatarUrl: 'https://i.pravatar.cc/150?img=9',
      verified: true,
      isLiked: true,
      rating: 4.9,
      reviewsCount: 41,
      servicesCount: 4,
      pricePerHour: 20.0,
      repeatedCount: 15,
    ),
  ];

  Future<List<AddressModel>> getSavedAddresses() async {
    await _delay();
    return List.unmodifiable(_addresses);
  }

  Future<void> addAddress({
    required String name,
    required String address,
    required LatLng coordinates,
  }) async {
    await _delay();
    _addresses.add(
      AddressModel(
        id: 'addr_${_addresses.length + 1}',

        address: address,
        lat: coordinates.latitude,
        lng: coordinates.longitude,
      ),
    );
  }

  Future<void> changePassword(ChangePasswordRequest request) async {
    await _delay();
    if (request.oldPassword == 'wrong') {
      throw Exception('Current password is incorrect.');
    }
  }

  Future<List<ProviderSearchResult>> getFavorites({
    int page = 1,
    int limit = 10,
  }) async {
    await _delay();
    final total = _favorites.length;
    final start = ((page - 1) * limit).clamp(0, total);
    final end = (start + limit).clamp(0, total);
    return _favorites.sublist(start, end);
  }

  Future<void> _delay({int ms = 500}) =>
      Future.delayed(Duration(milliseconds: ms));

  @override
  Future<void> deleteMyAccount() async {}

  @override
  Future<UserProfile> getMyProfile() async {
    await _delay();
    return _profile;
  }

  @override
  Future<UserProfile> getUserById(String id) async {
    await _delay();
    return _profile;
  }

  @override
  Future<UserProfile> updateMyProfile(UpdateProfileRequest data) async {
    await _delay();
    return _profile;
  }
}
