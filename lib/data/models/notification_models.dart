// ── Notification ──────────────────────────────────────────────────────────────

import 'package:service_provider_umi/shared/enums/all_enums.dart';

class NotificationItem {
  final String? id;
  final String? receiverId;
  final String? bookingId;
  final String message;
  final String description;
  final bool? isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final AlertType type;
  final NotificationUser? user;

  const NotificationItem({
    this.id,
    this.receiverId,
    this.bookingId,
    required this.message,
    required this.description,
    required this.type,
    this.isRead,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as String?,
      receiverId: json['receiverId'] as String?,
      bookingId: json['bookingId'] as String?,
      message: json['message'] ?? "N/A",
      description: json['description'] ?? "N/A",

      isRead: json['isRead'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      user: json['user'] != null
          ? NotificationUser.fromJson(json['user'])
          : null,

      /// ✅ FIXED ENUM PARSING
      type: AlertType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AlertType.unknown,
      ),
    );
  }
}

class NotificationUser {
  final String? id;
  final String? name;
  final String? profile;
  final String? phoneNumber;

  const NotificationUser({this.id, this.name, this.profile, this.phoneNumber});

  factory NotificationUser.fromJson(Map<String, dynamic> json) {
    return NotificationUser(
      id: json['id'] as String?,
      name: json['name'] as String?,
      profile: json['profile'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }
}

class MarkNotificationsRequest {
  /// Pass null to mark ALL notifications as read.
  final List<String>? ids;

  const MarkNotificationsRequest({this.ids});

  Map<String, dynamic> toJson() => {if (ids != null) 'ids': ids};
}
