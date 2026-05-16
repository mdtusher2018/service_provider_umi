// models/misc/misc_models.dart
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
