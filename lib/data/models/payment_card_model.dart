/// payment_card_model.dart
class PaymentCardModel {
  final String id;
  final String type;
  final String displayBrand;
  final String last4digit;
  final int expMonth;
  final int expYear;
  final String funding;
  final String country;
  final String fingerprint;

  PaymentCardModel({
    required this.id,
    required this.type,
    required this.displayBrand,
    required this.last4digit,
    required this.expMonth,
    required this.expYear,
    required this.funding,
    required this.country,
    required this.fingerprint,
  });

  factory PaymentCardModel.fromJson(Map<String, dynamic> json) {
    return PaymentCardModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      displayBrand: json['display_brand'] ?? '',
      last4digit: json['last4digit'] ?? '',
      expMonth: json['exp_month'] ?? 0,
      expYear: json['exp_year'] ?? 0,
      funding: json['funding'] ?? '',
      country: json['country'] ?? '',
      fingerprint: json['fingerprint'] ?? '',
    );
  }
}

/// =========================================================
/// ADD PAYMENT CARD MODEL
/// =========================================================

class AddCardLinkResponse {
  final String url;

  AddCardLinkResponse({required this.url});

  factory AddCardLinkResponse.fromJson(Map<String, dynamic> json) {
    return AddCardLinkResponse(url: json['url'] ?? '');
  }
}
