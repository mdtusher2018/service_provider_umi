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

class CreateServiceRequest {
  final String name;

  const CreateServiceRequest({required this.name});

  Map<String, dynamic> toJson() => {'name': name};
}

class UpdateServiceRequest {
  final String? name;

  const UpdateServiceRequest({this.name});

  Map<String, dynamic> toJson() => {if (name != null) 'name': name};
}

