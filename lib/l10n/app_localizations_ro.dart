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
  String get upcomingBookings => 'Rezervări viitoare';

  @override
  String get dateFilter => 'Filtru de date';

  @override
  String get noBookingsFound => 'Nu s-au găsit rezervări';

  @override
  String get request => 'Cerere';

  @override
  String get completed => 'Finalizat';

  @override
  String get ongoing => 'În curs';

  @override
  String get cancelled => 'Anulat';

  @override
  String get completedServices => 'Servicii finalizate';
}
