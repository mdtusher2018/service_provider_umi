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

// ── FAQs ──────────────────────────────────────────────────────────────────────

class FaqItem {
  final int id;
  final String question;
  final String answer;

  const FaqItem({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory FaqItem.fromJson(Map<String, dynamic> json) => FaqItem(
    id: json['id'] as int,
    question: json['question'] as String,
    answer: json['answer'] as String,
  );
}

class FaqsResponse {
  final List<FaqItem> faqs;

  const FaqsResponse({required this.faqs});

  factory FaqsResponse.fromJson(Map<String, dynamic> json) => FaqsResponse(
    faqs: (json['faqs'] as List)
        .map((e) => FaqItem.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

// ── Static Content ────────────────────────────────────────────────────────────

enum ContentType {
  privacyPolicy('privacy-policy'),
  termsAndCondition('Terms-and-Condition'),
  aboutUs('About-Us');

  const ContentType(this.value);
  final String value;
}

class ContentResponse {
  final String content; // raw HTML

  const ContentResponse({required this.content});

  factory ContentResponse.fromJson(Map<String, dynamic> json) =>
      ContentResponse(content: json['content'] as String);
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
