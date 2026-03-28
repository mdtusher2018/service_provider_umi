// ── Service ──────────────────────────────────────────────────────────────────

class ServiceModel {
  final String id;
  final String name;
  final String? image;

  const ServiceModel({
    required this.id,
    required this.name,
    this.image,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: json['_id'] as String? ?? json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        image: json['image'] as String?,
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

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
      };
}

class ContentItem {
  final String id;
  final String type;
  final String content;

  const ContentItem({
    required this.id,
    required this.type,
    required this.content,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) => ContentItem(
        id: json['_id'] as String? ?? json['id'] as String? ?? '',
        type: json['type'] as String? ?? '',
        content: json['content'] as String? ?? '',
      );
}
