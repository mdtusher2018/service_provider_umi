// models/search/search_models.dart

// ── Request ───────────────────────────────────────────────────────────────────

import 'package:service_provider_umi/data/models/api_response.dart';

class SearchRequest {
  final String serviceType;
  final SearchSchedule schedule;
  final SearchFilters? filters;
  final int page;
  final int limit;

  const SearchRequest({
    required this.serviceType,
    required this.schedule,
    this.filters,
    this.page = 1,
    this.limit = 10,
  });

  Map<String, dynamic> toJson() => {
    'service_type': serviceType,
    'schedule': schedule.toJson(),
    if (filters != null) 'filters': filters!.toJson(),
    'pagination': {'page': page, 'limit': limit},
  };
}

class SearchSchedule {
  final String type; // one_time | recurring
  final String date;
  final int durationHours;
  final ScheduleTime time;

  const SearchSchedule({
    required this.type,
    required this.date,
    required this.durationHours,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'date': date,
    'duration_hours': durationHours,
    'time': time.toJson(),
  };
}

class ScheduleTime {
  final String mode; // exact | flexible
  final String? startTime; // exact mode
  final List<TimeSlot>? timeSlots; // flexible mode

  const ScheduleTime({required this.mode, this.startTime, this.timeSlots});

  Map<String, dynamic> toJson() => {
    'mode': mode,
    if (startTime != null) 'start_time': startTime,
    if (timeSlots != null)
      'time_slots': timeSlots!.map((s) => s.toJson()).toList(),
  };
}

class TimeSlot {
  final String startTime;
  final String endTime;

  const TimeSlot({required this.startTime, required this.endTime});

  Map<String, dynamic> toJson() => {
    'start_time': startTime,
    'end_time': endTime,
  };
}

class SearchFilters {
  final double? maximumPrice;
  final List<String>? experienceYears;
  final bool? qualifiedOnly;
  final bool? palliativeCare;
  final List<String>? tasks;
  final List<String>? specializations;
  final bool? drivingLicense;
  final bool? businessProfilesOnly;

  const SearchFilters({
    this.maximumPrice,
    this.experienceYears,
    this.qualifiedOnly,
    this.palliativeCare,
    this.tasks,
    this.specializations,
    this.drivingLicense,
    this.businessProfilesOnly,
  });

  Map<String, dynamic> toJson() => {
    if (maximumPrice != null) 'maximum_price': maximumPrice,
    if (experienceYears != null) 'experience_years': experienceYears,
    if (qualifiedOnly != null) 'qualified_only': qualifiedOnly,
    if (palliativeCare != null) 'palliative_care': palliativeCare,
    if (tasks != null) 'tasks': tasks,
    if (specializations != null) 'specializations': specializations,
    if (drivingLicense != null) 'driving_license': drivingLicense,
    if (businessProfilesOnly != null)
      'business_profiles_only': businessProfilesOnly,
  };
}

// ── Response ──────────────────────────────────────────────────────────────────

class ProviderSearchResult {
  final String id;
  final String name;
  final String avatarUrl;
  final bool verified;
  final bool isLiked;
  final double rating;
  final int reviewsCount;
  final int servicesCount;
  final double pricePerHour;
  final int repeatedCount;

  const ProviderSearchResult({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.verified,
    required this.isLiked,
    required this.rating,
    required this.reviewsCount,
    required this.servicesCount,
    required this.pricePerHour,
    required this.repeatedCount,
  });

  factory ProviderSearchResult.fromJson(Map<String, dynamic> json) =>
      ProviderSearchResult(
        id: json['id'] as String,
        name: json['name'] as String,
        avatarUrl: json['avatar_url'] as String,
        verified: json['verified'] as bool,
        isLiked: json['isLiked'] as bool,
        rating: (json['rating'] as num).toDouble(),
        reviewsCount: json['reviews_count'] as int,
        servicesCount: json['services_count'] as int,
        pricePerHour: (json['price_per_hour'] as num).toDouble(),
        repeatedCount: json['repeated_count'] as int,
      );
}

class SearchResponse {
  final List<ProviderSearchResult> results;
  final PaginationMeta pagination;

  const SearchResponse({required this.results, required this.pagination});

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
    results: (json['results'] as List)
        .map((e) => ProviderSearchResult.fromJson(e as Map<String, dynamic>))
        .toList(),
    pagination: PaginationMeta.fromJson(
      json['pagination'] as Map<String, dynamic>,
    ),
  );
}

class FiltersResponse {
  final double maxPrice;
  final List<String> tasks;
  final List<String> specializations;

  const FiltersResponse({
    required this.maxPrice,
    required this.tasks,
    required this.specializations,
  });

  factory FiltersResponse.fromJson(Map<String, dynamic> json) =>
      FiltersResponse(
        maxPrice: (json['max_price'] as num).toDouble(),
        tasks: List<String>.from(json['tasks'] as List),
        specializations: List<String>.from(json['specializations'] as List),
      );
}
