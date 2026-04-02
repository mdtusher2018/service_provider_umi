// ── User Profile ──────────────────────────────────────────────────────────────

import 'dart:io';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profileImage;
  final String? gender;
  final String? dateOfBirth;
  final String? address;
  final String? bio;
  final String? rank;
  final bool? privacySettings;
  final bool? businessClassTrained;
  final List<int>? fleet;
  final String? agreements;
  final String? referralCode;
  final String role;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profileImage,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.bio,
    this.rank,
    this.privacySettings,
    this.businessClassTrained,
    this.fleet,
    this.agreements,
    this.referralCode,
    required this.role,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['_id'] as String? ?? json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    phoneNumber: json['phoneNumber'] as String?,
    profileImage: json['profile'] as String?,
    gender: json['gender'] as String?,
    dateOfBirth: json['dateOfBirth'] as String?,
    address: json['address'] as String?,
    bio: json['bio'] as String?,
    rank: json['rank'] as String?,
    privacySettings: json['privacySettings'] as bool?,
    businessClassTrained: json['businessClassTrained'] as bool?,
    fleet: (json['fleet'] as List?)?.map((e) => e as int).toList(),
    agreements: json['agreements'] as String?,
    referralCode: json['referralCode'] as String?,
    role: json['role'] as String? ?? 'user',
  );
}

// ── Update Profile Request ────────────────────────────────────────────────────

// ── Update Profile Request ────────────────────────────────────────────────────

class UpdateProfileRequest {
  final String? name;
  final File? profileImage;
  final String? email;
  final String? gender;
  final String? dateOfBirth;
  final String? phoneNumber;
  final String? address;
  final String? customerId;
  final bool? privacySettings;
  final bool? businessClassTrained;

  // ✅ FIX: 'bio' does not exist on the backend User model — it belongs to
  // serviceProviderInfo. Removed from toJson() so it is never sent on the
  // user update call. Ask your backend dev to accept it via serviceProviderInfo.
  final String? bio;

  final String? rank;
  final List<int>? fleet;
  final String? agreements;
  final String? referralCode;

  const UpdateProfileRequest({
    this.name,
    this.profileImage,
    this.email,
    this.gender,
    this.dateOfBirth,
    this.phoneNumber,
    this.address,
    this.customerId,
    this.privacySettings,
    this.businessClassTrained,
    this.bio,
    this.rank,
    this.fleet,
    this.agreements,
    this.referralCode,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (gender != null) 'gender': gender,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (address != null) 'address': address,
      if (customerId != null) 'customerId': customerId,
      if (privacySettings != null) 'privacySettings': privacySettings,
      if (businessClassTrained != null)
        'businessClassTrained': businessClassTrained,
      if (bio != null) 'bio': bio,
      if (rank != null) 'rank': rank,
      if (fleet != null) 'fleet': fleet,
      if (agreements != null) 'agreements': agreements,
      if (referralCode != null) 'referralCode': referralCode,
    };

    data.removeWhere(
      (key, value) => value == null || value.toString().trim().isEmpty,
    );
    return data;
  }
}
