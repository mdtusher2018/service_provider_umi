// models/search/search_models.dart

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

  factory ProviderSearchResult.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    final specialists = json['specialistsIn'] as List? ?? [];

    return ProviderSearchResult(
      id: json['userId'] ?? '',

      name: user['name'] ?? '',

      avatarUrl: user['profile'] ?? '',

      verified: false, // not in API

      isLiked: false, // not in API

      rating: 0.0, // not in API

      reviewsCount: 0, // not in API

      servicesCount: specialists.length,

      pricePerHour: (json['perHourPrice'] as num?)?.toDouble() ?? 0.0,

      repeatedCount: 0, // not in API
    );
  }
}
