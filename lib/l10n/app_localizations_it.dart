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
  String get calendar => 'Calendario';

  @override
  String get service => 'Servizio';

  @override
  String get favourites => 'Preferiti';

  @override
  String get notification => 'Notifica';

  @override
  String get inbox => 'Posta in arrivo';

  @override
  String get minimumPriceSavedSuccessfully =>
      'Prezzo minimo salvato con successo';

  @override
  String get minimumPriceTitle => 'Prezzo minimo';

  @override
  String get minimumPriceQuestion =>
      'Qual è il prezzo minimo che un cliente deve pagare per prenotare il tuo servizio?  +info';

  @override
  String get minimumPriceLabel => 'Prezzo minimo:';

  @override
  String get minimumPriceTip =>
      'Ciò eviterà di essere prenotati per un prezzo così basso che non vale la pena viaggiare per il servizio';

  @override
  String get upcomingBookings => 'Prenotazioni imminenti';

  @override
  String get dateFilter => 'Filtro data';

  @override
  String get noBookingsFound => 'Nessuna prenotazione trovata';

  @override
  String get request => 'Richiesta';

  @override
  String get completed => 'Completato';

  @override
  String get ongoing => 'In corso';

  @override
  String get cancelled => 'Annullato';

  @override
  String get completedServices => 'Servizi completati';

  @override
  String get accountSettings => 'Impostazioni account';

  @override
  String get personalDetails => 'Dati personali';

  @override
  String get myAddresses => 'I miei indirizzi';

  @override
  String get paymentsAndRefunds => 'Pagamenti e rimborsi';

  @override
  String get mySubscription => 'Il mio abbonamento';

  @override
  String get myListing => 'Il mio annuncio';

  @override
  String get mySchedule => 'Il mio programma';

  @override
  String get minimumBookingAmount => 'Importo minimo prenotazione';

  @override
  String get myReview => 'La mia recensione';

  @override
  String get addFaq => 'Aggiungi FAQ';

  @override
  String get changePassword => 'Cambia password';

  @override
  String get language => 'Lingua';

  @override
  String get aboutUs => 'Chi siamo';

  @override
  String get termsAndConditions => 'Termini e condizioni';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get logout => 'Esci';

  @override
  String get failedToLoadProfile => 'Impossibile caricare il profilo';

  @override
  String get pullToRefresh => 'Tira per aggiornare';

  @override
  String get areYouSureToLogout => 'Sei sicuro di voler uscire?';

  @override
  String get cancel => 'Annulla';

  @override
  String get notConnected => 'Non connesso';

  @override
  String get connected => 'Connesso';

  @override
  String stripe(String status) {
    return 'Stripe : $status';
  }

  @override
  String get areYouSureToDeleteAccount => 'Sei sicuro di voler eliminare?';

  @override
  String get profileUpdatedSuccessfully => 'Profilo aggiornato con successo';

  @override
  String failedToUpdateProfile(String message) {
    return 'Impossibile aggiornare il profilo: $message';
  }

  @override
  String failedToDeleteAccount(String message) {
    return 'Impossibile eliminare l\'account: $message';
  }

  @override
  String get fullName => 'Nome completo';

  @override
  String get aboutMe => 'Su di me';

  @override
  String get searchYourAddress => 'Cerca il tuo indirizzo…';

  @override
  String get phoneNumber => 'Numero di telefono';

  @override
  String get deleteAccountPermanently => 'Elimina account definitivamente';

  @override
  String get yesDelete => 'SÌ, ELIMINA';

  @override
  String get noDontDelete => 'NO, NON ELIMINARE';

  @override
  String get myAddress => 'Il mio indirizzo';

  @override
  String get yourAddresses => 'I tuoi indirizzi';

  @override
  String get retry => 'Riprova';

  @override
  String get noAddresses => 'Nessun indirizzo';

  @override
  String get addYourFirstAddressBelow =>
      'Aggiungi il tuo primo indirizzo qui sotto';

  @override
  String get addNewAddress => 'Aggiungi nuovo indirizzo';

  @override
  String get defaultAddressUpdated => 'Indirizzo predefinito aggiornato';

  @override
  String get defaultString => 'Predefinito';

  @override
  String addressLabel(String address) {
    return 'Indirizzo: $address';
  }

  @override
  String get setAsDefault => 'Imposta come predefinito';

  @override
  String get edit => 'Modifica';

  @override
  String get delete => 'Elimina';

  @override
  String get areYouSureToDelete => 'Sei sicuro di voler eliminare?';

  @override
  String get thisAddressWillBeRemoved =>
      'Questo indirizzo verrà rimosso permanentemente.';

  @override
  String get pleaseSearchAndSelectAddress =>
      'Cerca e seleziona prima un indirizzo.';

  @override
  String get editAddress => 'Modifica indirizzo';

  @override
  String get addAddress => 'Aggiungi indirizzo';

  @override
  String get searchAddress => 'Cerca indirizzo';

  @override
  String latLng(String lat, String lng) {
    return 'Lat: $lat, Lng: $lng';
  }

  @override
  String get reviewAndAdjust => 'Rivedi e modifica se necessario';

  @override
  String get addressLine1 => 'Riga indirizzo 1 *';

  @override
  String get streetNumberAndName => 'Numero civico e nome della via';

  @override
  String get required => 'Obbligatorio';

  @override
  String get addressLine2 => 'Riga indirizzo 2';

  @override
  String get areaNeighbourhood => 'Zona / quartiere (opzionale)';

  @override
  String get city => 'Città';

  @override
  String get state => 'Stato';

  @override
  String get postalCode => 'Codice postale';

  @override
  String get postal => 'Postale';

  @override
  String get country => 'Paese';

  @override
  String get updateAddress => 'Aggiorna indirizzo';

  @override
  String get saveAddress => 'Salva indirizzo';

  @override
  String get myCards => 'Le mie carte';

  @override
  String get addNew => 'Aggiungi';

  @override
  String get failedToGetAddCardLink =>
      'Impossibile ottenere il link per aggiungere la carta';

  @override
  String get noCardsFound => 'Nessuna carta trovata';

  @override
  String get cardDeletedSuccessfully => 'Carta eliminata con successo';

  @override
  String get setAsDefaultCardSuccessfully =>
      'Carta predefinita impostata con successo';

  @override
  String get failedToSetDefaultCard =>
      'Impossibile impostare la carta predefinita';

  @override
  String get setAsDefaultCard => 'Imposta come carta predefinita';

  @override
  String get myBalance => 'Il mio saldo';

  @override
  String get availableBalance => 'Saldo disponibile';

  @override
  String get paymentAndRefunds => 'Pagamenti e rimborsi';

  @override
  String get paymentMethods => 'Metodi di pagamento';

  @override
  String get myBooking => 'La mia prenotazione';

  @override
  String paidOn(String date) {
    return 'Pagato il $date';
  }

  @override
  String serviceDate(String date) {
    return 'Data del servizio: $date';
  }

  @override
  String get passwordChangedSuccessfully => 'Password cambiata con successo';

  @override
  String get currentPassword => 'Password attuale';

  @override
  String get oldPassword => 'Vecchia password';

  @override
  String get enterOldPassword => 'Inserisci vecchia password';

  @override
  String get newPassword => 'Nuova password';

  @override
  String get confirmNewPassword => 'Conferma nuova password';

  @override
  String get confirmPassword => 'Conferma password';

  @override
  String get faqAddedSuccessfully => 'FAQ aggiunta con successo';

  @override
  String get question => 'Domanda';

  @override
  String get enterYourQuestion => 'Inserisci la tua domanda';

  @override
  String get pleaseEnterQuestion => 'Per favore inserisci una domanda';

  @override
  String get answer => 'Risposta';

  @override
  String get enterYourAnswer => 'Inserisci la tua risposta';

  @override
  String get pleaseEnterAnswer => 'Per favore inserisci una risposta';

  @override
  String get submitFaq => 'Invia FAQ';

  @override
  String get reviews => 'Recensioni';

  @override
  String get noReviewsFound => 'Nessuna recensione trovata';

  @override
  String get noContentAvailable => 'Nessun contenuto disponibile.';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get createAccountBtn => 'Crea account';

  @override
  String get logIn => 'Accedi';

  @override
  String get continueAsGuest => 'Continua come ospite';

  @override
  String get whatWillYouDoOnIumi => 'Cosa farai su iumi?';

  @override
  String get roleDecisionNotFinal =>
      'Questa decisione non è definitiva. Potrai essere sia cliente che professionista in seguito.';

  @override
  String get bookAService => 'Prenota un servizio';

  @override
  String get iAmAClient => 'Sono un cliente';

  @override
  String get offerServices => 'Offrire servizi';

  @override
  String get iAmAProfessional => 'Sono un professionista';

  @override
  String get createAccountTitle => 'Crea account';

  @override
  String get enterYourName => 'Inserisci il tuo nome';

  @override
  String get enterEmail => 'Inserisci email';

  @override
  String get password => 'Password';

  @override
  String get serviceLocation => 'Luogo del servizio';

  @override
  String get yourLocation => 'La tua posizione';

  @override
  String get searchAndSelectServiceArea =>
      'Cerca e seleziona la tua area di servizio per farti trovare dai clienti.';

  @override
  String get weUseLocationForServices =>
      'Utilizziamo la tua posizione per mostrarti servizi pertinenti nelle vicinanze.';

  @override
  String get searchCitySuburbAddress => 'Cerca città, quartiere o indirizzo...';

  @override
  String get acceptTermsPrivacy =>
      'Creando un account, accetto i Termini e Condizioni e confermo di aver letto l\'Informativa sulla Privacy';

  @override
  String get termsAndCondition => 'Termini e Condizioni';

  @override
  String get pleaseAcceptTerms =>
      'Accetta i termini e le condizioni per continuare';

  @override
  String get haveAccountLogin => 'Hai un account? Accedi';

  @override
  String get login => 'Accedi';

  @override
  String get forgotPassword => 'Password dimenticata?';

  @override
  String get enterEmailSendOtp =>
      'Inserisci la tua email e ti invieremo un OTP di reset.';

  @override
  String get enterYourEmail => 'Inserisci la tua email';

  @override
  String get sendOtp => 'Invia OTP';

  @override
  String get otpVerifiedSuccessfully => 'OTP verificato con successo';

  @override
  String get otpResentSuccessfully => 'OTP reinviato con successo';

  @override
  String get verifyOtp => 'Verifica OTP';

  @override
  String enterOtpSentTo(String email) {
    return 'Inserisci l\'OTP inviato a $email';
  }

  @override
  String get enterTheOtp => 'Inserisci l\'OTP';

  @override
  String get verify => 'Verifica';

  @override
  String get didNotReceiveOtpResend => 'Non hai ricevuto l\'OTP? Reinvia';

  @override
  String get resend => 'Reinvia';

  @override
  String resendOtpInSeconds(int seconds) {
    return 'Reinvia OTP tra ${seconds}s';
  }

  @override
  String get passwordResetSuccessfully =>
      'Password reimpostata con successo. Effettua il login.';

  @override
  String get resetPassword => 'Reimposta password';

  @override
  String get continueWithGoogle => 'Continua con Google';

  @override
  String get or => 'o';

  @override
  String get loginWithEmail => 'Accedi con email';

  @override
  String get createWithEmail => 'Crea con email';

  @override
  String get weValueYourPrivacy => 'Apprezziamo la tua privacy';

  @override
  String get cookiePolicyMsg =>
      'Webel utilizza cookie per analizzare le prestazioni pubblicitarie, migliorare gli annunci e personalizzare l\'esperienza in base alle preferenze dell\'utente.';

  @override
  String get accept => 'Accetta';

  @override
  String get serviceAddress => 'Indirizzo del servizio';

  @override
  String get selectWhereYouWantToReceiveService =>
      'Seleziona dove vuoi ricevere il servizio';

  @override
  String get support => 'Supporto';

  @override
  String get call => 'Chiama';

  @override
  String get phoneNumberCopied => 'Numero di telefono copiato negli appunti';

  @override
  String get message => 'Messaggio';

  @override
  String get emailCopied => 'Email copiata negli appunti';

  @override
  String get verificationPending => 'Verifica in attesa';

  @override
  String get verificationPendingDesc =>
      'Il tuo account è in attesa di verifica. Alcune funzionalità potrebbero essere limitate.';

  @override
  String get refresh => 'Aggiorna';

  @override
  String get whenDoYouNeedIt => 'Quando ne hai bisogno?';

  @override
  String get frequency => 'Frequenza';

  @override
  String get justOnce => 'Solo una volta';

  @override
  String get oneTime => 'Una tantum';

  @override
  String get weekly => 'Settimanale';

  @override
  String get recurring => 'Ricorrente';

  @override
  String get daysOfTheWeek => 'Giorno/i della settimana';

  @override
  String get startTime => 'Ora di inizio';

  @override
  String get flexibleStart => 'Inizio flessibile';

  @override
  String get exactStart => 'Inizio esatto';

  @override
  String get morning => 'Mattina';

  @override
  String get evening => 'Sera';

  @override
  String get selectExactTime => 'Seleziona l\'ora esatta';

  @override
  String get skip => 'Salta';

  @override
  String get search => 'Cerca';

  @override
  String get back => 'Indietro';

  @override
  String get clearFilters => 'Cancella filtri';

  @override
  String get palliativeCare => 'Cure palliative';

  @override
  String get palliativeCareDesc =>
      'Mostra solo professionisti specializzati in cure palliative.';

  @override
  String get drivingLicence => 'Patente di guida';

  @override
  String get drivingLicenceDesc =>
      'Mostra solo professionisti con patente di guida';

  @override
  String get businessProfiles => 'Profili aziendali';

  @override
  String get businessProfilesDesc =>
      'Solo profili corrispondenti a un\'azienda o professionista autonomo validato.';

  @override
  String get qualifiedCarer => 'Operatore qualificato';

  @override
  String get qualifiedCarerDesc =>
      'Mostra solo operatori con qualifica, diploma o laurea come personale sanitario';

  @override
  String get priceRange => 'Fascia di prezzo';

  @override
  String get hourlyRate => 'Tariffa oraria';

  @override
  String get maxPriceWillingToPay =>
      'Prezzo massimo che sei disposto a pagare.';

  @override
  String get experienceLevel => 'Livello di esperienza';

  @override
  String get specificTasksRequirements => 'Compiti specifici / Requisiti';

  @override
  String get updatedSuccessfully => 'Aggiornato con successo';

  @override
  String get images => 'Immagini';

  @override
  String get coverImage => 'Immagine di copertina';

  @override
  String get galleryImages => 'Immagini della galleria';

  @override
  String get add => 'Aggiungi';

  @override
  String get palliativeCareImage => 'Immagine cure palliative';

  @override
  String get drivingLicenceImage => 'Immagine patente di guida';

  @override
  String get businessProfileImage => 'Immagine profilo aziendale';

  @override
  String get qualificationCertificate => 'Certificato di qualifica';

  @override
  String get submit => 'Invia';

  @override
  String get update => 'Aggiorna';

  @override
  String get applyFilters => 'Applica filtri';

  @override
  String get verificationSubmitted => 'Verifica inviata';

  @override
  String get verificationSubmittedDesc =>
      'La tua richiesta è stata inviata con successo.\n\nEffettua nuovamente il login con un altro account.';

  @override
  String get findTheServiceYouNeed => 'Trova il servizio di cui hai bisogno';

  @override
  String get mostPopularInYourArea => 'I più popolari nella tua zona';

  @override
  String get searchResults => 'Risultati di ricerca';

  @override
  String get noServicesFound => 'Nessun servizio trovato';

  @override
  String get tryADifferentSearchTerm => 'Prova un altro termine di ricerca';

  @override
  String get howDoesTheServiceWork => 'Come funziona il servizio?';

  @override
  String get finding => 'Ricerca di ';

  @override
  String get professionals => 'professionisti';

  @override
  String get whenQuestion => 'Quando?';

  @override
  String get filters => 'Filtri';

  @override
  String get howDoesTheServiceWorkTitle =>
      'Come funziona il servizio di assistenza anziani?';

  @override
  String get noFaqsAvailable => 'Nessuna FAQ disponibile';

  @override
  String get bookingAccepted => 'Prenotazione accettata';

  @override
  String get comment => 'Commento';

  @override
  String get serviceBookedSuccess =>
      'Servizio prenotato con successo per assistenza anziani. Assicurarsi che l\'assistenza includa controlli giornalieri, promemoria farmaci e aiuto con la mobilità.';

  @override
  String get dateAndTime => 'Data e ora';

  @override
  String get address => 'Indirizzo';

  @override
  String get servicePrice => 'Prezzo del servizio';

  @override
  String get complete => 'Completa';

  @override
  String get bookingHasBeenCompleted =>
      'Questa prenotazione è stata completata';

  @override
  String get customer => 'Cliente:';

  @override
  String get provider => 'Fornitore:';

  @override
  String cantChatBeforeAction(String action) {
    return 'Non puoi chattare prima di $action la prenotazione';
  }

  @override
  String get accepting => 'accettare';

  @override
  String get creating => 'creare';

  @override
  String failedToLoadChat(String message) {
    return 'Impossibile caricare la chat: $message';
  }

  @override
  String get serviceText => 'Servizio';

  @override
  String get bookingHours => 'Ore di prenotazione';

  @override
  String get subtotal => 'Subtotale';

  @override
  String get clientProtection => 'Protezione cliente';

  @override
  String get total => 'Totale';

  @override
  String get free => 'Gratuito';

  @override
  String get details => 'Dettagli';

  @override
  String get noDataFound => 'Nessun dato trovato';

  @override
  String get addressNotAvailable => 'Indirizzo non disponibile';

  @override
  String addressCoordsLabel(String lat, String lng) {
    return 'Indirizzo: Lat: $lat, Lng: $lng';
  }

  @override
  String get congratulations => 'Congratulazioni';

  @override
  String get congratulationsDesc =>
      'Congratulazioni per aver raggiunto questa pietra miliare nel tuo percorso professionale! La tua dedizione, competenza e duro lavoro sono davvero encomiabili.';

  @override
  String get done => 'Fatto';

  @override
  String get setUpAtLeastOneDay => 'Imposta almeno un giorno';

  @override
  String get selectATimeSlot => 'Seleziona una fascia oraria';

  @override
  String get bookingDotDot => 'Prenotazione…';

  @override
  String continueForAmountPerWeek(String price) {
    return 'Continua per \$$price/settimana';
  }

  @override
  String bookForAmount(String price) {
    return 'Prenota per \$$price';
  }

  @override
  String get couldNotLoadAvailableSlots =>
      'Impossibile caricare le fasce orarie disponibili. Tocca Riprova sopra.';

  @override
  String get noAvailableSlotsForDuration =>
      'Nessuna fascia oraria disponibile per questa durata.';

  @override
  String get selectATime => 'Seleziona un orario';

  @override
  String saveTimeDuration(String start, String end, String duration) {
    return 'Salva $start - $end · ${duration}h';
  }

  @override
  String get chat => 'Chat';

  @override
  String get history => 'Cronologia';

  @override
  String get alerts => 'Avvisi';

  @override
  String get newAlerts => 'Nuovi avvisi';

  @override
  String get searchFriends => 'Cerca amici';

  @override
  String get noUnreadAlerts => 'Nessun avviso non letto';

  @override
  String get paymentPending => 'Pagamento in attesa';

  @override
  String get pendingAcceptance => 'In attesa di accettazione';

  @override
  String get payNow => 'Paga ora';

  @override
  String get pending => 'In attesa';

  @override
  String get serviceInProgress => 'Servizio in corso';

  @override
  String get rating => 'Valutazione';

  @override
  String get needSupportImmediately => 'Hai bisogno di supporto immediato';

  @override
  String get manageSubscription => 'Gestisci abbonamento';

  @override
  String get subscriptionStatus => 'Stato abbonamento';

  @override
  String freeTrialDaysLeft(String daysLeft) {
    return 'Prova gratuita di 30 giorni ($daysLeft giorni rimanenti)';
  }

  @override
  String get cancelledActiveTillPeriodEnd =>
      'Annullato (Attivo fino a fine periodo)';

  @override
  String get activePremium => 'Premium attivo';

  @override
  String get expired => 'Scaduto';

  @override
  String get currentPlan => 'Piano attuale';

  @override
  String get subscriptionPrice => 'Prezzo abbonamento';

  @override
  String get activationDate => 'Data di attivazione';

  @override
  String get nextBillingRenewal => 'Prossima fatturazione / Rinnovo';

  @override
  String get purchasePlatform => 'Piattaforma di acquisto';

  @override
  String get annualPremium => 'Premium annuale';

  @override
  String get monthlyPremium => 'Premium mensile';

  @override
  String get noSubscriptionPurchased => 'Nessun abbonamento acquistato';

  @override
  String get yourValueThisMonth => 'Il tuo valore questo mese';

  @override
  String thisMonthRequestsBookings(String requests, String bookings) {
    return 'Questo mese hai ricevuto $requests richieste e accettato $bookings prenotazioni.';
  }

  @override
  String get requestsReceived => 'Richieste ricevute';

  @override
  String get bookingsAccepted => 'Prenotazioni accettate';

  @override
  String get acceptanceRate => 'Tasso di accettazione';

  @override
  String get upgradeToPremiumNow => 'Passa a Premium ora';

  @override
  String get restorePurchase => 'Ripristina acquisto';

  @override
  String get subscriptionRestoredSuccessfully =>
      'Abbonamento ripristinato con successo!';

  @override
  String get noActiveSubscriptionFoundToRestore =>
      'Nessun abbonamento attivo trovato da ripristinare.';

  @override
  String get cancelSubscription => 'Annulla abbonamento';

  @override
  String get cancelSubscriptionQuestion => 'Annullare l\'abbonamento?';

  @override
  String ifYouCancelTodayPremiumAccess(String date) {
    return 'Se annulli oggi, il tuo accesso Premium rimarrà attivo fino al $date.\n\nFacci sapere perché stai andando via:';
  }

  @override
  String get tooExpensive => 'Troppo costoso';

  @override
  String get notGettingEnoughClientRequests =>
      'Non ricevo abbastanza richieste dai clienti';

  @override
  String get usingADifferentPlatform => 'Uso una piattaforma diversa';

  @override
  String get other => 'Altro';

  @override
  String get stayWithUsGet20Off =>
      'Resta con noi! Ottieni il 20% di sconto sul prossimo ciclo di fatturazione invece di annullare.';

  @override
  String get keepMySubscription => 'Mantieni il mio abbonamento';

  @override
  String get confirmCancellation => 'Conferma annullamento';

  @override
  String get pleaseCancelViaStore =>
      'Annulla tramite la pagina abbonamenti di Google Play o App Store.';

  @override
  String get bio => 'Biografia';

  @override
  String get writeSomethingAboutYourself => 'Scrivi qualcosa su di te...';

  @override
  String get pricePerHour => 'Prezzo all\'ora';

  @override
  String get experience => 'Esperienza';

  @override
  String get selectExperience => 'Seleziona esperienza';

  @override
  String get specialties => 'Specialità';

  @override
  String get otherTasksOffered => 'Altre attività offerte';

  @override
  String get workSchedule => 'Orario di lavoro';

  @override
  String get whenAreYouAvailable =>
      'Quando sei disponibile per offrire i tuoi servizi?';

  @override
  String get monday => 'Lunedì';

  @override
  String get tuesday => 'Martedì';

  @override
  String get wednesday => 'Mercoledì';

  @override
  String get thursday => 'Giovedì';

  @override
  String get friday => 'Venerdì';

  @override
  String get saturday => 'Sabato';

  @override
  String get sunday => 'Domenica';

  @override
  String get available => 'Disponibile';

  @override
  String get notAvailable => 'Non disponibile';

  @override
  String get confirm => 'Conferma';

  @override
  String get pleaseUploadAnImage =>
      'Carica un\'immagine per ogni opzione selezionata.';

  @override
  String get ifYouAlreadySubmitARequest =>
      'Se hai già inviato una richiesta, accedi con un altro account';

  @override
  String get preferences => 'Preferenze';

  @override
  String get myWorkAreas => 'Le mie aree di lavoro';

  @override
  String get currentLocationMap => 'Mappa posizione attuale';

  @override
  String get next => 'Avanti';

  @override
  String get pleaseSelectYourRole => 'Seleziona il tuo ruolo';

  @override
  String get micAndCameraPermissionsRequired =>
      'Sono necessari i permessi per microfono e fotocamera';

  @override
  String get userIsBusyOrUnavailable =>
      'L\'utente è occupato o non disponibile';

  @override
  String get paymentSuccessful => 'Pagamento riuscito';

  @override
  String get accessLocked => 'ACCESSO BLOCCATO';

  @override
  String get subscriptionRequired => 'Abbonamento richiesto';

  @override
  String get startFreeTrialToReceiveRequests =>
      'Inizia la prova gratuita di 30 giorni per ricevere e gestire le richieste dei clienti.';

  @override
  String get startFreeTrial => 'Inizia la prova gratuita';

  @override
  String get youCanStillManageProfile =>
      'Puoi ancora gestire il tuo profilo, i servizi e il programma.';

  @override
  String get tryIumiProviderFree => 'Prova IUMI Provider gratis';

  @override
  String get unlockEveryFeature =>
      'Sblocca tutte le funzionalità provider per 30 giorni.';

  @override
  String get thirtyDaysFree => '30 GIORNI GRATIS';

  @override
  String get receiveCustomerRequests => 'Ricevi richieste dai clienti';

  @override
  String get acceptOrDeclineBookings => 'Accetta o rifiuta prenotazioni';

  @override
  String get contactCustomersAfterAcceptance =>
      'Contatta i clienti dopo l\'accettazione';

  @override
  String get manageYourSchedule => 'Gestisci il tuo programma';

  @override
  String get freeFor30Days => 'Gratis per 30 giorni';

  @override
  String get then4999RonMonthCancelAnytime =>
      'Poi 49,99 RON/mese. Annulla quando vuoi.';

  @override
  String get start30DayFreeTrial => 'Inizia la prova gratuita di 30 giorni';

  @override
  String get upgradePremium => 'Passa a Premium';

  @override
  String get notNow => 'Non ora';

  @override
  String get noPaymentToday =>
      'Nessun pagamento oggi. Funziona su iOS, Android e web.';

  @override
  String get somethingWentWrong => 'Qualcosa è andato storto';

  @override
  String get seeMore => 'Vedi di più';

  @override
  String get documents => 'Documenti';

  @override
  String get chooseYourPlan => 'Scegli il tuo piano';

  @override
  String get noPlansAvailable => 'Nessun piano disponibile al momento.';

  @override
  String get checkBackLater => 'Riprova più tardi o contatta il supporto.';

  @override
  String get upgradeToPremium => 'Passa a Premium';

  @override
  String get unlockAllFeatures =>
      'Sblocca tutte le funzionalità e fai crescere la tua attività.';

  @override
  String savePercent(String percent) {
    return 'Risparmia il $percent%';
  }

  @override
  String get alreadySubscribed => 'Sei già iscritto a questo piano.';

  @override
  String get planNotAvailable =>
      'Questo piano non è ancora disponibile per l\'acquisto su questa piattaforma. Riprova più tardi.';

  @override
  String successfullySubscribed(String planName) {
    return 'Abbonato con successo a $planName!';
  }

  @override
  String get subscribeNow => 'Abbonati ora';

  @override
  String get messageSentSuccessfully =>
      'Il tuo messaggio è stato inviato con successo.';

  @override
  String get failedToSendMessage =>
      'Impossibile inviare il messaggio. Riprova.';

  @override
  String get pleaseSelectDocument =>
      'Si prega di selezionare almeno un documento per procedere.';

  @override
  String get documentsUpdatedSuccessfully =>
      'Documenti aggiornati con successo';

  @override
  String get pleaseEnterValidPricePerHour =>
      'Inserisci un prezzo valido all\'ora';

  @override
  String get listingUpdatedSuccessfully => 'Annuncio aggiornato con successo';

  @override
  String get failedToSubmitReview => 'Impossibile inviare la recensione';

  @override
  String get reviewSubmittedSuccessfully => 'Recensione inviata con successo';

  @override
  String get failedToSaveSchedule =>
      'Impossibile salvare il programma. Riprova.';

  @override
  String get pleaseFillOutAllFields => 'Si prega di compilare tutti i campi.';

  @override
  String get pleaseSelectFlexibleStartTime =>
      'Seleziona un orario di inizio flessibile o usa \'Ignora\'.';

  @override
  String get outstanding => 'Eccezionale';

  @override
  String get hello => 'Ciao';

  @override
  String get description => 'Descrizione';

  @override
  String get copyrightIBadi => 'Copyright iBadi';

  @override
  String get badi => 'Badi';

  @override
  String get download => 'Scarica';

  @override
  String get end => 'Fine';

  @override
  String get markAllRead => 'Segna tutto come letto';

  @override
  String get goBack => 'Torna indietro';

  @override
  String get iumiAdminSupport => 'Supporto Admin Iumi';

  @override
  String get emailAddress => 'Indirizzo email';

  @override
  String get subject => 'Oggetto';

  @override
  String get yourMessage => 'Il tuo messaggio';

  @override
  String get sayHello => 'Saluta 👋';

  @override
  String get chooseOption => 'Scegli un\'opzione';

  @override
  String get settings => 'Impostazioni';

  @override
  String get completePayment => 'Completa il pagamento';

  @override
  String get noMessages => 'Nessun messaggio';

  @override
  String get noNotification => 'Nessuna notifica';

  @override
  String get noScheduleAvailable => 'Nessun programma disponibile.';

  @override
  String get additionalComments => 'Commenti aggiuntivi';

  @override
  String get gallery => 'Galleria';

  @override
  String get failedToLoadGallery => 'Impossibile caricare la galleria';

  @override
  String get noImagesAvailable => 'Nessuna immagine disponibile';

  @override
  String get viewGallery => 'Vedi galleria';

  @override
  String get noGalleryImageFound => 'Nessuna immagine nella galleria';

  @override
  String get comments => 'Commenti';

  @override
  String get noCommentsFound => 'Nessun commento trovato';

  @override
  String get serviceFrequency => 'Frequenza del servizio';

  @override
  String get howManyTimesDoYouWantTheService =>
      'Quante volte vuoi il servizio?';

  @override
  String get rateYourExperience => 'Valuta la tua esperienza';

  @override
  String get deleteThisAddress => 'Eliminare questo indirizzo?';

  @override
  String get showSpecialistsIn => 'Mostra specialisti in:';

  @override
  String get ok => 'OK';

  @override
  String get chooseFromGallery => 'Scegli dalla galleria';

  @override
  String get takeAPhoto => 'Scatta una foto';

  @override
  String get profilePicture => 'Foto profilo';

  @override
  String get doYouWantToGoBack => 'Vuoi tornare indietro?';

  @override
  String get startYour30DayFreeTrialToReceiveAndManageCustomerRequests =>
      'Inizia la prova gratuita di 30 giorni per ricevere e gestire le richieste dei clienti.';

  @override
  String get youCanStillManageYourProfileServicesAndSchedule =>
      'Puoi ancora gestire il tuo profilo, i servizi e il programma.';
}
