// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get home => 'Início';

  @override
  String get profile => 'Perfil';

  @override
  String get changeLanguage => 'Mudar idioma';

  @override
  String get save => 'Salvar';

  @override
  String languageChangedTo(String language) {
    return 'Idioma alterado para $language';
  }

  @override
  String get noBookings => 'Sem reservas';

  @override
  String get yourBookingsWillAppearHere => 'Suas reservas aparecerão aqui';

  @override
  String get noProvidersFound => 'Nenhum fornecedor encontrado';

  @override
  String get notification => 'Notificação';

  @override
  String get inbox => 'Caixa de entrada';

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
