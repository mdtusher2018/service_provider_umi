// ── Notification ──────────────────────────────────────────────────────────────

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final bool isRead;
  final String createdAt;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
        id: json['_id'] as String? ?? json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        message: json['message'] as String? ?? '',
        isRead: json['isRead'] as bool? ?? false,
        createdAt: json['createdAt'] as String? ?? '',
      );
}

class MarkNotificationsRequest {
  /// Pass null to mark ALL notifications as read.
  final List<String>? ids;

  const MarkNotificationsRequest({this.ids});

  Map<String, dynamic> toJson() => {
        if (ids != null) 'ids': ids,
      };
}
