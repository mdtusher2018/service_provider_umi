// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get home => 'الرئيسية';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get save => 'حفظ';

  @override
  String languageChangedTo(String language) {
    return 'تم تغيير اللغة إلى $language';
  }

  @override
  String get noBookings => 'لا توجد حجوزات';

  @override
  String get yourBookingsWillAppearHere => 'ستظهر حجوزاتك هنا';

  @override
  String get noProvidersFound => 'لم يتم العثور على مزودين';

  @override
  String get notification => 'إشعار';

  @override
  String get inbox => 'صندوق الوارد';

  @override
  String get upcomingBookings => 'Upcoming Bookings';

  @override
  String get dateFilter => 'Date Filter';

  @override
  String get noBookingsFound => 'No bookings found';

  @override
  String get request => 'Request';

  @override
  String get completed => 'Completed';

  @override
  String get ongoing => 'Ongoing';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get completedServices => 'Completed Services';
}
