enum BookingStatus {
  pending,
  accepted,
  ongoing,
  completed,
  cancelled,
  rejected;

  String get displayName {
    switch (this) {
      case BookingStatus.pending:    return 'Pending';
      case BookingStatus.accepted:   return 'Accepted';
      case BookingStatus.ongoing:    return 'Ongoing';
      case BookingStatus.completed:  return 'Completed';
      case BookingStatus.cancelled:  return 'Cancelled';
      case BookingStatus.rejected:   return 'Rejected';
    }
  }

  String get apiValue => name;

  bool get isActive =>
      this == BookingStatus.accepted || this == BookingStatus.ongoing;
  bool get isTerminal =>
      this == BookingStatus.completed ||
      this == BookingStatus.cancelled ||
      this == BookingStatus.rejected;

  static BookingStatus fromString(String value) {
    return BookingStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => BookingStatus.pending,
    );
  }
}
