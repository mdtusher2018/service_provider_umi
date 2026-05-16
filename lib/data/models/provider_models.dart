// models/provider/provider_models.dart

// ── Provider Profile Response ─────────────────────────────────────────────────

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class RatingBreakdown {
  final double service;
  final double punctuality;
  final double kindness;
  final double valueForMoney;
  final double professionalism;
  const RatingBreakdown({
    required this.service,
    required this.punctuality,
    required this.kindness,
    required this.valueForMoney,
    required this.professionalism,
  });
  factory RatingBreakdown.fromJson(Map<String, dynamic> json) =>
      RatingBreakdown(
        service: (json['service'] as num).toDouble(),
        punctuality: (json['punctuality'] as num).toDouble(),
        kindness: (json['kindness'] as num).toDouble(),
        valueForMoney: (json['value_for_money'] as num).toDouble(),
        professionalism: (json['professionalism'] as num).toDouble(),
      );
}


class ProviderComment {
  final String id;
  final String userName;
  final String userImage;
  final String userId;
  final bool userVerified;
  final double rating;
  final String comment;
  final DateTime? createdAt;

  const ProviderComment({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.userId,
    required this.userVerified,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  factory ProviderComment.fromJson(Map<String, dynamic> json) {
    final author = json['author'] ?? {};

    return ProviderComment(
      id: json['id'] ?? '',

      // 👇 reviewer (author)
      userName: author['name'] ?? '',
      userImage: author['profile'] ?? '',
      userId: author['id'] ?? '',

      // ❗ your API doesn't provide verified → fallback false
      userVerified: author['verified'] ?? false,

      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,

      // 👇 API uses "review"
      comment: json['review'] ?? '',

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}

class UpdateProviderRequest {
  final String? serviceId;
  final double? hourlyRate;
  final double? minimumPrice;
  final List<String>? tasks;
  final List<String>? specializations;
  final String? experience;
  final File? drivingLicense;
  final File? businessProfilesOnly;
  final File? qualifiedOnly;
  final File? palliativeCare;

  const UpdateProviderRequest({
    this.serviceId,
    this.hourlyRate,
    this.minimumPrice,
    this.tasks,
    this.specializations,
    this.experience,
    this.drivingLicense,
    this.businessProfilesOnly,
    this.qualifiedOnly,
    this.palliativeCare,
  });

  Future<FormData> toFormData() async {
    // ── JSON blob that goes into the "data" key ──────────────
    final Map<String, dynamic> dataMap = {};

    if (hourlyRate != null) dataMap['perHourPrice'] = hourlyRate;
    if (experience != null) dataMap['experienceOptionId'] = experience;
    if (specializations != null) dataMap['specialistsIn'] = specializations;
    if (tasks != null) dataMap['othersRequiredTasks'] = tasks;

    // ── File fields ──────────────────────────────────────────
    Future<MapEntry<String, MultipartFile>> toFile(
      String key,
      File file,
    ) async => MapEntry(
      key,
      await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    );

    final fileFields = <MapEntry<String, MultipartFile>>[];

    if (drivingLicense != null) {
      fileFields.add(await toFile('drivingLicense', drivingLicense!));
    }
    if (businessProfilesOnly != null) {
      fileFields.add(await toFile('businessProfiles', businessProfilesOnly!));
    }
    if (qualifiedOnly != null) {
      fileFields.add(await toFile('qualifiedCarer', qualifiedOnly!));
    }
    if (palliativeCare != null) {
      fileFields.add(await toFile('palliativeCare', palliativeCare!));
    }

    return FormData.fromMap({
      'data': jsonEncode(dataMap), // ✅ JSON string under "data" key
      for (final e in fileFields) e.key: e.value,
    });
  }
}
