// data/models/service_models.dart

class ServiceModel {
  final int id;
  final String name;
  final String image;
  final bool? hasSubCategory;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.image,
    this.hasSubCategory,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    id: json['id'] as int,
    name: json['name'] as String,
    image: json['image'] as String,
    hasSubCategory: json['hasSubCategory'] as bool?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'hasSubCategory': hasSubCategory,
  };
}

class HomeServicesResponse {
  final List<ServiceModel> services;
  final bool hasMore;

  const HomeServicesResponse({required this.services, required this.hasMore});

  factory HomeServicesResponse.fromJson(Map<String, dynamic> json) =>
      HomeServicesResponse(
        services: (json['services'] as List)
            .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        hasMore: json['hasMore'] as bool,
      );

  Map<String, dynamic> toJson() => {
    'services': services.map((s) => s.toJson()).toList(),
    'hasMore': hasMore,
  };
}

class AllServicesResponse {
  final List<ServiceModel> services;

  const AllServicesResponse({required this.services});

  factory AllServicesResponse.fromJson(Map<String, dynamic> json) =>
      AllServicesResponse(
        services: (json['services'] as List)
            .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    'services': services.map((s) => s.toJson()).toList(),
  };
}

class SubCategoriesRequest {
  final String serviceType;

  const SubCategoriesRequest({required this.serviceType});

  Map<String, dynamic> toJson() => {'service_type': serviceType};
}
