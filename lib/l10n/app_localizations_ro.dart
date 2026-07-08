// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get home => 'Acasă';

  @override
  String get profile => 'Profil';

  @override
  String get changeLanguage => 'Schimbă limba';

  @override
  String get save => 'Salvează';

  @override
  String languageChangedTo(String language) {
    return 'Limba schimbată în $language';
  }

  @override
  String get noBookings => 'Nu există rezervări';

  @override
  String get yourBookingsWillAppearHere => 'Rezervările tale vor apărea aici';

  @override
  String get noProvidersFound => 'Niciun furnizor găsit';

  @override
  String get notification => 'Notificare';

  @override
  String get inbox => 'Mesaje';

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
