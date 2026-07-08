// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get home => 'Startseite';

  @override
  String get profile => 'Profil';

  @override
  String get changeLanguage => 'Sprache ändern';

  @override
  String get save => 'Speichern';

  @override
  String languageChangedTo(String language) {
    return 'Sprache geändert zu $language';
  }

  @override
  String get noBookings => 'Keine Buchungen';

  @override
  String get yourBookingsWillAppearHere =>
      'Ihre Buchungen werden hier angezeigt';

  @override
  String get noProvidersFound => 'Keine Anbieter gefunden';

  @override
  String get notification => 'Benachrichtigung';

  @override
  String get inbox => 'Posteingang';

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
