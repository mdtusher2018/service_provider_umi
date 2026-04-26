// models/provider/provider_models.dart

// ── Provider Profile Response ─────────────────────────────────────────────────

class ProviderProfile {
  final String id;
  final String name;
  final String serviceTitle;
  final String profileImage;
  final bool verified;
  final double hourlyRate;
  final String about;
  final ProviderRating rating;
  final List<String> gallery;
  final List<ProviderQuestion> questions;
  final List<ProviderComment> comments;
  final ProviderAvailability availability;

  const ProviderProfile({
    required this.id,
    required this.name,
    required this.serviceTitle,
    required this.profileImage,
    required this.verified,
    required this.hourlyRate,
    required this.about,
    required this.rating,
    required this.gallery,
    required this.questions,
    required this.comments,
    required this.availability,
  });

  factory ProviderProfile.fromJson(Map<String, dynamic> json) =>
      ProviderProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        serviceTitle: json['service_title'] as String,
        profileImage: json['profile_image'] as String,
        verified: json['verified'] as bool,
        hourlyRate: (json['hourly_rate'] as num).toDouble(),
        about: json['about'] as String,
        rating: ProviderRating.fromJson(json['rating'] as Map<String, dynamic>),
        gallery: List<String>.from(json['gallery'] as List),
        questions: (json['questions'] as List)
            .map((e) => ProviderQuestion.fromJson(e as Map<String, dynamic>))
            .toList(),
        comments: (json['comments'] as List)
            .map((e) => ProviderComment.fromJson(e as Map<String, dynamic>))
            .toList(),
        availability: ProviderAvailability.fromJson(
          json['availability'] as Map<String, dynamic>,
        ),
      );
}

class ProviderRating {
  final double average;
  final int totalReviews;
  final RatingBreakdown breakdown;

  const ProviderRating({
    required this.average,
    required this.totalReviews,
    required this.breakdown,
  });

