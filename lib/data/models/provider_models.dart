// models/provider/provider_models.dart

// ── Provider Profile Response ─────────────────────────────────────────────────

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

// class ProviderProfile {
//   final String id;
//   final String name;
//   final String serviceTitle;
//   final String profileImage;
//   final bool verified;
//   final double hourlyRate;
//   final String about;
//   final ProviderRating? rating;
//   final List<String> gallery;
//   final List<ProviderQuestion> questions;
//   final List<ProviderComment> comments;
//   final ProviderAvailability? availability;
//   const ProviderProfile({
//     required this.id,
//     required this.name,
//     required this.serviceTitle,
//     required this.profileImage,
//     required this.verified,
//     required this.hourlyRate,
//     required this.about,
//     this.rating,
//     required this.gallery,
//     required this.questions,
//     required this.comments,
//     this.availability,
//   });
//   factory ProviderProfile.fromJson(
//     Map<String, dynamic> json,
//   ) => ProviderProfile(
//     id: json['id'] as String? ?? '',
//     name: json['name'] as String? ?? '',
//     serviceTitle: json['service_title'] as String? ?? '',
//     profileImage: json['profile_image'] as String? ?? '',
//     verified: json['verified'] as bool? ?? false,
//     hourlyRate: (json['hourly_rate'] as num?)?.toDouble() ?? 0.0,
//     about: json['about'] as String? ?? '',
//     rating: json['rating'] != null
//         ? ProviderRating.fromJson(json['rating'] as Map<String, dynamic>)
//         : null,
//     gallery:
//         (json['gallery'] as List?)?.map((e) => e as String? ?? '').toList() ??
//         [],
//     questions:
//         (json['questions'] as List?)
//             ?.map((e) => ProviderQuestion.fromJson(e as Map<String, dynamic>))
//             .toList() ??
//         [],
//     comments:
//         (json['comments'] as List?)
//             ?.map((e) => ProviderComment.fromJson(e as Map<String, dynamic>))
//             .toList() ??
//         [],
//     availability: json['availability'] != null
//         ? ProviderAvailability.fromJson(
//             json['availability'] as Map<String, dynamic>,
//           )
//         : null,
//   );
// }
// class ProviderRating {
//   final double average;
//   final int totalReviews;
//   final RatingBreakdown breakdown;
//   const ProviderRating({
//     required this.average,
//     required this.totalReviews,
//     required this.breakdown,
//   });
//   factory ProviderRating.fromJson(Map<String, dynamic> json) => ProviderRating(
//     average: (json['average'] as num).toDouble(),
//     totalReviews: json['total_reviews'] as int,
//     breakdown: RatingBreakdown.fromJson(
//       json['breakdown'] as Map<String, dynamic>,
//     ),
//   );
// }
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

class ProviderQuestion {
  final String question;
  final String answer;
  const ProviderQuestion({required this.question, required this.answer});
  factory ProviderQuestion.fromJson(Map<String, dynamic> json) =>
      ProviderQuestion(
        question: json['question'] as String,
        answer: json['answer'] as String,
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
// class ProviderAvailability {
//   final Map<String, List<AvailabilitySlot>> days;
//   final int slotIntervalMinutes;
//   const ProviderAvailability({
//     required this.days,
//     required this.slotIntervalMinutes,
//   });
//   factory ProviderAvailability.fromJson(Map<String, dynamic> json) {
//     const dayNames = [
//       'saturday',
//       'sunday',
//       'monday',
//       'tuesday',
//       'wednesday',
//       'thursday',
//       'friday',
//     ];
//     final days = <String, List<AvailabilitySlot>>{};
//     for (final day in dayNames) {
//       if (json[day] != null) {
//         days[day] = (json[day] as List)
//             .map((e) => AvailabilitySlot.fromJson(e as Map<String, dynamic>))
//             .toList();
//       }
//     }
//     return ProviderAvailability(
//       days: days,
//       slotIntervalMinutes: json['slot_interval_minutes'] as int,
//     );
//   }
// }
// class AvailabilitySlot {
//   final String start;
//   final int maxDurationMinutes;
//   const AvailabilitySlot({
//     required this.start,
//     required this.maxDurationMinutes,
//   });
//   factory AvailabilitySlot.fromJson(Map<String, dynamic> json) =>
//       AvailabilitySlot(
//         start: json['start'] as String,
//         maxDurationMinutes: json['max_duration_minutes'] as int,
//       );
// }

// ── Create / Update Provider Request ─────────────────────────────────────────

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
