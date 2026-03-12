import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  bool get isPast => isBefore(DateTime.now());
  bool get isFuture => isAfter(DateTime.now());

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay =>
      DateTime(year, month, day, 23, 59, 59, 999, 999);

  DateTime get startOfWeek {
    final diff = weekday - 1;
    return DateTime(year, month, day - diff);
  }

  DateTime get startOfMonth => DateTime(year, month, 1);
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59);

  String get toDisplayDate => DateFormat('dd MMM yyyy').format(this);
  String get toDisplayTime => DateFormat('hh:mm a').format(this);
  String get toDisplayDateTime => DateFormat('dd MMM yyyy, hh:mm a').format(this);
  String get toApiDate => DateFormat('yyyy-MM-dd').format(this);
  String get toApiDateTime => toUtc().toIso8601String();

  String get toRelativeTime {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (isToday) return toDisplayTime;
    if (isYesterday) return 'Yesterday';
    if (diff.inDays < 7) return DateFormat('EEEE').format(this);
    return toDisplayDate;
  }

  int get ageInYears {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }
}

extension NullableDateTimeExtensions on DateTime? {
  String get orEmpty => this?.toDisplayDate ?? '';
}
