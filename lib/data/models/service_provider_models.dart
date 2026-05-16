import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/search_models.dart';
import 'package:service_provider_umi/data/models/category_models.dart';

// ── Search Providers Request ──────────────────────────────────────────────────

class SearchProvidersRequest {
  final int page;
  final int limit;

  final String? searchTerm;
  final String? categoryId;
  final String? experienceOptionId;
  final List<String>? otherTaskIds;

  final double? minPrice;
  final double? maxPrice;

  final String? date;
  final String? startTime;
  final String? endTime;

  final String? sort;

  const SearchProvidersRequest({
    required this.page,
    required this.limit,
    this.searchTerm,
    this.categoryId,
    this.experienceOptionId,
    this.otherTaskIds,
    this.minPrice,
    this.maxPrice,
    this.date,
    this.startTime,
    this.endTime,
    this.sort,
  });

  Map<String, dynamic> toQuery() {
    return {
      'page': page,
      'limit': limit,

      if (searchTerm != null) 'searchTerm': searchTerm,
      if (categoryId != null) 'categoryId': categoryId,
      if (experienceOptionId != null) 'experienceOptionId': experienceOptionId,

      if (otherTaskIds != null && otherTaskIds!.isNotEmpty)
        'otherTaskIds': otherTaskIds!.join(','),

      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,

      if (date != null) 'date': date,
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,

      if (sort != null) 'sort': sort,
    };
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
    return FilterOptionModel(id: json['id'] ?? "", value: json['value'] ?? "");
  }
}
