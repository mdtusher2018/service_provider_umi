// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get save => 'Save';

  @override
  String languageChangedTo(String language) {
    return 'Language changed to $language';
  }

  @override
  String get noBookings => 'No bookings';

  @override
  String get yourBookingsWillAppearHere => 'Your bookings will appear here';

  @override
  String get noProvidersFound => 'No providers found';

  @override
  String get notification => 'Notification';

  @override
  String get inbox => 'Inbox';

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
