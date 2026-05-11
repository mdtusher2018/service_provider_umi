import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/search_models.dart';
import 'package:service_provider_umi/data/models/service_models.dart';

// ── Search Providers Request ──────────────────────────────────────────────────

class SearchProvidersRequest {
  final int page;
  final int limit;
  final String? query;
  final String? serviceId;
  final String? serviceType;
  final Map<String, dynamic>? filters;

  const SearchProvidersRequest({
    required this.page,
    required this.limit,
    this.query,
    this.serviceId,
    this.serviceType,
    this.filters,
  });

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    if (query != null) 'query': query,
    if (serviceId != null) 'service_id': serviceId,
    if (serviceType != null) 'service_type': serviceType,
    if (filters != null) 'filters': filters,
  };
}

// ── Search Providers Response ─────────────────────────────────────────────────

class SearchProvidersResponse {
  final List<ProviderSearchResult> results;
  final PaginationMeta pagination;

  const SearchProvidersResponse({
    required this.results,
    required this.pagination,
  });

  factory SearchProvidersResponse.fromJson(Map<String, dynamic> json) =>
      SearchProvidersResponse(
        results: (json['results'] as List)
            .map(
              (e) => ProviderSearchResult.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        pagination: PaginationMeta.fromJson(
          json['pagination'] as Map<String, dynamic>,
        ),
      );
}

// ── Service Filters Model ─────────────────────────────────────────────────────

class ServiceFiltersModel {
  final List<FilterOptionModel> experienceOptions;
  final List<FilterOptionModel> othersTaskOptions;
  final List<ServiceModel> category;

  const ServiceFiltersModel({
    required this.experienceOptions,
    required this.othersTaskOptions,
    required this.category,
  });
}

class FilterOptionModel {
  final String id;
  final String value;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FilterOptionModel({
    required this.id,
    required this.value,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FilterOptionModel.fromJson(Map<String, dynamic> json) {
    return FilterOptionModel(
      id: json['id'] as String,
      value: json['value'] as String,
      isDeleted: json['isDeleted'] as bool,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'value': value,
    'isDeleted': isDeleted,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
