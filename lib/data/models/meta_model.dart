class MetaModel {
  final int page;
  final int limit;
  final int total;

  const MetaModel({
    required this.page,
    required this.limit,
    required this.total,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
    );
  }
}
