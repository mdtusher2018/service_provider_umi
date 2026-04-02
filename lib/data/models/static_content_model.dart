class StaticContentItem {
  final String? id;
  final String? termsAndCondition;
  final String? privacyPolicy;
  final String? refundPolicy;
  final String? shippingPolicy;
  final String? aboutUs;
  final String? location;
  final String? copyRight;
  final String? footerText;
  final String? createdAt;
  final String? updatedAt;

  const StaticContentItem({
    this.id,
    this.termsAndCondition,
    this.privacyPolicy,
    this.refundPolicy,
    this.shippingPolicy,
    this.aboutUs,
    this.location,
    this.copyRight,
    this.footerText,
    this.createdAt,
    this.updatedAt,
  });

  factory StaticContentItem.fromJson(Map<String, dynamic> json) {
    return StaticContentItem(
      id: json['id'] as String?,
      termsAndCondition: json['termsAndCondition'] as String?,
      privacyPolicy: json['privacyPolicy'] as String?,
      refundPolicy: json['refundPolicy'] as String?,
      shippingPolicy: json['shippingPolicy'] as String?,
      aboutUs: json['aboutUs'] as String?,
      location: json['location'] as String?,
      copyRight: json['copyRight'] as String?,
      footerText: json['footerText'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}
