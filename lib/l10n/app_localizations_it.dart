// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profilo';

  @override
  String get changeLanguage => 'Cambia lingua';

  @override
  String get save => 'Salva';

  @override
  String languageChangedTo(String language) {
    return 'Lingua cambiata in $language';
  }

  @override
  String get noBookings => 'Nessuna prenotazione';

  @override
  String get yourBookingsWillAppearHere =>
      'Le tue prenotazioni appariranno qui';

  @override
  String get noProvidersFound => 'Nessun fornitore trovato';

  @override
  String get notification => 'Notifica';

  @override
  String get inbox => 'Posta in arrivo';

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
