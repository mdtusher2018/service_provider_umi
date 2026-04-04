import 'package:service_provider_umi/data/data_source/remote/notification_remote_data_source.dart';
import 'package:service_provider_umi/data/data_source/remote/static_content_remote_data_source.dart';

import 'package:service_provider_umi/data/models/notification_models.dart';
import 'package:service_provider_umi/data/models/static_content_model.dart';
import 'package:service_provider_umi/shared/enums/all_enums.dart';

// ─── Notifications ────────────────────────────────────────────────────────────

class MockNotificationDataSource implements NotificationRemoteDataSource {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'n_1',
      title: 'Booking Confirmed',
      message: 'Your booking for Elderly Care on April 10 has been accepted.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)).toString(),
      isRead: false,
      type: AlertType.orderComplete,
    ),
    NotificationItem(
      id: 'n_2',
      title: 'Payment Received',
      message: 'Your payment of \$30.00 was successfully processed.',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)).toString(),
      isRead: false,
      type: AlertType.orderComplete,
    ),
    NotificationItem(
      id: 'n_3',
      title: 'New Review',
      message: 'Ana Silva left you a 5-star review. Great work!',
      createdAt: DateTime.now().subtract(const Duration(days: 1)).toString(),
      isRead: false,
      type: AlertType.orderComplete,
    ),
    NotificationItem(
      id: 'n_4',
      title: 'Booking Reminder',
      message: 'You have a booking tomorrow at 10:00 AM with Mr. Raju.',
      createdAt: DateTime.now()
          .subtract(const Duration(days: 1, hours: 3))
          .toString(),
      isRead: false,
      type: AlertType.orderComplete,
    ),
    NotificationItem(
      id: 'n_5',
      title: 'Booking Cancelled',
      message: 'Your booking for Child Care on April 5 was cancelled.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)).toString(),
      isRead: true,
      type: AlertType.orderComplete,
    ),
    NotificationItem(
      id: 'n_6',
      title: 'Profile Verified',
      message: 'Congratulations! Your provider profile has been verified.',
      createdAt: DateTime.now().subtract(const Duration(days: 7)).toString(),
      isRead: true,
      type: AlertType.orderComplete,
    ),
  ];

  @override
  Future<List<NotificationItem>> getMyNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_notifications);
  }

  @override
  Future<void> markNotifications(MarkNotificationsRequest request) async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (final item in _notifications) {
      if (request.ids == null || request.ids!.contains(item.id)) {
        // In a real mock we'd update state; here we just simulate success.
      }
    }
  }

  @override
  Future<void> deleteNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _notifications.clear();
  }
}

// ─── Static Content ───────────────────────────────────────────────────────────

class MockStaticContentDataSource implements StaticContentRemoteDataSource {
  @override
  Future<StaticContentItem> getStaticContents() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const StaticContentItem(
      privacyPolicy:
          '<h1>Privacy Policy</h1>'
          '<p>We value your privacy and are committed to protecting your personal data.</p>',
      termsAndCondition:
          '<h1>Terms &amp; Conditions</h1>'
          '<p>By using this app you agree to our terms of service.</p>',
      aboutUs:
          '<h1>About Us</h1>'
          '<p>We connect trusted service providers with people who need help at home.</p>',
      refundPolicy:
          '<h1>Refund Policy</h1>'
          '<p>Full refunds are available up to 24 hours before the booking start time.</p>',
    );
  }
}
