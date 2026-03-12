class DateHelper {
  DateHelper._();

  static DateTime? tryParse(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  static DateTime parseOrNow(String? value) {
    return tryParse(value) ?? DateTime.now();
  }

  static List<DateTime> getDaysInRange(DateTime start, DateTime end) {
    final days = <DateTime>[];
    var current = start;
    while (!current.isAfter(end)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }
    return days;
  }

  static List<DateTime> getAvailableDays({
    required DateTime from,
    int daysAhead = 30,
    List<int> excludeWeekdays = const [],
  }) {
    final days = <DateTime>[];
    var current = from;
    final end = from.add(Duration(days: daysAhead));

    while (!current.isAfter(end)) {
      if (!excludeWeekdays.contains(current.weekday)) {
        days.add(current);
      }
      current = current.add(const Duration(days: 1));
    }

    return days;
  }

  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday ||
        date.weekday == DateTime.sunday;
  }

  static bool isWithinRange(DateTime date, DateTime start, DateTime end) {
    return date.isAfter(start.subtract(const Duration(seconds: 1))) &&
        date.isBefore(end.add(const Duration(seconds: 1)));
  }

  static Duration timeBetween(DateTime start, DateTime end) {
    return end.difference(start).abs();
  }

  static String durationDisplay(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) return '${hours}h ${minutes}m';
    if (hours > 0) return '${hours}h';
    return '${minutes}m';
  }

  static List<String> generateTimeSlots({
    required int startHour,
    required int endHour,
    int intervalMinutes = 60,
  }) {
    final slots = <String>[];
    var currentMinutes = startHour * 60;
    final endMinutes = endHour * 60;

    while (currentMinutes < endMinutes) {
      final hour = currentMinutes ~/ 60;
      final minute = currentMinutes % 60;
      final period = hour < 12 ? 'AM' : 'PM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      slots.add(
          '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period');
      currentMinutes += intervalMinutes;
    }

    return slots;
  }
}
