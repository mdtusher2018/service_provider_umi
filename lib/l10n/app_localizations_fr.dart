// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get home => 'Accueil';

  @override
  String get profile => 'Profil';

  @override
  String get changeLanguage => 'Changer de langue';

  @override
  String get save => 'Enregistrer';

  @override
  String languageChangedTo(String language) {
    return 'Langue modifiée en $language';
  }

  @override
  String get noBookings => 'Aucune réservation';

  @override
  String get yourBookingsWillAppearHere => 'Vos réservations apparaîtront ici';

  @override
  String get noProvidersFound => 'Aucun fournisseur trouvé';

  @override
  String get notification => 'Notification';

  @override
  String get inbox => 'Boîte de réception';

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
