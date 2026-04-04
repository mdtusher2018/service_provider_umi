// ── Notification ──────────────────────────────────────────────────────────────

import 'package:service_provider_umi/shared/enums/all_enums.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final bool isRead;
  final String createdAt;
  final AlertType type;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.type,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
        id: json['_id'] as String? ?? json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        message: json['message'] as String? ?? '',
        isRead: json['isRead'] as bool? ?? false,
        createdAt: json['createdAt'] as String? ?? '',
        type: AlertType.values.firstWhere(
          (e) => e.toString().split('.').last == json['type'],
          orElse: () => AlertType.orderAccepted,
        ),
      );
}

class MarkNotificationsRequest {
  /// Pass null to mark ALL notifications as read.
  final List<String>? ids;

  const MarkNotificationsRequest({this.ids});

  Map<String, dynamic> toJson() => {if (ids != null) 'ids': ids};
}
