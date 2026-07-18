import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/search_models.dart';
import 'package:service_provider_umi/data/models/category_models.dart';

// ── Search Providers Request ──────────────────────────────────────────────────
class SearchProvidersRequest {
  final int page;
  final int limit;

  // ── Scheduling ──────────────────────────────────────────
  final String? bookingType; // "one_time" | "weekly"
  final String? date; // "2025-01-13"  (one_time only)
  final String? days; // "Mon,Wed,Fri" (weekly only)
  final String? startTimeType; // "flexible" | "exact"
  final String? flexibleSlot; // "9-12"        (flexible only)
  final String? startTime; // "14:00"       (exact only)
  final String? endTime; // "16:00"       (exact only)
  final String? duration; // minutes as string e.g. "120"

  // ── Text / Category ─────────────────────────────────────
  final String? searchTerm;
  final String? categoryId;
  final String? categoryIds; // comma-separated

  // ── Filter options ───────────────────────────────────────
  final String? experienceOptionId;
  final String? otherTaskIds; // comma-separated

  final double? minPrice;
  final double? maxPrice;

  final bool? qualifiedCarer;
  final bool? palliativeCare;
  final bool? drivingLicense;
  final bool? businessProfiles;

  // ── Sorting ──────────────────────────────────────────────
  final String? sort;

  const SearchProvidersRequest({
    required this.page,
    required this.limit,
    this.bookingType,
    this.date,
    this.days,
    this.startTimeType,
    this.flexibleSlot,
    this.startTime,
    this.endTime,
    this.duration,
    this.searchTerm,
    this.categoryId,
    this.categoryIds,
    this.experienceOptionId,
    this.otherTaskIds,
    this.minPrice,
    this.maxPrice,
    this.qualifiedCarer,
    this.palliativeCare,
    this.drivingLicense,
    this.businessProfiles,
    this.sort,
  });

  /// Build from the raw GoRouter query-param map (all values are strings).
  factory SearchProvidersRequest.fromQueryParams(
    Map<String, String> params, {
    int page = 1,
    int limit = 10,
  }) {
    double? _d(String key) {
      final v = params[key];
      return v != null ? double.tryParse(v) : null;
    }

    bool? _b(String key) {
      final v = params[key];
      return v != null ? v == 'true' : null;
    }

    return SearchProvidersRequest(
      page: int.tryParse(params['page'] ?? '') ?? page,
      limit: int.tryParse(params['limit'] ?? '') ?? limit,
      bookingType: params['bookingType'],
      date: params['date'],
      days: params['days'],
      startTimeType: params['startTimeType'],
      flexibleSlot: params['flexibleSlot'],
      startTime: params['startTime'],
      endTime: params['endTime'],
      duration: params['duration'],
      searchTerm: params['searchTerm'],
      categoryId: params['categoryId'],
      categoryIds: params['categoryIds'],
      experienceOptionId: params['experienceOptionId'],
      otherTaskIds: params['otherTaskIds'],
      minPrice: _d('minPrice'),
      maxPrice: _d('maxPrice'),
      qualifiedCarer: _b('qualifiedCarer'),
      palliativeCare: _b('palliativeCare'),
      drivingLicense: _b('drivingLicense'),
      businessProfiles: _b('businessProfiles'),
      sort: params['sort'],
    );
  }

  /// Merge this request with new filter values.
  /// Filter values override scheduling/search values only where explicitly
  /// provided; everything else is kept from the original.
  SearchProvidersRequest mergeWith({
    String? searchTerm,
    String? categoryId,
    String? categoryIds,
    String? experienceOptionId,
    String? otherTaskIds,
    double? minPrice,
    double? maxPrice,
    bool? qualifiedCarer,
    bool? palliativeCare,
    bool? drivingLicense,
    bool? businessProfiles,
    String? sort,
    int? page,
  }) {
    return SearchProvidersRequest(
      // scheduling params are preserved as-is
      page: page ?? this.page,
      limit: limit,
      bookingType: bookingType,
      date: date,
      days: days,
      startTimeType: startTimeType,
      flexibleSlot: flexibleSlot,
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      // search / filter params: new value wins if provided
      searchTerm: searchTerm ?? this.searchTerm,
      categoryId: categoryId ?? this.categoryId,
      categoryIds: categoryIds ?? this.categoryIds,
      experienceOptionId: experienceOptionId ?? this.experienceOptionId,
      otherTaskIds: otherTaskIds ?? this.otherTaskIds,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      qualifiedCarer: qualifiedCarer ?? this.qualifiedCarer,
      palliativeCare: palliativeCare ?? this.palliativeCare,
      drivingLicense: drivingLicense ?? this.drivingLicense,
      businessProfiles: businessProfiles ?? this.businessProfiles,
      sort: sort ?? this.sort,
    );
  }

  /// Serialise to HTTP query params map.
  Map<String, dynamic> toQuery() {
    final m = <String, dynamic>{'page': page, 'limit': limit};

    void s(String k, String? v) {
      if (v != null && v.isNotEmpty) m[k] = v;
    }

    void d(String k, double? v) {
      if (v != null) m[k] = v;
    }

    void b(String k, bool? v) {
      if (v == true) m[k] = 'true';
    }

    s('bookingType', bookingType);
    s('date', date);
    s('days', days);
    s('startTimeType', startTimeType);
    s('flexibleSlot', flexibleSlot);
    s('startTime', startTime);
    s('endTime', endTime);
    s('duration', duration);
    s('searchTerm', searchTerm);
    s('categoryId', categoryId);
    s('categoryIds', categoryIds);
    s('experienceOptionId', experienceOptionId);
    s('otherTaskIds', otherTaskIds);
    d('minPrice', minPrice);
    d('maxPrice', maxPrice);
    b('qualifiedCarer', qualifiedCarer);
    b('palliativeCare', palliativeCare);
    b('drivingLicense', drivingLicense);
    b('businessProfiles', businessProfiles);
    s('sort', sort);

    return m;
  }

  /// Convert back to a plain string map for GoRouter query params.
  Map<String, String> toQueryParams() {
    return toQuery().map((k, v) => MapEntry(k, v.toString()));
  }
}

// ── Search Providers Response ─────────────────────────────────────────────────

class SearchProvidersResponse {
  final List<ProviderSearchResult> results;
  final PaginationMeta pagination;

  const SearchProvidersResponse({
    required this.results,
    required this.pagination,
  });

  factory SearchProvidersResponse.fromJson(
    Map<String, dynamic> json,
  ) => SearchProvidersResponse(
    results: (json['data'] as List)
        .map((e) => ProviderSearchResult.fromJson(e as Map<String, dynamic>))
        .toList(),
    pagination: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
  );
}

// ── Service Filters Model ─────────────────────────────────────────────────────

class ServiceFiltersModel {
  final List<FilterOptionModel> experienceOptions;
  final List<FilterOptionModel> othersTaskOptions;
  final List<CategoryModel> category;

  const ServiceFiltersModel({
    required this.experienceOptions,
    required this.othersTaskOptions,
    required this.category,
  });
}

class FilterOptionModel {
  final String id;
  final String value;

  const FilterOptionModel({required this.id, required this.value});

  factory FilterOptionModel.fromJson(Map<String, dynamic> json) {
    return FilterOptionModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? "",
      value: json['value'] as String? ?? "",
    );
  }
}
