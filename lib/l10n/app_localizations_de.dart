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
  String get calendar => 'Kalender';

  @override
  String get service => 'Service';

  @override
  String get favourites => 'Favoriten';

  @override
  String get notification => 'Benachrichtigung';

  @override
  String get inbox => 'Posteingang';

  @override
  String get minimumPriceSavedSuccessfully =>
      'Mindestpreis erfolgreich gespeichert';

  @override
  String get minimumPriceTitle => 'Mindestpreis';

  @override
  String get minimumPriceQuestion =>
      'Was ist der Mindestpreis, den ein Kunde zahlen muss, um Ihren Service zu buchen?  +info';

  @override
  String get minimumPriceLabel => 'Mindestpreis:';

  @override
  String get minimumPriceTip =>
      'Dies verhindert, dass Sie für einen so niedrigen Preis gebucht werden, dass es sich nicht lohnt, für den Service dorthin zu fahren';

  @override
  String get upcomingBookings => 'Anstehende Buchungen';

  @override
  String get dateFilter => 'Datumsfilter';

  @override
  String get noBookingsFound => 'Keine Buchungen gefunden';

  @override
  String get request => 'Anfrage';

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get ongoing => 'Laufend';

  @override
  String get cancelled => 'Storniert';

  @override
  String get completedServices => 'Abgeschlossene Dienste';

  @override
  String get accountSettings => 'Kontoeinstellungen';

  @override
  String get personalDetails => 'Persönliche Daten';

  @override
  String get myAddresses => 'Meine Adressen';

  @override
  String get paymentsAndRefunds => 'Zahlungen und Erstattungen';

  @override
  String get mySubscription => 'Mein Abonnement';

  @override
  String get myListing => 'Mein Eintrag';

  @override
  String get mySchedule => 'Mein Zeitplan';

  @override
  String get minimumBookingAmount => 'Mindestbuchungsbetrag';

  @override
  String get myReview => 'Meine Bewertung';

  @override
  String get addFaq => 'FAQ hinzufügen';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get language => 'Sprache';

  @override
  String get aboutUs => 'Über uns';

  @override
  String get termsAndConditions => 'Allgemeine Geschäftsbedingungen';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get logout => 'Abmelden';

  @override
  String get failedToLoadProfile => 'Profil konnte nicht geladen werden';

  @override
  String get pullToRefresh => 'Zum Aktualisieren ziehen';

  @override
  String get areYouSureToLogout =>
      'Sind Sie sicher, dass Sie sich abmelden möchten?';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get notConnected => 'Nicht verbunden';

  @override
  String get connected => 'Verbunden';

  @override
  String stripe(String status) {
    return 'Stripe : $status';
  }

  @override
  String get areYouSureToDeleteAccount =>
      'Sind Sie sicher, dass Sie löschen möchten?';

  @override
  String get profileUpdatedSuccessfully => 'Profil erfolgreich aktualisiert';

  @override
  String failedToUpdateProfile(String message) {
    return 'Profil konnte nicht aktualisiert werden: $message';
  }

  @override
  String failedToDeleteAccount(String message) {
    return 'Konto konnte nicht gelöscht werden: $message';
  }

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get aboutMe => 'Über mich';

  @override
  String get searchYourAddress => 'Suchen Sie Ihre Adresse…';

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String get deleteAccountPermanently => 'Konto dauerhaft löschen';

  @override
  String get yesDelete => 'JA, LÖSCHEN';

  @override
  String get noDontDelete => 'NEIN, NICHT LÖSCHEN';

  @override
  String get myAddress => 'Meine Adresse';

  @override
  String get yourAddresses => 'Ihre Adressen';

  @override
  String get retry => 'Wiederholen';

  @override
  String get noAddresses => 'Keine Adressen';

  @override
  String get addYourFirstAddressBelow =>
      'Fügen Sie unten Ihre erste Adresse hinzu';

  @override
  String get addNewAddress => 'Neue Adresse hinzufügen';

  @override
  String get defaultAddressUpdated => 'Standardadresse aktualisiert';

  @override
  String get defaultString => 'Standard';

  @override
  String addressLabel(String address) {
    return 'Adresse: $address';
  }

  @override
  String get setAsDefault => 'Als Standard festlegen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get delete => 'Löschen';

  @override
  String get areYouSureToDelete => 'Sind Sie sicher, dass Sie löschen möchten?';

  @override
  String get thisAddressWillBeRemoved =>
      'Diese Adresse wird dauerhaft entfernt.';

  @override
  String get pleaseSearchAndSelectAddress =>
      'Bitte suchen und wählen Sie zuerst eine Adresse aus.';

  @override
  String get editAddress => 'Adresse bearbeiten';

  @override
  String get addAddress => 'Adresse hinzufügen';

  @override
  String get searchAddress => 'Adresse suchen';

  @override
  String latLng(String lat, String lng) {
    return 'Lat: $lat, Lng: $lng';
  }

  @override
  String get reviewAndAdjust => 'Überprüfen & bei Bedarf anpassen';

  @override
  String get addressLine1 => 'Adresszeile 1 *';

  @override
  String get streetNumberAndName => 'Hausnummer & Straßenname';

  @override
  String get required => 'Erforderlich';

  @override
  String get addressLine2 => 'Adresszeile 2';

  @override
  String get areaNeighbourhood => 'Gebiet / Nachbarschaft (optional)';

  @override
  String get city => 'Stadt';

  @override
  String get state => 'Bundesland';

  @override
  String get postalCode => 'Postleitzahl';

  @override
  String get postal => 'PLZ';

  @override
  String get country => 'Land';

  @override
  String get updateAddress => 'Adresse aktualisieren';

  @override
  String get saveAddress => 'Adresse speichern';

  @override
  String get myCards => 'Meine Karten';

  @override
  String get addNew => 'Neu hinzufügen';

  @override
  String get failedToGetAddCardLink =>
      'Link zum Hinzufügen der Karte konnte nicht abgerufen werden';

  @override
  String get noCardsFound => 'Keine Karten gefunden';

  @override
  String get cardDeletedSuccessfully => 'Karte erfolgreich gelöscht';

  @override
  String get setAsDefaultCardSuccessfully =>
      'Erfolgreich als Standardkarte festgelegt';

  @override
  String get failedToSetDefaultCard =>
      'Standardkarte konnte nicht festgelegt werden';

  @override
  String get setAsDefaultCard => 'Als Standardkarte festlegen';

  @override
  String get myBalance => 'Mein Guthaben';

  @override
  String get availableBalance => 'Verfügbares Guthaben';

  @override
  String get paymentAndRefunds => 'Zahlungen und Erstattungen';

  @override
  String get paymentMethods => 'Zahlungsmethoden';

  @override
  String get myBooking => 'Meine Buchung';

  @override
  String paidOn(String date) {
    return 'Bezahlt am $date';
  }

  @override
  String serviceDate(String date) {
    return 'Servicedatum: $date';
  }

  @override
  String get passwordChangedSuccessfully => 'Passwort erfolgreich geändert';

  @override
  String get currentPassword => 'Aktuelles Passwort';

  @override
  String get oldPassword => 'Altes Passwort';

  @override
  String get enterOldPassword => 'Altes Passwort eingeben';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get confirmNewPassword => 'Neues Passwort bestätigen';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get faqAddedSuccessfully => 'FAQ erfolgreich hinzugefügt';

  @override
  String get question => 'Frage';

  @override
  String get enterYourQuestion => 'Geben Sie Ihre Frage ein';

  @override
  String get pleaseEnterQuestion => 'Bitte geben Sie eine Frage ein';

  @override
  String get answer => 'Antwort';

  @override
  String get enterYourAnswer => 'Geben Sie Ihre Antwort ein';

  @override
  String get pleaseEnterAnswer => 'Bitte geben Sie eine Antwort ein';

  @override
  String get submitFaq => 'FAQ einreichen';

  @override
  String get reviews => 'Bewertungen';

  @override
  String get noReviewsFound => 'Keine Bewertungen gefunden';

  @override
  String get noContentAvailable => 'Kein Inhalt verfügbar.';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get createAccountBtn => 'Konto erstellen';

  @override
  String get logIn => 'Anmelden';

  @override
  String get continueAsGuest => 'Als Gast fortfahren';

  @override
  String get whatWillYouDoOnIumi => 'Was werden Sie auf iumi tun?';

  @override
  String get roleDecisionNotFinal =>
      'Diese Entscheidung ist nicht endgültig. Sie können später sowohl Kunde als auch Fachmann sein.';

  @override
  String get bookAService => 'Einen Service buchen';

  @override
  String get iAmAClient => 'Ich bin Kunde';

  @override
  String get offerServices => 'Dienstleistungen anbieten';

  @override
  String get iAmAProfessional => 'Ich bin Fachmann';

  @override
  String get createAccountTitle => 'Konto erstellen';

  @override
  String get enterYourName => 'Geben Sie Ihren Namen ein';

  @override
  String get enterEmail => 'E-Mail eingeben';

  @override
  String get password => 'Passwort';

  @override
  String get serviceLocation => 'Servicestandort';

  @override
  String get yourLocation => 'Ihr Standort';

  @override
  String get searchAndSelectServiceArea =>
      'Suchen und wählen Sie Ihr Servicegebiet, damit Kunden Sie finden können.';

  @override
  String get weUseLocationForServices =>
      'Wir verwenden Ihren Standort, um Ihnen relevante Dienste in der Nähe anzuzeigen.';

  @override
  String get searchCitySuburbAddress => 'Stadt, Vorort oder Adresse suchen...';

  @override
  String get acceptTermsPrivacy =>
      'Durch die Erstellung eines Kontos akzeptiere ich die AGB und bestätige, dass ich die Datenschutzrichtlinie gelesen habe';

  @override
  String get termsAndCondition => 'Allgemeine Geschäftsbedingungen';

  @override
  String get pleaseAcceptTerms =>
      'Bitte akzeptieren Sie die AGB, um fortzufahren';

  @override
  String get haveAccountLogin => 'Haben Sie ein Konto? Anmelden';

  @override
  String get login => 'Anmelden';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get enterEmailSendOtp =>
      'Geben Sie Ihre E-Mail ein und wir senden Ihnen ein Reset-OTP.';

  @override
  String get enterYourEmail => 'Geben Sie Ihre E-Mail ein';

  @override
  String get sendOtp => 'OTP senden';

  @override
  String get otpVerifiedSuccessfully => 'OTP erfolgreich verifiziert';

  @override
  String get otpResentSuccessfully => 'OTP erfolgreich erneut gesendet';

  @override
  String get verifyOtp => 'OTP verifizieren';

  @override
  String enterOtpSentTo(String email) {
    return 'Geben Sie das an $email gesendete OTP ein';
  }

  @override
  String get enterTheOtp => 'Geben Sie das OTP ein';

  @override
  String get verify => 'Verifizieren';

  @override
  String get didNotReceiveOtpResend => 'OTP nicht erhalten? Erneut senden';

  @override
  String get resend => 'Erneut senden';

  @override
  String resendOtpInSeconds(int seconds) {
    return 'OTP erneut senden in ${seconds}s';
  }

  @override
  String get passwordResetSuccessfully =>
      'Passwort erfolgreich zurückgesetzt. Bitte melden Sie sich an.';

  @override
  String get resetPassword => 'Passwort zurücksetzen';

  @override
  String get continueWithGoogle => 'Mit Google fortfahren';

  @override
  String get or => 'oder';

  @override
  String get loginWithEmail => 'Mit E-Mail anmelden';

  @override
  String get createWithEmail => 'Mit E-Mail erstellen';

  @override
  String get weValueYourPrivacy => 'Wir schätzen Ihre Privatsphäre';

  @override
  String get cookiePolicyMsg =>
      'Webel verwendet Cookies zur Analyse der Werbekampagnenleistung, zur Verbesserung der App-Werbung und zur Personalisierung basierend auf Benutzereinstellungen.';

  @override
  String get accept => 'Akzeptieren';

  @override
  String get serviceAddress => 'Serviceadresse';

  @override
  String get selectWhereYouWantToReceiveService =>
      'Wählen Sie, wo Sie den Service erhalten möchten';

  @override
  String get support => 'Unterstützung';

  @override
  String get call => 'Anrufen';

  @override
  String get phoneNumberCopied => 'Telefonnummer in die Zwischenablage kopiert';

  @override
  String get message => 'Nachricht';

  @override
  String get emailCopied => 'E-Mail in die Zwischenablage kopiert';

  @override
  String get verificationPending => 'Verifizierung ausstehend';

  @override
  String get verificationPendingDesc =>
      'Ihr Konto wartet auf Verifizierung. Einige Funktionen können eingeschränkt sein, bis Ihr Konto verifiziert ist.';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get whenDoYouNeedIt => 'Wann brauchen Sie es?';

  @override
  String get frequency => 'Häufigkeit';

  @override
  String get justOnce => 'Nur einmal';

  @override
  String get oneTime => 'Einmalig';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String get recurring => 'Wiederkehrend';

  @override
  String get daysOfTheWeek => 'Wochentag(e)';

  @override
  String get startTime => 'Startzeit';

  @override
  String get flexibleStart => 'Flexibler Start';

  @override
  String get exactStart => 'Genauer Start';

  @override
  String get morning => 'Morgen';

  @override
  String get evening => 'Abend';

  @override
  String get selectExactTime => 'Genaue Uhrzeit wählen';

  @override
  String get skip => 'Überspringen';

  @override
  String get search => 'Suchen';

  @override
  String get back => 'Zurück';

  @override
  String get clearFilters => 'Filter löschen';

  @override
  String get palliativeCare => 'Palliativpflege';

  @override
  String get palliativeCareDesc =>
      'Nur Fachleute zeigen, die auf Palliativpflege spezialisiert sind.';

  @override
  String get drivingLicence => 'Führerschein';

  @override
  String get drivingLicenceDesc => 'Nur Fachleute mit Führerschein anzeigen';

  @override
  String get businessProfiles => 'Geschäftsprofile';

  @override
  String get businessProfilesDesc =>
      'Nur Profile, die einem validierten Unternehmen oder Selbstständigen entsprechen.';

  @override
  String get qualifiedCarer => 'Qualifizierter Pfleger';

  @override
  String get qualifiedCarerDesc =>
      'Nur Pflegekräfte mit einer Qualifikation, einem Diplom oder Abschluss als Gesundheitspersonal anzeigen';

  @override
  String get priceRange => 'Preisspanne';

  @override
  String get hourlyRate => 'Stundensatz';

  @override
  String get maxPriceWillingToPay =>
      'Maximaler Preis, den Sie zu zahlen bereit sind.';

  @override
  String get experienceLevel => 'Erfahrungsstufe';

  @override
  String get specificTasksRequirements =>
      'Spezifische Aufgaben / Anforderungen';

  @override
  String get updatedSuccessfully => 'Erfolgreich aktualisiert';

  @override
  String get images => 'Bilder';

  @override
  String get coverImage => 'Titelbild';

  @override
  String get galleryImages => 'Galeriebilder';

  @override
  String get add => 'Hinzufügen';

  @override
  String get palliativeCareImage => 'Palliativpflege-Bild';

  @override
  String get drivingLicenceImage => 'Führerschein-Bild';

  @override
  String get businessProfileImage => 'Geschäftsprofil-Bild';

  @override
  String get qualificationCertificate => 'Qualifikationszertifikat';

  @override
  String get submit => 'Absenden';

  @override
  String get update => 'Aktualisieren';

  @override
  String get applyFilters => 'Filter anwenden';

  @override
  String get verificationSubmitted => 'Verifizierung eingereicht';

  @override
  String get verificationSubmittedDesc =>
      'Ihr Antrag wurde erfolgreich eingereicht.\n\nBitte melden Sie sich erneut mit einem anderen Konto an.';

  @override
  String get findTheServiceYouNeed =>
      'Finden Sie den Service, den Sie brauchen';

  @override
  String get mostPopularInYourArea => 'Am beliebtesten in Ihrer Gegend';

  @override
  String get searchResults => 'Suchergebnisse';

  @override
  String get noServicesFound => 'Keine Dienste gefunden';

  @override
  String get tryADifferentSearchTerm =>
      'Versuchen Sie einen anderen Suchbegriff';

  @override
  String get howDoesTheServiceWork => 'Wie funktioniert der Service?';

  @override
  String get finding => 'Suche ';

  @override
  String get professionals => 'Fachleute';

  @override
  String get whenQuestion => 'Wann?';

  @override
  String get filters => 'Filter';

  @override
  String get howDoesTheServiceWorkTitle =>
      'Wie funktioniert der Altenpflegedienst?';

  @override
  String get noFaqsAvailable => 'Keine FAQs verfügbar';

  @override
  String get bookingAccepted => 'Buchung akzeptiert';

  @override
  String get comment => 'Kommentar';

  @override
  String get serviceBookedSuccess =>
      'Service erfolgreich für Altenpflege gebucht. Bitte stellen Sie sicher, dass die Unterstützung tägliche Check-ins, Medikamentenerinnerungen und Mobilitätshilfe umfasst.';

  @override
  String get dateAndTime => 'Datum und Uhrzeit';

  @override
  String get address => 'Adresse';

  @override
  String get servicePrice => 'Servicepreis';

  @override
  String get complete => 'Abschließen';

  @override
  String get bookingHasBeenCompleted => 'Diese Buchung wurde abgeschlossen';

  @override
  String get customer => 'Kunde:';

  @override
  String get provider => 'Anbieter:';

  @override
  String cantChatBeforeAction(String action) {
    return 'Sie können nicht chatten, bevor Sie die Buchung $action';
  }

  @override
  String get accepting => 'akzeptieren';

  @override
  String get creating => 'erstellen';

  @override
  String failedToLoadChat(String message) {
    return 'Chat konnte nicht geladen werden: $message';
  }

  @override
  String get serviceText => 'Service';

  @override
  String get bookingHours => 'Buchungsstunden';

  @override
  String get subtotal => 'Zwischensumme';

  @override
  String get clientProtection => 'Kundenschutz';

  @override
  String get total => 'Gesamt';

  @override
  String get free => 'Kostenlos';

  @override
  String get details => 'Details';

  @override
  String get noDataFound => 'Keine Daten gefunden';

  @override
  String get addressNotAvailable => 'Adresse nicht verfügbar';

  @override
  String addressCoordsLabel(String lat, String lng) {
    return 'Adresse: Lat: $lat, Lng: $lng';
  }

  @override
  String get congratulations => 'Herzlichen Glückwunsch';

  @override
  String get congratulationsDesc =>
      'Herzlichen Glückwunsch zu diesem Meilenstein in Ihrer beruflichen Laufbahn! Ihr Engagement, Ihre Expertise und harte Arbeit sind wirklich lobenswert.';

  @override
  String get done => 'Fertig';

  @override
  String get setUpAtLeastOneDay => 'Richten Sie mindestens einen Tag ein';

  @override
  String get selectATimeSlot => 'Wählen Sie ein Zeitfenster';

  @override
  String get bookingDotDot => 'Buchung…';

  @override
  String continueForAmountPerWeek(String price) {
    return 'Weiter für \$$price/Woche';
  }

  @override
  String bookForAmount(String price) {
    return 'Buchen für \$$price';
  }

  @override
  String get couldNotLoadAvailableSlots =>
      'Verfügbare Zeitfenster konnten nicht geladen werden. Tippen Sie oben auf Wiederholen.';

  @override
  String get noAvailableSlotsForDuration =>
      'Keine verfügbaren Zeitfenster für diese Dauer.';

  @override
  String get selectATime => 'Wählen Sie eine Uhrzeit';

  @override
  String saveTimeDuration(String start, String end, String duration) {
    return 'Speichern $start - $end · ${duration}h';
  }

  @override
  String get chat => 'Chat';

  @override
  String get history => 'Verlauf';

  @override
  String get alerts => 'Benachrichtigungen';

  @override
  String get newAlerts => 'Neue Benachrichtigungen';

  @override
  String get searchFriends => 'Freunde suchen';

  @override
  String get noUnreadAlerts => 'Keine ungelesenen Benachrichtigungen';

  @override
  String get paymentPending => 'Zahlung ausstehend';

  @override
  String get pendingAcceptance => 'Annahme ausstehend';

  @override
  String get payNow => 'Jetzt bezahlen';

  @override
  String get pending => 'Ausstehend';

  @override
  String get serviceInProgress => 'Service läuft';

  @override
  String get rating => 'Bewertung';

  @override
  String get needSupportImmediately => 'Sofortige Unterstützung benötigt';

  @override
  String get manageSubscription => 'Abonnement verwalten';

  @override
  String get subscriptionStatus => 'Abonnementstatus';

  @override
  String freeTrialDaysLeft(String daysLeft) {
    return '30-Tage-Testversion ($daysLeft Tage übrig)';
  }

  @override
  String get cancelledActiveTillPeriodEnd =>
      'Gekündigt (Aktiv bis Periodenende)';

  @override
  String get activePremium => 'Aktives Premium';

  @override
  String get expired => 'Abgelaufen';

  @override
  String get currentPlan => 'Aktueller Plan';

  @override
  String get subscriptionPrice => 'Abonnementpreis';

  @override
  String get activationDate => 'Aktivierungsdatum';

  @override
  String get nextBillingRenewal => 'Nächste Abrechnung / Verlängerung';

  @override
  String get purchasePlatform => 'Kaufplattform';

  @override
  String get annualPremium => 'Jährliches Premium';

  @override
  String get monthlyPremium => 'Monatliches Premium';

  @override
  String get noSubscriptionPurchased => 'Kein Abonnement gekauft';

  @override
  String get yourValueThisMonth => 'Ihr Wert in diesem Monat';

  @override
  String thisMonthRequestsBookings(String requests, String bookings) {
    return 'In diesem Monat haben Sie $requests Anfragen erhalten und $bookings Buchungen akzeptiert.';
  }

  @override
  String get requestsReceived => 'Anfragen erhalten';

  @override
  String get bookingsAccepted => 'Buchungen akzeptiert';

  @override
  String get acceptanceRate => 'Akzeptanzrate';

  @override
  String get upgradeToPremiumNow => 'Jetzt auf Premium upgraden';

  @override
  String get restorePurchase => 'Kauf wiederherstellen';

  @override
  String get subscriptionRestoredSuccessfully =>
      'Abonnement erfolgreich wiederhergestellt!';

  @override
  String get noActiveSubscriptionFoundToRestore =>
      'Kein aktives Abonnement zum Wiederherstellen gefunden.';

  @override
  String get cancelSubscription => 'Abonnement kündigen';

  @override
  String get cancelSubscriptionQuestion => 'Abonnement kündigen?';

  @override
  String ifYouCancelTodayPremiumAccess(String date) {
    return 'Wenn Sie heute kündigen, bleibt Ihr Premium-Zugang bis $date aktiv.\n\nBitte teilen Sie uns mit, warum Sie gehen:';
  }

  @override
  String get tooExpensive => 'Zu teuer';

  @override
  String get notGettingEnoughClientRequests => 'Nicht genug Kundenanfragen';

  @override
  String get usingADifferentPlatform => 'Verwende eine andere Plattform';

  @override
  String get other => 'Andere';

  @override
  String get stayWithUsGet20Off =>
      'Bleiben Sie bei uns! Erhalten Sie 20% RABATT auf Ihren nächsten Abrechnungszyklus anstatt zu kündigen.';

  @override
  String get keepMySubscription => 'Mein Abonnement behalten';

  @override
  String get confirmCancellation => 'Kündigung bestätigen';

  @override
  String get pleaseCancelViaStore =>
      'Bitte kündigen Sie über Ihre Google Play- oder App Store-Abonnementseite.';

  @override
  String get bio => 'Biografie';

  @override
  String get writeSomethingAboutYourself => 'Schreiben Sie etwas über sich...';

  @override
  String get pricePerHour => 'Preis pro Stunde';

  @override
  String get experience => 'Erfahrung';

  @override
  String get selectExperience => 'Erfahrung auswählen';

  @override
  String get specialties => 'Fachgebiete';

  @override
  String get otherTasksOffered => 'Andere angebotene Aufgaben';

  @override
  String get workSchedule => 'Arbeitsplan';

  @override
  String get whenAreYouAvailable =>
      'Wann sind Sie verfügbar, um Ihre Dienste anzubieten?';

  @override
  String get monday => 'Montag';

  @override
  String get tuesday => 'Dienstag';

  @override
  String get wednesday => 'Mittwoch';

  @override
  String get thursday => 'Donnerstag';

  @override
  String get friday => 'Freitag';

  @override
  String get saturday => 'Samstag';

  @override
  String get sunday => 'Sonntag';

  @override
  String get available => 'Verfügbar';

  @override
  String get notAvailable => 'Nicht verfügbar';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get pleaseUploadAnImage =>
      'Bitte laden Sie ein Bild für jede ausgewählte Option hoch.';

  @override
  String get ifYouAlreadySubmitARequest =>
      'Wenn Sie bereits einen Antrag eingereicht haben, melden Sie sich bitte mit einem anderen Konto an';

  @override
  String get preferences => 'Einstellungen';

  @override
  String get myWorkAreas => 'Meine Arbeitsbereiche';

  @override
  String get currentLocationMap => 'Aktuelle Standortkarte';

  @override
  String get next => 'Weiter';

  @override
  String get pleaseSelectYourRole => 'Bitte wählen Sie Ihre Rolle';

  @override
  String get micAndCameraPermissionsRequired =>
      'Mikrofon- und Kameraberechtigungen sind erforderlich';

  @override
  String get userIsBusyOrUnavailable =>
      'Benutzer ist beschäftigt oder nicht verfügbar';

  @override
  String get paymentSuccessful => 'Zahlung erfolgreich';

  @override
  String get accessLocked => 'ZUGANG GESPERRT';

  @override
  String get subscriptionRequired => 'Abonnement erforderlich';

  @override
  String get startFreeTrialToReceiveRequests =>
      'Starten Sie Ihre 30-tägige kostenlose Testversion, um Kundenanfragen zu erhalten und zu verwalten.';

  @override
  String get startFreeTrial => 'Kostenlose Testversion starten';

  @override
  String get youCanStillManageProfile =>
      'Sie können weiterhin Ihr Profil, Ihre Dienste und Ihren Zeitplan verwalten.';

  @override
  String get tryIumiProviderFree => 'IUMI Provider kostenlos testen';

  @override
  String get unlockEveryFeature =>
      'Alle Anbieterfunktionen 30 Tage lang freischalten.';

  @override
  String get thirtyDaysFree => '30 TAGE KOSTENLOS';

  @override
  String get receiveCustomerRequests => 'Kundenanfragen erhalten';

  @override
  String get acceptOrDeclineBookings => 'Buchungen annehmen oder ablehnen';

  @override
  String get contactCustomersAfterAcceptance =>
      'Kunden nach Annahme kontaktieren';

  @override
  String get manageYourSchedule => 'Ihren Zeitplan verwalten';

  @override
  String get freeFor30Days => '30 Tage kostenlos';

  @override
  String get then4999RonMonthCancelAnytime =>
      'Dann 49,99 RON/Monat. Jederzeit kündbar.';

  @override
  String get start30DayFreeTrial => '30-Tage-Testversion starten';

  @override
  String get upgradePremium => 'Premium upgraden';

  @override
  String get notNow => 'Nicht jetzt';

  @override
  String get noPaymentToday =>
      'Keine Zahlung heute. Funktioniert auf iOS, Android und Web.';

  @override
  String get somethingWentWrong => 'Etwas ist schiefgelaufen';

  @override
  String get seeMore => 'Mehr anzeigen';

  @override
  String get documents => 'Dokumente';

  @override
  String get chooseYourPlan => 'Wählen Sie Ihren Plan';

  @override
  String get noPlansAvailable => 'Zurzeit sind keine Pläne verfügbar.';

  @override
  String get checkBackLater =>
      'Bitte versuchen Sie es später noch einmal oder kontaktieren Sie den Support.';

  @override
  String get upgradeToPremium => 'Auf Premium upgraden';

  @override
  String get unlockAllFeatures =>
      'Schalten Sie alle Funktionen frei und vergrößern Sie Ihr Geschäft.';

  @override
  String savePercent(String percent) {
    return 'Sparen Sie $percent%';
  }

  @override
  String get alreadySubscribed => 'Sie haben diesen Plan bereits abonniert.';

  @override
  String get planNotAvailable =>
      'Dieser Plan ist auf dieser Plattform noch nicht zum Kauf verfügbar. Bitte versuchen Sie es später noch einmal.';

  @override
  String successfullySubscribed(String planName) {
    return 'Erfolgreich für $planName abonniert!';
  }

  @override
  String get subscribeNow => 'Jetzt abonnieren';

  @override
  String get messageSentSuccessfully =>
      'Ihre Nachricht wurde erfolgreich gesendet.';

  @override
  String get failedToSendMessage =>
      'Fehler beim Senden der Nachricht. Bitte versuchen Sie es erneut.';

  @override
  String get pleaseSelectDocument =>
      'Bitte wählen Sie mindestens ein Dokument aus, um fortzufahren.';

  @override
  String get documentsUpdatedSuccessfully =>
      'Dokumente erfolgreich aktualisiert';

  @override
  String get pleaseEnterValidPricePerHour =>
      'Bitte geben Sie einen gültigen Preis pro Stunde ein';

  @override
  String get listingUpdatedSuccessfully => 'Eintrag erfolgreich aktualisiert';

  @override
  String get failedToSubmitReview => 'Bewertung konnte nicht gesendet werden';

  @override
  String get reviewSubmittedSuccessfully => 'Bewertung erfolgreich gesendet';

  @override
  String get failedToSaveSchedule =>
      'Zeitplan konnte nicht gespeichert werden. Versuchen Sie es erneut.';

  @override
  String get pleaseFillOutAllFields => 'Bitte füllen Sie alle Felder aus.';

  @override
  String get pleaseSelectFlexibleStartTime =>
      'Bitte wählen Sie eine flexible Startzeit oder verwenden Sie \'Überspringen\'.';

  @override
  String get outstanding => 'Hervorragend';

  @override
  String get hello => 'Hallo';

  @override
  String get description => 'Beschreibung';

  @override
  String get copyrightIBadi => 'Copyright iBadi';

  @override
  String get badi => 'Badi';

  @override
  String get download => 'Herunterladen';

  @override
  String get end => 'Ende';

  @override
  String get markAllRead => 'Alle als gelesen markieren';

  @override
  String get goBack => 'Zurück';

  @override
  String get iumiAdminSupport => 'Iumi Admin-Support';

  @override
  String get emailAddress => 'E-Mail-Adresse';

  @override
  String get subject => 'Betreff';

  @override
  String get yourMessage => 'Ihre Nachricht';

  @override
  String get sayHello => 'Sag Hallo 👋';

  @override
  String get chooseOption => 'Option wählen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get completePayment => 'Zahlung abschließen';

  @override
  String get noMessages => 'Keine Nachrichten';

  @override
  String get noNotification => 'Keine Benachrichtigung';

  @override
  String get noScheduleAvailable => 'Kein Zeitplan verfügbar.';

  @override
  String get additionalComments => 'Zusätzliche Kommentare';

  @override
  String get gallery => 'Galerie';

  @override
  String get failedToLoadGallery => 'Galerie konnte nicht geladen werden';

  @override
  String get noImagesAvailable => 'Keine Bilder verfügbar';

  @override
  String get viewGallery => 'Galerie ansehen';

  @override
  String get noGalleryImageFound => 'Kein Galeriebild gefunden';

  @override
  String get comments => 'Kommentare';

  @override
  String get noCommentsFound => 'Keine Kommentare gefunden';

  @override
  String get serviceFrequency => 'Servicehäufigkeit';

  @override
  String get howManyTimesDoYouWantTheService =>
      'Wie oft möchten Sie den Service?';

  @override
  String get rateYourExperience => 'Bewerten Sie Ihre Erfahrung';

  @override
  String get deleteThisAddress => 'Diese Adresse löschen?';

  @override
  String get showSpecialistsIn => 'Spezialisten anzeigen in:';

  @override
  String get ok => 'OK';

  @override
  String get chooseFromGallery => 'Aus Galerie wählen';

  @override
  String get takeAPhoto => 'Foto aufnehmen';

  @override
  String get profilePicture => 'Profilbild';

  @override
  String get doYouWantToGoBack => 'Möchten Sie zurückgehen?';

  @override
  String get startYour30DayFreeTrialToReceiveAndManageCustomerRequests =>
      'Starten Sie Ihre 30-tägige kostenlose Testversion, um Kundenanfragen zu erhalten und zu verwalten.';

  @override
  String get youCanStillManageYourProfileServicesAndSchedule =>
      'Sie können weiterhin Ihr Profil, Ihre Dienste und Ihren Zeitplan verwalten.';
}
