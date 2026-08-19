// models/provider/provider_models.dart

// ── Provider Profile Response ─────────────────────────────────────────────────

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

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
  final double? hourlyRate;
  final double? minimumPrice;
  final List<String>? tasks;
  final List<String>? specializations;
  final List<String>? providerSubcategories;
  final String? experience;
  final File? drivingLicense;
  final File? businessProfilesOnly;
  final File? qualifiedOnly;
  final File? palliativeCare;
  final File? coverImage;
  final List<File> images;

  const UpdateProviderRequest({
    this.hourlyRate,
    this.minimumPrice,
    this.tasks,
    this.specializations,
    this.providerSubcategories,
    this.experience,
    this.drivingLicense,
    this.businessProfilesOnly,
    this.qualifiedOnly,
    this.palliativeCare,
    this.coverImage,
    this.images = const [],
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> dataMap = {};

    if (hourlyRate != null) dataMap['perHourPrice'] = hourlyRate;
    if (experience != null) dataMap['experienceOptionId'] = experience;
    if (specializations != null) dataMap['specialistsIn'] = specializations;
    if (providerSubcategories != null) dataMap['providerSubcategories'] = providerSubcategories;
    if (tasks != null) dataMap['othersRequiredTasks'] = tasks;

    final Map<String, dynamic> formMap = {'data': jsonEncode(dataMap)};

    // ── Single files ─────────────────────────────
    if (drivingLicense != null) {
      formMap['drivingLicense'] = await MultipartFile.fromFile(
        drivingLicense!.path,
      );
    }

    if (businessProfilesOnly != null) {
      formMap['businessProfiles'] = await MultipartFile.fromFile(
        businessProfilesOnly!.path,
      );
    }

    if (qualifiedOnly != null) {
      formMap['qualifiedCarer'] = await MultipartFile.fromFile(
        qualifiedOnly!.path,
      );
    }

    if (palliativeCare != null) {
      formMap['palliativeCare'] = await MultipartFile.fromFile(
        palliativeCare!.path,
      );
    }

    if (coverImage != null) {
      formMap['coverImage'] = await MultipartFile.fromFile(coverImage!.path);
    }

    // ── MULTIPLE IMAGES 🔥 ───────────────────────
    if (images.isNotEmpty) {
      formMap['images'] = await Future.wait(
        images.map(
          (file) => MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ),
      );
    }

    debugPrint('=== UpdateProviderRequest Payload ===');
    debugPrint('Data map: $dataMap');
    debugPrint('Cover Image path: ${coverImage?.path}');
    debugPrint('Gallery Images (${images.length}): ${images.map((e) => e.path).toList()}');
    debugPrint('=====================================');

    return FormData.fromMap(formMap);
  }
}
