// ── User Profile ──────────────────────────────────────────────────────────────

import 'dart:io';

import 'package:service_provider_umi/data/models/mock_service_provider_models.dart';
import 'package:service_provider_umi/data/models/service_models.dart';

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
  final ServiceProviderInfo? serviceProviderInfo;

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
    required this.serviceProviderInfo,
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
    serviceProviderInfo: (json['serviceProviderInfo'] == null)
        ? null
        : ServiceProviderInfo.fromJson(json['serviceProviderInfo']),
  );
}

class ServiceProviderInfo {
  final String userId;
  final String? palliativeCare;
  final String? coverImage;
  final String? drivingLicense;
  final String? businessProfiles;
  final String? documents;
  final double perHourPrice;
  final String? experienceOptionId;
  final String? qualifiedCarer;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final List<dynamic> images;
  final List<FilterOptionModel> otherTasks;
  final List<ServiceModel> specialists;
  final FilterOptionModel? experience;

  const ServiceProviderInfo({
    required this.userId,
    this.palliativeCare,
    this.coverImage,
    this.drivingLicense,
    this.businessProfiles,
    this.documents,
    required this.perHourPrice,
    this.experienceOptionId,
    this.qualifiedCarer,
    this.createdAt,
    this.updatedAt,
    required this.images,
    required this.otherTasks,
    required this.specialists,
    this.experience,
  });

  factory ServiceProviderInfo.fromJson(Map<String, dynamic> json) {
    return ServiceProviderInfo(
      userId: json['userId'] ?? '',
      palliativeCare: json['palliativeCare'],
      coverImage: json['coverImage'],
      drivingLicense: json['drivingLicense'],
      businessProfiles: json['businessProfiles'],
      documents: json['documents'],
      perHourPrice: (json['perHourPrice'] as num?)?.toDouble() ?? 0.0,
      experienceOptionId: json['experienceOptionId'],
      qualifiedCarer: json['qualifiedCarer'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,

      images:
          (json['images'] as List?)?.map((e) => e['url'] ?? "").toList() ?? [],

      otherTasks:
          (json['othersRequiredTasks'] as List?)
              ?.map((e) => FilterOptionModel.fromJson(e))
              .toList() ??
          [],

      specialists:
          (json['specialistsIn'] as List?)
              ?.map((e) => ServiceModel.fromJson(e['category'] ?? {}))
              .toList() ??
          [],

      experience: json['experience'] != null
          ? FilterOptionModel.fromJson(json['experience'])
          : null,
    );
  }
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
