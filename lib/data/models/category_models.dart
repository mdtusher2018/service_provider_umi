// ── Service ──────────────────────────────────────────────────────────────────

class CategoryModel {
  final String id;
  final String name;
  final String? image;
  final bool haveSubcategory;

  const CategoryModel({
    required this.id,
    required this.name,
    this.image,
    required this.haveSubcategory,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['_id'] as String? ?? json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    image: json['image'] as String?,
    haveSubcategory: json['haveSubcategory'] ?? false,
  );
}
