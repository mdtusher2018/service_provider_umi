import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/search_models.dart';

class SearchProvidersRequest {
  final int page;
  final int limit;
  final String? query;
  final String? serviceId;

  SearchProvidersRequest({
    required this.page,
    required this.limit,
    this.query,
    this.serviceId,
  });
}

class SearchProvidersResponse {
  final List<ProviderSearchResult> results;
  final PaginationMeta pagination;

  SearchProvidersResponse({required this.results, required this.pagination});
}

class ServiceFiltersModel {
  final double maxPrice;
  final List<String> tasks;
  final List<String> specializations;

  const ServiceFiltersModel({
    required this.maxPrice,
    required this.tasks,
    required this.specializations,
  });
}
