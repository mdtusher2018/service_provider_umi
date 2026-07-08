// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get home => 'Inicio';

  @override
  String get profile => 'Perfil';

  @override
  String get changeLanguage => 'Cambiar idioma';

  @override
  String get save => 'Guardar';

  @override
  String languageChangedTo(String language) {
    return 'Idioma cambiado a $language';
  }

  @override
  String get noBookings => 'Sin reservas';

  @override
  String get yourBookingsWillAppearHere => 'Tus reservas aparecerán aquí';

  @override
  String get noProvidersFound => 'No se encontraron proveedores';

  @override
  String get notification => 'Notificación';

  @override
  String get inbox => 'Bandeja de entrada';

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
