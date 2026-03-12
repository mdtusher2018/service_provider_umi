enum NotificationType {
  booking,
  chat,
  system,
  payment,
  review;

  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NotificationType.system,
    );
  }
}
