import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/search_models.dart';

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
  final double maxPrice;
  final List<String> tasks;
  final List<String> specializations;

  const ServiceFiltersModel({
    required this.maxPrice,
    required this.tasks,
    required this.specializations,
  });

  factory ServiceFiltersModel.fromJson(Map<String, dynamic> json) =>
      ServiceFiltersModel(
        maxPrice: (json['max_price'] as num).toDouble(),
        tasks: List<String>.from(json['tasks'] as List),
        specializations: List<String>.from(json['specializations'] as List),
      );
}
