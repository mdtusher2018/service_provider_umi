import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  bool get isToday {
    final now = DateTime.now();
    final local = toLocal();
    return local.year == now.year && local.month == now.month && local.day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final local = toLocal();
    return local.year == yesterday.year &&
        local.month == yesterday.month &&
        local.day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final local = toLocal();
    return local.year == tomorrow.year &&
        local.month == tomorrow.month &&
        local.day == tomorrow.day;
  }

  bool get isPast => isBefore(DateTime.now());
  bool get isFuture => isAfter(DateTime.now());

  bool isSameDay(DateTime other) {
    final local = toLocal();
    final localOther = other.toLocal();
    return local.year == localOther.year && local.month == localOther.month && local.day == localOther.day;
  }

  DateTime get startOfDay {
    final local = toLocal();
    return DateTime(local.year, local.month, local.day);
  }
  
  DateTime get endOfDay {
    final local = toLocal();
    return DateTime(local.year, local.month, local.day, 23, 59, 59, 999, 999);
  }

  DateTime get startOfWeek {
    final local = toLocal();
    final diff = local.weekday - 1;
    return DateTime(local.year, local.month, local.day - diff);
  }

  DateTime get startOfMonth {
    final local = toLocal();
    return DateTime(local.year, local.month, 1);
  }
  
  DateTime get endOfMonth {
    final local = toLocal();
    return DateTime(local.year, local.month + 1, 0, 23, 59, 59);
  }

  String get toDisplayDate => DateFormat('dd MMM yyyy').format(this.toLocal());
  String get toDisplayTime => DateFormat('hh:mm a').format(this.toLocal());
  String get toDisplayDateTime =>
      DateFormat('dd MMM yyyy, hh:mm a').format(this.toLocal());
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
    final local = toLocal();
    int age = now.year - local.year;
    if (now.month < local.month || (now.month == local.month && now.day < local.day)) {
      age--;
    }
    return age;
  }

  String get getMonth {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[toLocal().month - 1];
  }

  String get getDayOfWeek {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[toLocal().weekday - 1];
  }
}

extension NullableDateTimeExtensions on DateTime? {
  String get orEmpty => this?.toDisplayDate ?? '';
}
