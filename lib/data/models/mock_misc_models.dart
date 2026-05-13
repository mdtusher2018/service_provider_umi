// models/misc/misc_models.dart

// ── Notifications ─────────────────────────────────────────────────────────────

import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/search_models.dart';

// ── Favorites ─────────────────────────────────────────────────────────────────

class FavoritesResponse {
  final List<ProviderSearchResult> results;
  final PaginationMeta pagination;

  const FavoritesResponse({required this.results, required this.pagination});

  factory FavoritesResponse.fromJson(Map<String, dynamic> json) =>
      FavoritesResponse(
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

// ── Support ───────────────────────────────────────────────────────────────────

class SupportResponse {
  final String supportId;
  final String phoneNumber;

  const SupportResponse({required this.supportId, required this.phoneNumber});

  factory SupportResponse.fromJson(Map<String, dynamic> json) =>
      SupportResponse(
        supportId: json['supportId'] as String,
        phoneNumber: json['phoneNumber'] as String,
      );
}
