class AvailabilitySlot {
  final DateTime start;
  final DateTime end;

  const AvailabilitySlot({required this.start, required this.end});

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) =>
      AvailabilitySlot(
        start: DateTime.parse(json['start'] as String),
        end: DateTime.parse(json['end'] as String),
      );

  /// "09:00"
  String get startTime {
    final local = start.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  String get endTime {
    final local = end.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}

class AvailabilityRequest {
  final String providerId;
  final DateTime date;
  final int slotDuration; // minutes

  const AvailabilityRequest({
    required this.providerId,
    required this.date,
    required this.slotDuration,
  });

  Map<String, dynamic> toJson() => {
    'providerId': "6a09412b40a213cbd1466b8d", //"providerId",
    'date': DateTime(
      date.year,
      date.month,
      date.day + 1,
    ).toUtc().toIso8601String(),
    'slotDuration': slotDuration,
  };
}
