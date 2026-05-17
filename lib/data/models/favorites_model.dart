import 'package:service_provider_umi/data/models/user_models.dart';

class FavoriteModel {
  final String id;
  final String userId;
  final String serviceProviderId;
  final ServiceProviderInfo? serviceProvider;
  final UserProfile? userProfile;

  FavoriteModel({
    required this.id,
    required this.userId,
    required this.serviceProviderId,
    this.serviceProvider,
    this.userProfile,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      serviceProviderId: json['serviceProviderId'] ?? '',
      serviceProvider: json['serviceProvider'] == null
          ? null
          : ServiceProviderInfo.fromJson(json['serviceProvider']),
      userProfile: json['user'] == null
          ? null
          : UserProfile.fromJson(json['user']),
    );
  }
}
