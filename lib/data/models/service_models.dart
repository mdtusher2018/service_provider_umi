// ── Service ──────────────────────────────────────────────────────────────────

class ServiceModel {
  final String id;
  final String name;
  final String? image;
  final bool haveSubcategory;

  const ServiceModel({
    required this.id,
    required this.name,
    this.image,
    required this.haveSubcategory,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    id: json['_id'] as String? ?? json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    image: json['image'] as String?,
    haveSubcategory: json['haveSubcategory'] ?? false,
  );
}