  factory ProviderRating.fromJson(Map<String, dynamic> json) => ProviderRating(
    average: (json['average'] as num).toDouble(),
    totalReviews: json['total_reviews'] as int,
    breakdown: RatingBreakdown.fromJson(
      json['breakdown'] as Map<String, dynamic>,
    ),
  );
}

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
  final bool userVerified;
  final num rating;
  final String comment;
  final String createdAt;

  const ProviderComment({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.userVerified,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ProviderComment.fromJson(Map<String, dynamic> json) =>
      ProviderComment(
        id: json['id'] as String,
        userName: json['user_name'] as String,
        userImage: json['user_image'] as String,
        userVerified: json['user_verified'] as bool,
        rating: json['rating'] as int,
        comment: json['comment'] as String,
        createdAt: json['created_at'] as String,
      );
}

class ProviderAvailability {
  final Map<String, List<AvailabilitySlot>> days;
  final int slotIntervalMinutes;

  const ProviderAvailability({
    required this.days,
    required this.slotIntervalMinutes,
  });

  factory ProviderAvailability.fromJson(Map<String, dynamic> json) {
    const dayNames = [
      'saturday',
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
    ];
    final days = <String, List<AvailabilitySlot>>{};
    for (final day in dayNames) {
      if (json[day] != null) {
        days[day] = (json[day] as List)
            .map((e) => AvailabilitySlot.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return ProviderAvailability(
      days: days,
      slotIntervalMinutes: json['slot_interval_minutes'] as int,
    );
  }
}

class AvailabilitySlot {
  final String start;
  final int maxDurationMinutes;

  const AvailabilitySlot({
    required this.start,
    required this.maxDurationMinutes,
  });

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) =>
      AvailabilitySlot(
        start: json['start'] as String,
        maxDurationMinutes: json['max_duration_minutes'] as int,
      );
}

// ── Create / Update Provider Request ─────────────────────────────────────────

class DayAvailability {
  final bool isAvailable;
  final String? start;
  final String? end;

  const DayAvailability({required this.isAvailable, this.start, this.end});

  Map<String, dynamic> toJson() => {
    'is_available': isAvailable,
    if (start != null) 'start': start,
    if (end != null) 'end': end,
  };
}

class CreateProviderRequest {
  final Map<String, DayAvailability> availability;
  final String serviceId;
  final double hourlyRate;
  final List<String> tasks;
  final List<String> specializations;
  final String experience;
  final bool drivingLicense;
  final bool businessProfilesOnly;
  final bool qualifiedOnly;
  final bool palliativeCare;
  final String phoneNumber;
  // image & service_provider_image are sent as multipart files

  const CreateProviderRequest({
    required this.availability,
    required this.serviceId,
    required this.hourlyRate,
    required this.tasks,
    required this.specializations,
    required this.experience,
    required this.drivingLicense,
    required this.businessProfilesOnly,
    required this.qualifiedOnly,
    required this.palliativeCare,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
    'availability': availability.map((k, v) => MapEntry(k, v.toJson())),
    'service_id': serviceId,
    'hourly_rate': hourlyRate,
    'tasks': tasks,
    'specializations': specializations,
    'experience': experience,
    'driving_license': drivingLicense,
    'business_profiles_only': businessProfilesOnly,
    'qualified_only': qualifiedOnly,
    'palliative_care': palliativeCare,
    'phone_number': phoneNumber,
  };
}

class UpdateProviderRequest {
  final Map<String, DayAvailability>? availability;
  final String? serviceId;
  final double? hourlyRate;
  final double? minimumPrice;
  final List<String>? tasks;
  final List<String>? specializations;
  final String? experience;
  final bool? drivingLicense;
  final bool? businessProfilesOnly;
  final bool? qualifiedOnly;
  final bool? palliativeCare;

  const UpdateProviderRequest({
    this.availability,
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

  Map<String, dynamic> toJson() => {
    if (availability != null)
      'availability': availability!.map((k, v) => MapEntry(k, v.toJson())),
    if (serviceId != null) 'service_id': serviceId,
    if (hourlyRate != null) 'hourly_rate': hourlyRate,
    if (minimumPrice != null) 'minimum_price': minimumPrice,
    if (tasks != null) 'tasks': tasks,
    if (specializations != null) 'specializations': specializations,
    if (experience != null) 'experience': experience,
    if (drivingLicense != null) 'driving_license': drivingLicense,
    if (businessProfilesOnly != null)
      'business_profiles_only': businessProfilesOnly,
    if (qualifiedOnly != null) 'qualified_only': qualifiedOnly,
    if (palliativeCare != null) 'palliative_care': palliativeCare,
  };
}

// ── Provider OTP Response ─────────────────────────────────────────────────────

class CreateProviderResponse {
  final String token;
  final bool accessToken;

  const CreateProviderResponse({
    required this.token,
    required this.accessToken,
  });

  factory CreateProviderResponse.fromJson(Map<String, dynamic> json) =>
      CreateProviderResponse(
        token: json['token'] as String,
        accessToken: json['accessToken'] as bool,
      );
}

// ── Review ────────────────────────────────────────────────────────────────────

class ReviewRequest {
  final RatingBreakdown rating;
  final String comment;

  const ReviewRequest({required this.rating, required this.comment});

  Map<String, dynamic> toJson() => {
    'ratting': {
      'service': rating.service,
      'punctuality': rating.punctuality,
      'kindness': rating.kindness,
      'value_for_money': rating.valueForMoney,
      'professionalism': rating.professionalism,
    },
    'comment': comment,
  };
}

class ReviewItem {
  final String name;
  final int rating;
  final String comment;
  final String profileImage;

  const ReviewItem({
    required this.name,
    required this.rating,
    required this.comment,
    required this.profileImage,
  });

  factory ReviewItem.fromJson(Map<String, dynamic> json) => ReviewItem(
    name: json['name'] as String,
    rating: json['rating'] as int,
    comment: json['comment'] as String,
    profileImage: json['profileImage'] as String,
  );
}

class ReviewsResponse {
  final List<ReviewItem> reviews;

  const ReviewsResponse({required this.reviews});

  factory ReviewsResponse.fromJson(Map<String, dynamic> json) =>
      ReviewsResponse(
        reviews: (json['reviews'] as List)
            .map((e) => ReviewItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
