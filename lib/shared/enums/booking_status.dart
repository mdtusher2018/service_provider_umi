import 'package:service_provider_umi/core/logger/app_logger.dart';

enum BookingStatus {
  requested,
  accepted,
  ongoing,
  complete,
  canceled;

  String get displayName {
    switch (this) {
      case BookingStatus.requested:
        return 'Pending';
      case BookingStatus.accepted:
        return 'Accepted';
      case BookingStatus.ongoing:
        return 'On Going';
      case BookingStatus.complete:
        return 'Completed';
      case BookingStatus.canceled:
        return 'Cancelled';
    }
  }

  bool get isTerminal =>
      this == BookingStatus.complete || this == BookingStatus.canceled;

  static BookingStatus fromString(String value) {
    final normalized = value.toLowerCase().trim();

    AppLogger.info(value);
    switch (normalized) {
      case 'requested':
        return BookingStatus.requested;
      case 'accepted':
        return BookingStatus.accepted;
      case 'ongoing':
        return BookingStatus.ongoing;
      case 'complete': // 🔥 API VALUE
        return BookingStatus.complete;
      case 'canceled':
        return BookingStatus.canceled;
      default:
        return BookingStatus.requested;
    }
  }
}

enum BookingFrequency { once, weekly }

enum StartTimeType { flexible, exact }
