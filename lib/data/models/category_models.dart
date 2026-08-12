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

class SubCategoryModel {
  final String id;
  final String name;
  final String categoryId;
  final String? image;
  final bool isDeleted;
  final CategoryModel? category;

  const SubCategoryModel({
    required this.id,
    required this.name,
    required this.categoryId,
    this.image,
    required this.isDeleted,
    this.category,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
    id: json['_id'] as String? ?? json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    categoryId: json['categoryId'] as String? ?? '',
    image: json['image'] as String?,
    isDeleted: json['isDeleted'] ?? false,
    category: json['category'] != null ? CategoryModel.fromJson(json['category']) : null,
  );
}
