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
  String get calendar => 'Calendar';

  @override
  String get service => 'Serviciu';

  @override
  String get favourites => 'Favorite';

  @override
  String get notification => 'Notificare';

  @override
  String get inbox => 'Mesaje';

  @override
  String get minimumPriceSavedSuccessfully =>
      'Prețul minim a fost salvat cu succes';

  @override
  String get minimumPriceTitle => 'Preț minim';

  @override
  String get minimumPriceQuestion =>
      'Care este prețul minim pe care un client trebuie să-l plătească pentru a rezerva serviciul tău?  +info';

  @override
  String get minimumPriceLabel => 'Preț minim:';

  @override
  String get minimumPriceTip =>
      'Acest lucru va evita să fii rezervat pentru un preț atât de mic încât să nu merite timpul tău pentru a te deplasa la serviciu';

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

  @override
  String get accountSettings => 'Setări cont';

  @override
  String get personalDetails => 'Date personale';

  @override
  String get myAddresses => 'Adresele mele';

  @override
  String get paymentsAndRefunds => 'Plăți și rambursări';

  @override
  String get mySubscription => 'Abonamentul meu';

  @override
  String get myListing => 'Anunțul meu';

  @override
  String get mySchedule => 'Programul meu';

  @override
  String get minimumBookingAmount => 'Suma minimă de rezervare';

  @override
  String get myReview => 'Recenzia mea';

  @override
  String get addFaq => 'Adaugă FAQ';

  @override
  String get changePassword => 'Schimbă parola';

  @override
  String get language => 'Limbă';

  @override
  String get aboutUs => 'Despre noi';

  @override
  String get termsAndConditions => 'Termeni și condiții';

  @override
  String get privacyPolicy => 'Politica de confidențialitate';

  @override
  String get logout => 'Deconectare';

  @override
  String get failedToLoadProfile => 'Eșec la încărcarea profilului';

  @override
  String get pullToRefresh => 'Trage pentru a reîmprospăta';

  @override
  String get areYouSureToLogout => 'Ești sigur că vrei să te deconectezi?';

  @override
  String get cancel => 'Anulează';

  @override
  String get notConnected => 'Neconectat';

  @override
  String get connected => 'Conectat';

  @override
  String stripe(String status) {
    return 'Stripe : $status';
  }

  @override
  String get areYouSureToDeleteAccount => 'Ești sigur că vrei să ștergi?';

  @override
  String get profileUpdatedSuccessfully => 'Profil actualizat cu succes';

  @override
  String failedToUpdateProfile(String message) {
    return 'Eșec la actualizarea profilului: $message';
  }

  @override
  String failedToDeleteAccount(String message) {
    return 'Eșec la ștergerea contului: $message';
  }

  @override
  String get fullName => 'Nume complet';

  @override
  String get aboutMe => 'Despre mine';

  @override
  String get searchYourAddress => 'Caută adresa ta…';

  @override
  String get phoneNumber => 'Număr de telefon';

  @override
  String get deleteAccountPermanently => 'Șterge contul definitiv';

  @override
  String get yesDelete => 'DA, ȘTERGE';

  @override
  String get noDontDelete => 'NU, NU ȘTERGE';

  @override
  String get myAddress => 'Adresa mea';

  @override
  String get yourAddresses => 'Adresele tale';

  @override
  String get retry => 'Reîncearcă';

  @override
  String get noAddresses => 'Nicio adresă';

  @override
  String get addYourFirstAddressBelow => 'Adaugă prima ta adresă mai jos';

  @override
  String get addNewAddress => 'Adaugă adresă nouă';

  @override
  String get defaultAddressUpdated => 'Adresa implicită actualizată';

  @override
  String get defaultString => 'Implicit';

  @override
  String addressLabel(String address) {
    return 'Adresă: $address';
  }

  @override
  String get setAsDefault => 'Setează ca implicit';

  @override
  String get edit => 'Editează';

  @override
  String get delete => 'Șterge';

  @override
  String get areYouSureToDelete => 'Ești sigur că vrei să ștergi?';

  @override
  String get thisAddressWillBeRemoved =>
      'Această adresă va fi eliminată permanent.';

  @override
  String get pleaseSearchAndSelectAddress =>
      'Te rugăm să cauți și să selectezi o adresă mai întâi.';

  @override
  String get editAddress => 'Editează adresa';

  @override
  String get addAddress => 'Adaugă adresă';

  @override
  String get searchAddress => 'Caută adresă';

  @override
  String latLng(String lat, String lng) {
    return 'Lat: $lat, Lng: $lng';
  }

  @override
  String get reviewAndAdjust => 'Verifică și ajustează dacă e necesar';

  @override
  String get addressLine1 => 'Linia de adresă 1 *';

  @override
  String get streetNumberAndName => 'Număr și nume stradă';

  @override
  String get required => 'Obligatoriu';

  @override
  String get addressLine2 => 'Linia de adresă 2';

  @override
  String get areaNeighbourhood => 'Zonă / cartier (opțional)';

  @override
  String get city => 'Oraș';

  @override
  String get state => 'Stat';

  @override
  String get postalCode => 'Cod poștal';

  @override
  String get postal => 'Poștal';

  @override
  String get country => 'Țară';

  @override
  String get updateAddress => 'Actualizează adresa';

  @override
  String get saveAddress => 'Salvează adresa';

  @override
  String get myCards => 'Cardurile mele';

  @override
  String get addNew => 'Adaugă';

  @override
  String get failedToGetAddCardLink =>
      'Eșec la obținerea linkului de adăugare card';

  @override
  String get noCardsFound => 'Niciun card găsit';

  @override
  String get cardDeletedSuccessfully => 'Card șters cu succes';

  @override
  String get setAsDefaultCardSuccessfully => 'Card implicit setat cu succes';

  @override
  String get failedToSetDefaultCard => 'Eșec la setarea cardului implicit';

  @override
  String get setAsDefaultCard => 'Setează ca card implicit';

  @override
  String get myBalance => 'Soldul meu';

  @override
  String get availableBalance => 'Sold disponibil';

  @override
  String get paymentAndRefunds => 'Plăți și rambursări';

  @override
  String get paymentMethods => 'Metode de plată';

  @override
  String get myBooking => 'Rezervarea mea';

  @override
  String paidOn(String date) {
    return 'Plătit pe $date';
  }

  @override
  String serviceDate(String date) {
    return 'Data serviciului: $date';
  }

  @override
  String get passwordChangedSuccessfully => 'Parola a fost schimbată cu succes';

  @override
  String get currentPassword => 'Parola curentă';

  @override
  String get oldPassword => 'Parola veche';

  @override
  String get enterOldPassword => 'Introdu parola veche';

  @override
  String get newPassword => 'Parolă nouă';

  @override
  String get confirmNewPassword => 'Confirmă noua parolă';

  @override
  String get confirmPassword => 'Confirmă parola';

  @override
  String get faqAddedSuccessfully => 'FAQ a fost adăugat cu succes';

  @override
  String get question => 'Întrebare';

  @override
  String get enterYourQuestion => 'Introdu întrebarea ta';

  @override
  String get pleaseEnterQuestion => 'Te rugăm să introduci o întrebare';

  @override
  String get answer => 'Răspuns';

  @override
  String get enterYourAnswer => 'Introdu răspunsul tău';

  @override
  String get pleaseEnterAnswer => 'Te rugăm să introduci un răspuns';

  @override
  String get submitFaq => 'Trimite FAQ';

  @override
  String get reviews => 'Recenzii';

  @override
  String get noReviewsFound => 'Nicio recenzie găsită';

  @override
  String get noContentAvailable => 'Niciun conținut disponibil.';

  @override
  String get tryAgain => 'Încearcă din nou';

  @override
  String get createAccountBtn => 'Creează cont';

  @override
  String get logIn => 'Autentifică-te';

  @override
  String get continueAsGuest => 'Continuă ca oaspete';

  @override
  String get whatWillYouDoOnIumi => 'Ce vei face pe iumi?';

  @override
  String get roleDecisionNotFinal =>
      'Această decizie nu este definitivă. Poți fi atât client cât și profesionist mai târziu.';

  @override
  String get bookAService => 'Rezervă un serviciu';

  @override
  String get iAmAClient => 'Sunt client';

  @override
  String get offerServices => 'Oferă servicii';

  @override
  String get iAmAProfessional => 'Sunt profesionist';

  @override
  String get createAccountTitle => 'Creează cont';

  @override
  String get enterYourName => 'Introduceți numele';

  @override
  String get enterEmail => 'Introduceți emailul';

  @override
  String get password => 'Parolă';

  @override
  String get serviceLocation => 'Locația serviciului';

  @override
  String get yourLocation => 'Locația ta';

  @override
  String get searchAndSelectServiceArea =>
      'Caută și selectează zona ta de serviciu pentru ca clienții să te găsească.';

  @override
  String get weUseLocationForServices =>
      'Folosim locația ta pentru a-ți arăta servicii relevante în apropiere.';

  @override
  String get searchCitySuburbAddress => 'Caută oraș, cartier sau adresă...';

  @override
  String get acceptTermsPrivacy =>
      'Prin crearea unui cont, accept Termenii și Condițiile și confirm că am citit Politica de Confidențialitate';

  @override
  String get termsAndCondition => 'Termeni și Condiții';

  @override
  String get pleaseAcceptTerms =>
      'Te rugăm să accepți termenii și condițiile pentru a continua';

  @override
  String get haveAccountLogin => 'Ai un cont? Autentifică-te';

  @override
  String get login => 'Autentificare';

  @override
  String get forgotPassword => 'Ai uitat parola?';

  @override
  String get enterEmailSendOtp =>
      'Introduceți emailul și vă vom trimite un OTP de resetare.';

  @override
  String get enterYourEmail => 'Introduceți emailul';

  @override
  String get sendOtp => 'Trimite OTP';

  @override
  String get otpVerifiedSuccessfully => 'OTP verificat cu succes';

  @override
  String get otpResentSuccessfully => 'OTP retrimis cu succes';

  @override
  String get verifyOtp => 'Verifică OTP';

  @override
  String enterOtpSentTo(String email) {
    return 'Introduceți OTP-ul trimis la $email';
  }

  @override
  String get enterTheOtp => 'Introduceți OTP-ul';

  @override
  String get verify => 'Verifică';

  @override
  String get didNotReceiveOtpResend => 'Nu ai primit OTP-ul? Retrimite';

  @override
  String get resend => 'Retrimite';

  @override
  String resendOtpInSeconds(int seconds) {
    return 'Retrimite OTP în ${seconds}s';
  }

  @override
  String get passwordResetSuccessfully =>
      'Parola resetată cu succes. Te rugăm să te autentifici.';

  @override
  String get resetPassword => 'Resetează parola';

  @override
  String get continueWithGoogle => 'Continuă cu Google';

  @override
  String get or => 'sau';

  @override
  String get loginWithEmail => 'Autentifică-te cu email';

  @override
  String get createWithEmail => 'Creează cu email';

  @override
  String get weValueYourPrivacy => 'Respectăm confidențialitatea ta';

  @override
  String get cookiePolicyMsg =>
      'Webel folosește cookie-uri pentru a analiza performanța campaniilor publicitare, pentru a îmbunătăți reclamele și pentru a personaliza experiența.';

  @override
  String get accept => 'Acceptă';

  @override
  String get serviceAddress => 'Adresa serviciului';

  @override
  String get selectWhereYouWantToReceiveService =>
      'Selectează unde dorești să primești serviciul';

  @override
  String get support => 'Suport';

  @override
  String get call => 'Apelează';

  @override
  String get phoneNumberCopied => 'Număr de telefon copiat în clipboard';

  @override
  String get message => 'Mesaj';

  @override
  String get emailCopied => 'Email copiat în clipboard';

  @override
  String get verificationPending => 'Verificare în așteptare';

  @override
  String get verificationPendingDesc =>
      'Contul tău este în așteptarea verificării. Unele funcții pot fi limitate.';

  @override
  String get refresh => 'Reîmprospătează';

  @override
  String get whenDoYouNeedIt => 'Când ai nevoie?';

  @override
  String get frequency => 'Frecvență';

  @override
  String get justOnce => 'Doar o dată';

  @override
  String get oneTime => 'O singură dată';

  @override
  String get weekly => 'Săptămânal';

  @override
  String get recurring => 'Recurent';

  @override
  String get daysOfTheWeek => 'Ziua/zilele din săptămână';

  @override
  String get startTime => 'Ora de început';

  @override
  String get flexibleStart => 'Început flexibil';

  @override
  String get exactStart => 'Început exact';

  @override
  String get morning => 'Dimineață';

  @override
  String get evening => 'Seară';

  @override
  String get selectExactTime => 'Selectează ora exactă';

  @override
  String get skip => 'Omite';

  @override
  String get search => 'Caută';

  @override
  String get back => 'Înapoi';

  @override
  String get clearFilters => 'Șterge filtrele';

  @override
  String get palliativeCare => 'Îngrijire paliativă';

  @override
  String get palliativeCareDesc =>
      'Arată doar profesioniștii specializați în îngrijire paliativă.';

  @override
  String get drivingLicence => 'Permis de conducere';

  @override
  String get drivingLicenceDesc =>
      'Arată doar profesioniștii cu permis de conducere';

  @override
  String get businessProfiles => 'Profile de afaceri';

  @override
  String get businessProfilesDesc =>
      'Doar profiluri care corespund unei afaceri sau profesionist independent validat.';

  @override
  String get qualifiedCarer => 'Îngrijitor calificat';

  @override
  String get qualifiedCarerDesc =>
      'Arată doar îngrijitorii cu calificare, diplomă sau grad ca personal medical';

  @override
  String get priceRange => 'Interval de preț';

  @override
  String get hourlyRate => 'Tarif orar';

  @override
  String get maxPriceWillingToPay =>
      'Prețul maxim pe care ești dispus să-l plătești.';

  @override
  String get experienceLevel => 'Nivel de experiență';

  @override
  String get specificTasksRequirements => 'Sarcini specifice / Cerințe';

  @override
  String get updatedSuccessfully => 'Actualizat cu succes';

  @override
  String get images => 'Imagini';

  @override
  String get coverImage => 'Imagine de copertă';

  @override
  String get galleryImages => 'Imagini galerie';

  @override
  String get add => 'Adaugă';

  @override
  String get palliativeCareImage => 'Imagine îngrijire paliativă';

  @override
  String get drivingLicenceImage => 'Imagine permis de conducere';

  @override
  String get businessProfileImage => 'Imagine profil de afaceri';

  @override
  String get qualificationCertificate => 'Certificat de calificare';

  @override
  String get submit => 'Trimite';

  @override
  String get update => 'Actualizează';

  @override
  String get applyFilters => 'Aplică filtrele';

  @override
  String get verificationSubmitted => 'Verificare trimisă';

  @override
  String get verificationSubmittedDesc =>
      'Cererea ta a fost trimisă cu succes.\n\nTe rugăm să te autentifici din nou cu alt cont.';

  @override
  String get findTheServiceYouNeed => 'Găsește serviciul de care ai nevoie';

  @override
  String get mostPopularInYourArea => 'Cele mai populare în zona ta';

  @override
  String get searchResults => 'Rezultate căutare';

  @override
  String get noServicesFound => 'Niciun serviciu găsit';

  @override
  String get tryADifferentSearchTerm => 'Încearcă un alt termen de căutare';

  @override
  String get howDoesTheServiceWork => 'Cum funcționează serviciul?';

  @override
  String get finding => 'Căutare ';

  @override
  String get professionals => 'profesioniști';

  @override
  String get whenQuestion => 'Când?';

  @override
  String get filters => 'Filtre';

  @override
  String get howDoesTheServiceWorkTitle =>
      'Cum funcționează serviciul de îngrijire a persoanelor în vârstă?';

  @override
  String get noFaqsAvailable => 'Nicio FAQ disponibilă';

  @override
  String get bookingAccepted => 'Rezervare acceptată';

  @override
  String get comment => 'Comentariu';

  @override
  String get serviceBookedSuccess =>
      'Serviciu rezervat cu succes pentru îngrijirea persoanelor în vârstă.';

  @override
  String get dateAndTime => 'Data și ora';

  @override
  String get address => 'Adresă';

  @override
  String get servicePrice => 'Prețul serviciului';

  @override
  String get complete => 'Finalizează';

  @override
  String get bookingHasBeenCompleted => 'Această rezervare a fost finalizată';

  @override
  String get customer => 'Client:';

  @override
  String get provider => 'Furnizor:';

  @override
  String cantChatBeforeAction(String action) {
    return 'Nu poți discuta înainte de a $action rezervarea';
  }

  @override
  String get accepting => 'accepta';

  @override
  String get creating => 'crea';

  @override
  String failedToLoadChat(String message) {
    return 'Eșec la încărcarea chatului: $message';
  }

  @override
  String get serviceText => 'Serviciu';

  @override
  String get bookingHours => 'Ore rezervare';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get clientProtection => 'Protecția clientului';

  @override
  String get total => 'Total';

  @override
  String get free => 'Gratuit';

  @override
  String get details => 'Detalii';

  @override
  String get noDataFound => 'Nicio dată găsită';

  @override
  String get addressNotAvailable => 'Adresă indisponibilă';

  @override
  String addressCoordsLabel(String lat, String lng) {
    return 'Adresă: Lat: $lat, Lng: $lng';
  }

  @override
  String get congratulations => 'Felicitări';

  @override
  String get congratulationsDesc =>
      'Felicitări pentru atingerea acestui jalon în cariera ta profesională!';

  @override
  String get done => 'Gata';

  @override
  String get setUpAtLeastOneDay => 'Configurează cel puțin o zi';

  @override
  String get selectATimeSlot => 'Selectează un interval orar';

  @override
  String get bookingDotDot => 'Rezervare…';

  @override
  String continueForAmountPerWeek(String price) {
    return 'Continuă pentru \$$price/săptămână';
  }

  @override
  String bookForAmount(String price) {
    return 'Rezervă pentru \$$price';
  }

  @override
  String get couldNotLoadAvailableSlots =>
      'Nu s-au putut încărca intervalele disponibile. Atinge Reîncearcă.';

  @override
  String get noAvailableSlotsForDuration =>
      'Niciun interval disponibil pentru această durată.';

  @override
  String get selectATime => 'Selectează o oră';

  @override
  String saveTimeDuration(String start, String end, String duration) {
    return 'Salvează $start - $end · ${duration}h';
  }

  @override
  String get chat => 'Chat';

  @override
  String get history => 'Istoric';

  @override
  String get alerts => 'Alerte';

  @override
  String get newAlerts => 'Alerte noi';

  @override
  String get searchFriends => 'Caută prieteni';

  @override
  String get noUnreadAlerts => 'Nicio alertă necitită';

  @override
  String get paymentPending => 'Plată în așteptare';

  @override
  String get pendingAcceptance => 'Acceptare în așteptare';

  @override
  String get payNow => 'Plătește acum';

  @override
  String get pending => 'În așteptare';

  @override
  String get serviceInProgress => 'Serviciu în desfășurare';

  @override
  String get rating => 'Evaluare';

  @override
  String get needSupportImmediately => 'Ai nevoie de suport imediat';

  @override
  String get manageSubscription => 'Gestionează abonamentul';

  @override
  String get subscriptionStatus => 'Stare abonament';

  @override
  String freeTrialDaysLeft(String daysLeft) {
    return 'Perioadă de probă de 30 de zile ($daysLeft zile rămase)';
  }

  @override
  String get cancelledActiveTillPeriodEnd =>
      'Anulat (Activ până la sfârșitul perioadei)';

  @override
  String get activePremium => 'Premium activ';

  @override
  String get expired => 'Expirat';

  @override
  String get currentPlan => 'Plan curent';

  @override
  String get subscriptionPrice => 'Preț abonament';

  @override
  String get activationDate => 'Data activării';

  @override
  String get nextBillingRenewal => 'Următoarea facturare / Reînnoire';

  @override
  String get purchasePlatform => 'Platformă achiziție';

  @override
  String get annualPremium => 'Premium anual';

  @override
  String get monthlyPremium => 'Premium lunar';

  @override
  String get noSubscriptionPurchased => 'Niciun abonament achiziționat';

  @override
  String get yourValueThisMonth => 'Valoarea ta luna aceasta';

  @override
  String thisMonthRequestsBookings(String requests, String bookings) {
    return 'Luna aceasta ai primit $requests cereri și ai acceptat $bookings rezervări.';
  }

  @override
  String get requestsReceived => 'Cereri primite';

  @override
  String get bookingsAccepted => 'Rezervări acceptate';

  @override
  String get acceptanceRate => 'Rata de acceptare';

  @override
  String get upgradeToPremiumNow => 'Treci la Premium acum';

  @override
  String get restorePurchase => 'Restaurează achiziția';

  @override
  String get subscriptionRestoredSuccessfully =>
      'Abonament restaurat cu succes!';

  @override
  String get noActiveSubscriptionFoundToRestore =>
      'Niciun abonament activ găsit pentru restaurare.';

  @override
  String get cancelSubscription => 'Anulează abonamentul';

  @override
  String get cancelSubscriptionQuestion => 'Anulezi abonamentul?';

  @override
  String ifYouCancelTodayPremiumAccess(String date) {
    return 'Dacă anulezi azi, accesul tău Premium va rămâne activ până la $date.\n\nTe rugăm să ne spui de ce pleci:';
  }

  @override
  String get tooExpensive => 'Prea scump';

  @override
  String get notGettingEnoughClientRequests =>
      'Nu primesc suficiente cereri de la clienți';

  @override
  String get usingADifferentPlatform => 'Folosesc o altă platformă';

  @override
  String get other => 'Altele';

  @override
  String get stayWithUsGet20Off =>
      'Rămâi cu noi! Primești 20% REDUCERE la următorul ciclu de facturare în loc să anulezi.';

  @override
  String get keepMySubscription => 'Păstrează abonamentul';

  @override
  String get confirmCancellation => 'Confirmă anularea';

  @override
  String get pleaseCancelViaStore =>
      'Te rugăm să anulezi prin pagina de abonamente Google Play sau App Store.';

  @override
  String get bio => 'Biografie';

  @override
  String get writeSomethingAboutYourself => 'Scrie ceva despre tine...';

  @override
  String get pricePerHour => 'Preț pe oră';

  @override
  String get experience => 'Experiență';

  @override
  String get selectExperience => 'Selectează experiența';

  @override
  String get specialties => 'Specialități';

  @override
  String get otherTasksOffered => 'Alte sarcini oferite';

  @override
  String get workSchedule => 'Program de lucru';

  @override
  String get whenAreYouAvailable =>
      'Când ești disponibil pentru a oferi serviciile tale?';

  @override
  String get monday => 'Luni';

  @override
  String get tuesday => 'Marți';

  @override
  String get wednesday => 'Miercuri';

  @override
  String get thursday => 'Joi';

  @override
  String get friday => 'Vineri';

  @override
  String get saturday => 'Sâmbătă';

  @override
  String get sunday => 'Duminică';

  @override
  String get available => 'Disponibil';

  @override
  String get notAvailable => 'Indisponibil';

  @override
  String get confirm => 'Confirmă';

  @override
  String get pleaseUploadAnImage =>
      'Te rugăm să încarci o imagine pentru fiecare opțiune selectată.';

  @override
  String get ifYouAlreadySubmitARequest =>
      'Dacă ai trimis deja o cerere, te rugăm să te autentifici cu alt cont';

  @override
  String get preferences => 'Preferințe';

  @override
  String get myWorkAreas => 'Zonele mele de lucru';

  @override
  String get currentLocationMap => 'Hartă locație curentă';

  @override
  String get next => 'Următor';

  @override
  String get pleaseSelectYourRole => 'Te rugăm să selectezi rolul tău';

  @override
  String get micAndCameraPermissionsRequired =>
      'Sunt necesare permisiunile microfonului și camerei';

  @override
  String get userIsBusyOrUnavailable =>
      'Utilizatorul este ocupat sau indisponibil';

  @override
  String get paymentSuccessful => 'Plată reușită';

  @override
  String get accessLocked => 'ACCES BLOCAT';

  @override
  String get subscriptionRequired => 'Abonament necesar';

  @override
  String get startFreeTrialToReceiveRequests =>
      'Începe perioada de probă gratuită de 30 de zile pentru a primi și gestiona cererile clienților.';

  @override
  String get startFreeTrial => 'Începe perioada de probă gratuită';

  @override
  String get youCanStillManageProfile =>
      'Poți gestiona în continuare profilul, serviciile și programul tău.';

  @override
  String get tryIumiProviderFree => 'Încearcă IUMI Provider gratuit';

  @override
  String get unlockEveryFeature =>
      'Deblochează toate funcțiile de furnizor timp de 30 de zile.';

  @override
  String get thirtyDaysFree => '30 DE ZILE GRATUIT';

  @override
  String get receiveCustomerRequests => 'Primește cereri de la clienți';

  @override
  String get acceptOrDeclineBookings => 'Acceptă sau refuză rezervări';

  @override
  String get contactCustomersAfterAcceptance =>
      'Contactează clienții după acceptare';

  @override
  String get manageYourSchedule => 'Gestionează-ți programul';

  @override
  String get freeFor30Days => 'Gratuit timp de 30 de zile';

  @override
  String get then4999RonMonthCancelAnytime =>
      'Apoi 49,99 RON/lună. Anulează oricând.';

  @override
  String get start30DayFreeTrial => 'Începe perioada de probă de 30 de zile';

  @override
  String get upgradePremium => 'Treci la Premium';

  @override
  String get notNow => 'Nu acum';

  @override
  String get noPaymentToday =>
      'Nicio plată azi. Funcționează pe iOS, Android și web.';

  @override
  String get somethingWentWrong => 'Ceva nu a mers bine';

  @override
  String get seeMore => 'Vezi mai mult';

  @override
  String get documents => 'Documente';

  @override
  String get chooseYourPlan => 'Alege planul tău';

  @override
  String get noPlansAvailable => 'Niciun plan disponibil momentan.';

  @override
  String get checkBackLater =>
      'Te rugăm să revii mai târziu sau să contactezi suportul.';

  @override
  String get upgradeToPremium => 'Treci la Premium';

  @override
  String get unlockAllFeatures =>
      'Deblochează toate funcțiile și crește-ți afacerea.';

  @override
  String savePercent(String percent) {
    return 'Economisește $percent%';
  }

  @override
  String get alreadySubscribed => 'Ești deja abonat la acest plan.';

  @override
  String get planNotAvailable =>
      'Acest plan nu este încă disponibil pe această platformă. Te rugăm să încerci mai târziu.';

  @override
  String successfullySubscribed(String planName) {
    return 'Te-ai abonat cu succes la $planName!';
  }

  @override
  String get subscribeNow => 'Abonează-te acum';

  @override
  String get messageSentSuccessfully => 'Mesajul tău a fost trimis cu succes.';

  @override
  String get failedToSendMessage =>
      'Nu am putut trimite mesajul. Te rugăm să încerci din nou.';

  @override
  String get pleaseSelectDocument =>
      'Te rugăm să selectezi cel puțin un document pentru a continua.';

  @override
  String get documentsUpdatedSuccessfully => 'Documente actualizate cu succes';

  @override
  String get pleaseEnterValidPricePerHour =>
      'Te rugăm să introduci un preț valabil pe oră';

  @override
  String get listingUpdatedSuccessfully => 'Anunț actualizat cu succes';

  @override
  String get failedToSubmitReview => 'Eșec la trimiterea recenziei';

  @override
  String get reviewSubmittedSuccessfully => 'Recenzie trimisă cu succes';

  @override
  String get failedToSaveSchedule =>
      'Eșec la salvarea programului. Încearcă din nou.';

  @override
  String get pleaseFillOutAllFields =>
      'Te rugăm să completezi toate câmpurile.';

  @override
  String get pleaseSelectFlexibleStartTime =>
      'Te rugăm să selectezi un interval orar flexibil de început sau folosește \'Omite\'.';

  @override
  String get outstanding => 'Remarcabil';

  @override
  String get hello => 'Bună';

  @override
  String get description => 'Descriere';

  @override
  String get copyrightIBadi => 'Copyright iBadi';

  @override
  String get badi => 'Badi';

  @override
  String get download => 'Descarcă';

  @override
  String get end => 'Sfârșit';

  @override
  String get markAllRead => 'Marchează tot ca citit';

  @override
  String get goBack => 'Înapoi';

  @override
  String get iumiAdminSupport => 'Suport Admin Iumi';

  @override
  String get emailAddress => 'Adresă email';

  @override
  String get subject => 'Subiect';

  @override
  String get yourMessage => 'Mesajul tău';

  @override
  String get sayHello => 'Spune bună 👋';

  @override
  String get chooseOption => 'Alege opțiunea';

  @override
  String get settings => 'Setări';

  @override
  String get completePayment => 'Finalizează plata';

  @override
  String get noMessages => 'Niciun mesaj';

  @override
  String get noNotification => 'Nicio notificare';

  @override
  String get noScheduleAvailable => 'Niciun program disponibil.';

  @override
  String get additionalComments => 'Comentarii suplimentare';

  @override
  String get gallery => 'Galerie';

  @override
  String get failedToLoadGallery => 'Eșec la încărcarea galeriei';

  @override
  String get noImagesAvailable => 'Nicio imagine disponibilă';

  @override
  String get viewGallery => 'Vezi galeria';

  @override
  String get noGalleryImageFound => 'Nicio imagine în galerie';

  @override
  String get comments => 'Comentarii';

  @override
  String get noCommentsFound => 'Niciun comentariu găsit';

  @override
  String get serviceFrequency => 'Frecvența serviciului';

  @override
  String get howManyTimesDoYouWantTheService =>
      'De câte ori dorești serviciul?';

  @override
  String get rateYourExperience => 'Evaluează-ți experiența';

  @override
  String get deleteThisAddress => 'Ștergi această adresă?';

  @override
  String get showSpecialistsIn => 'Arată specialiști în:';

  @override
  String get ok => 'OK';

  @override
  String get chooseFromGallery => 'Alege din galerie';

  @override
  String get takeAPhoto => 'Fă o poză';

  @override
  String get profilePicture => 'Poză de profil';

  @override
  String get doYouWantToGoBack => 'Vrei să te întorci?';

  @override
  String get startYour30DayFreeTrialToReceiveAndManageCustomerRequests =>
      'Începe perioada de probă gratuită de 30 de zile pentru a primi și gestiona cererile clienților.';

  @override
  String get youCanStillManageYourProfileServicesAndSchedule =>
      'Poți gestiona în continuare profilul, serviciile și programul tău.';
}
