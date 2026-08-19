import 'package:service_provider_umi/data/models/user_models.dart';

class FavoriteModel {
  final String id;
  final String userId;
  final String serviceProviderId;
  final ServiceProviderInfo? serviceProvider;
  final UserProfile? userProfile;
  final UserProfile? serviceProviderUser;
  final DateTime? createdAt;

  FavoriteModel({
    required this.id,
    required this.userId,
    required this.serviceProviderId,
    this.serviceProvider,
    this.userProfile,
    this.serviceProviderUser,
    this.createdAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      serviceProviderId: json['serviceProviderId'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : DateTime.now(),
      serviceProvider: json['serviceProvider'] == null
          ? null
          : ServiceProviderInfo.fromJson(json['serviceProvider']),
      userProfile: json['user'] == null
          ? null
          : UserProfile.fromJson(json['user']),
      serviceProviderUser: (json['serviceProvider'] != null && json['serviceProvider']['userId'] != null && json['serviceProvider']['userId'] is Map<String, dynamic>)
          ? UserProfile.fromJson(json['serviceProvider']['userId']) 
          : (json['serviceProvider'] != null && json['serviceProvider']['user'] != null)
              ? UserProfile.fromJson(json['serviceProvider']['user'])
              : null,
    );
  }
}
