import 'package:service_provider_umi/data/data_source/remote/notification_remote_data_source.dart';
import 'package:service_provider_umi/data/data_source/remote/static_content_remote_data_source.dart';
import 'package:service_provider_umi/data/models/misc_models.dart';
import 'package:service_provider_umi/data/models/notification_models.dart';
import 'package:service_provider_umi/data/models/static_content_model.dart';

// ─── Notifications ────────────────────────────────────────────────────────────

class MockNotificationDataSource implements NotificationRemoteDataSource {
  static final List<NotificationItem> _notifications = [
    NotificationItem(
      title: 'Booking Confirmed',
      message: 'Your booking for Elderly Care on April 10 has been accepted.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)).toString(),
      id: "",
      isRead: false,
    ),
    NotificationItem(
      title: 'Payment Received',
      message: 'Your payment of \$30.00 was successfully processed.',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)).toString(),
      id: "",
      isRead: false,
    ),
    NotificationItem(
      title: 'New Review',
      id: "",
      isRead: false,
      message: 'Ana Silva left you a 5-star review. Great work!',
      createdAt: DateTime.now().subtract(const Duration(days: 1)).toString(),
    ),
    NotificationItem(
      title: 'Booking Reminder',
      message: 'You have a booking tomorrow at 10:00 AM with Mr. Raju.',
      createdAt: DateTime.now()
          .subtract(const Duration(days: 1, hours: 3))
          .toString(),
      id: "",
      isRead: false,
    ),
    NotificationItem(
      title: 'Booking Cancelled',
      id: "",
      isRead: false,
      message: 'Your booking for Child Care on April 5 was cancelled.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)).toString(),
    ),
    NotificationItem(
      title: 'Profile Verified',
      id: "",
      isRead: false,
      message: 'Congratulations! Your provider profile has been verified.',
      createdAt: DateTime.now().subtract(const Duration(days: 7)).toString(),
    ),
  ];

  @override
  Future<void> deleteNotifications() {
    throw UnimplementedError();
  }

  @override
  Future<List<NotificationItem>> getMyNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_notifications);
  }

  @override
  Future<void> markNotifications(MarkNotificationsRequest request) {
    throw UnimplementedError();
  }
}

// ─── Static Content ───────────────────────────────────────────────────────────

class MockStaticContentDataSource implements StaticContentRemoteDataSource {
  static final Map<String, List<FaqItem>> _faqs = {
    'elderly_care': [
      const FaqItem(
        id: 1,
        question: 'How does this service work?',
        answer:
            'Select a service, choose your schedule, and book a provider. '
            'The provider will confirm and arrive at your location.',
      ),
      const FaqItem(
        id: 2,
        question: 'Can I cancel a booking?',
        answer:
            'Yes, you can cancel a booking up to 24 hours before the start '
            'time without any charge.',
      ),
      const FaqItem(
        id: 3,
        question: 'Are providers background-checked?',
        answer:
            'All verified providers have undergone thorough background checks '
            'and identity verification.',
      ),
      const FaqItem(
        id: 4,
        question: 'What payment methods are accepted?',
        answer:
            'We accept all major credit/debit cards and mobile banking '
            'payments.',
      ),
      const FaqItem(
        id: 5,
        question: 'How do I contact support?',
        answer:
            'You can reach our support team via the in-app support section '
            'or call our helpline at any time.',
      ),
    ],
  };

  Future<List<FaqItem>> getFaqs(String serviceType) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final key = serviceType.toLowerCase().replaceAll('-', '_');
    return _faqs[key] ?? _faqs['elderly_care'] ?? [];
  }

  Future<SupportResponse> getSupport() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const SupportResponse(
      supportId: 'SUPPORT_12345',
      phoneNumber: '+1234567890',
    );
  }

  @override
  Future<StaticContentItem> getStaticContents() {
    throw UnimplementedError();
  }
}
