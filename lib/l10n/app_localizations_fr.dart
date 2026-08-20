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
  String get calendar => 'Calendrier';

  @override
  String get service => 'Service';

  @override
  String get favourites => 'Favoris';

  @override
  String get notification => 'Notification';

  @override
  String get inbox => 'Boîte de réception';

  @override
  String get minimumPriceSavedSuccessfully =>
      'Prix minimum enregistré avec succès';

  @override
  String get minimumPriceTitle => 'Prix minimum';

  @override
  String get minimumPriceQuestion =>
      'Quel est le prix minimum qu\'un client doit payer pour réserver votre service ?  +info';

  @override
  String get minimumPriceLabel => 'Prix minimum :';

  @override
  String get minimumPriceTip =>
      'Cela évitera d\'être réservé pour un prix si bas qu\'il ne vaut pas votre temps de vous déplacer pour le service';

  @override
  String get upcomingBookings => 'Réservations à venir';

  @override
  String get dateFilter => 'Filtre de date';

  @override
  String get noBookingsFound => 'Aucune réservation trouvée';

  @override
  String get request => 'Demande';

  @override
  String get completed => 'Terminé';

  @override
  String get ongoing => 'En cours';

  @override
  String get cancelled => 'Annulé';

  @override
  String get completedServices => 'Services terminés';

  @override
  String get accountSettings => 'Paramètres du compte';

  @override
  String get personalDetails => 'Informations personnelles';

  @override
  String get myAddresses => 'Mes adresses';

  @override
  String get paymentsAndRefunds => 'Paiements et remboursements';

  @override
  String get mySubscription => 'Mon abonnement';

  @override
  String get myListing => 'Mon annonce';

  @override
  String get mySchedule => 'Mon planning';

  @override
  String get minimumBookingAmount => 'Montant minimum de réservation';

  @override
  String get myReview => 'Mon avis';

  @override
  String get addFaq => 'Ajouter FAQ';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get language => 'Langue';

  @override
  String get aboutUs => 'À propos de nous';

  @override
  String get termsAndConditions => 'Termes et conditions';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get failedToLoadProfile => 'Échec du chargement du profil';

  @override
  String get pullToRefresh => 'Tirer pour actualiser';

  @override
  String get areYouSureToLogout =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get notConnected => 'Non connecté';

  @override
  String get connected => 'Connecté';

  @override
  String stripe(String status) {
    return 'Stripe : $status';
  }

  @override
  String get areYouSureToDeleteAccount =>
      'Êtes-vous sûr de vouloir supprimer ?';

  @override
  String get profileUpdatedSuccessfully => 'Profil mis à jour avec succès';

  @override
  String failedToUpdateProfile(String message) {
    return 'Échec de la mise à jour du profil : $message';
  }

  @override
  String failedToDeleteAccount(String message) {
    return 'Échec de la suppression du compte : $message';
  }

  @override
  String get fullName => 'Nom complet';

  @override
  String get aboutMe => 'À propos de moi';

  @override
  String get searchYourAddress => 'Recherchez votre adresse…';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get deleteAccountPermanently => 'Supprimer le compte définitivement';

  @override
  String get yesDelete => 'OUI, SUPPRIMER';

  @override
  String get noDontDelete => 'NON, NE PAS SUPPRIMER';

  @override
  String get myAddress => 'Mon adresse';

  @override
  String get yourAddresses => 'Vos adresses';

  @override
  String get retry => 'Réessayer';

  @override
  String get noAddresses => 'Aucune adresse';

  @override
  String get addYourFirstAddressBelow =>
      'Ajoutez votre première adresse ci-dessous';

  @override
  String get addNewAddress => 'Ajouter une nouvelle adresse';

  @override
  String get defaultAddressUpdated => 'Adresse par défaut mise à jour';

  @override
  String get defaultString => 'Par défaut';

  @override
  String addressLabel(String address) {
    return 'Adresse : $address';
  }

  @override
  String get setAsDefault => 'Définir par défaut';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get areYouSureToDelete => 'Êtes-vous sûr de vouloir supprimer ?';

  @override
  String get thisAddressWillBeRemoved =>
      'Cette adresse sera définitivement supprimée.';

  @override
  String get pleaseSearchAndSelectAddress =>
      'Veuillez d\'abord rechercher et sélectionner une adresse.';

  @override
  String get editAddress => 'Modifier l\'adresse';

  @override
  String get addAddress => 'Ajouter une adresse';

  @override
  String get searchAddress => 'Rechercher une adresse';

  @override
  String latLng(String lat, String lng) {
    return 'Lat : $lat, Lng : $lng';
  }

  @override
  String get reviewAndAdjust => 'Vérifier et ajuster si nécessaire';

  @override
  String get addressLine1 => 'Ligne d\'adresse 1 *';

  @override
  String get streetNumberAndName => 'Numéro et nom de rue';

  @override
  String get required => 'Obligatoire';

  @override
  String get addressLine2 => 'Ligne d\'adresse 2';

  @override
  String get areaNeighbourhood => 'Quartier / zone (optionnel)';

  @override
  String get city => 'Ville';

  @override
  String get state => 'État';

  @override
  String get postalCode => 'Code postal';

  @override
  String get postal => 'Postal';

  @override
  String get country => 'Pays';

  @override
  String get updateAddress => 'Mettre à jour l\'adresse';

  @override
  String get saveAddress => 'Enregistrer l\'adresse';

  @override
  String get myCards => 'Mes cartes';

  @override
  String get addNew => 'Ajouter';

  @override
  String get failedToGetAddCardLink =>
      'Échec de l\'obtention du lien d\'ajout de carte';

  @override
  String get noCardsFound => 'Aucune carte trouvée';

  @override
  String get cardDeletedSuccessfully => 'Carte supprimée avec succès';

  @override
  String get setAsDefaultCardSuccessfully =>
      'Carte par défaut définie avec succès';

  @override
  String get failedToSetDefaultCard =>
      'Échec de la définition de la carte par défaut';

  @override
  String get setAsDefaultCard => 'Définir comme carte par défaut';

  @override
  String get myBalance => 'Mon solde';

  @override
  String get availableBalance => 'Solde disponible';

  @override
  String get paymentAndRefunds => 'Paiements et remboursements';

  @override
  String get paymentMethods => 'Méthodes de paiement';

  @override
  String get myBooking => 'Ma réservation';

  @override
  String paidOn(String date) {
    return 'Payé le $date';
  }

  @override
  String serviceDate(String date) {
    return 'Date du service : $date';
  }

  @override
  String get passwordChangedSuccessfully => 'Mot de passe changé avec succès';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get oldPassword => 'Ancien mot de passe';

  @override
  String get enterOldPassword => 'Entrez l\'ancien mot de passe';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmNewPassword => 'Confirmer le nouveau mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get faqAddedSuccessfully => 'FAQ ajoutée avec succès';

  @override
  String get question => 'Question';

  @override
  String get enterYourQuestion => 'Entrez votre question';

  @override
  String get pleaseEnterQuestion => 'Veuillez entrer une question';

  @override
  String get answer => 'Réponse';

  @override
  String get enterYourAnswer => 'Entrez votre réponse';

  @override
  String get pleaseEnterAnswer => 'Veuillez entrer une réponse';

  @override
  String get submitFaq => 'Soumettre FAQ';

  @override
  String get reviews => 'Avis';

  @override
  String get noReviewsFound => 'Aucun avis trouvé';

  @override
  String get noContentAvailable => 'Aucun contenu disponible.';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get createAccountBtn => 'Créer un compte';

  @override
  String get logIn => 'Se connecter';

  @override
  String get continueAsGuest => 'Continuer en tant qu\'invité';

  @override
  String get whatWillYouDoOnIumi => 'Que ferez-vous sur iumi ?';

  @override
  String get roleDecisionNotFinal =>
      'Cette décision n\'est pas définitive. Vous pourrez être à la fois client et professionnel plus tard.';

  @override
  String get bookAService => 'Réserver un service';

  @override
  String get iAmAClient => 'Je suis client';

  @override
  String get offerServices => 'Offrir des services';

  @override
  String get iAmAProfessional => 'Je suis professionnel';

  @override
  String get createAccountTitle => 'Créer un compte';

  @override
  String get enterYourName => 'Entrez votre nom';

  @override
  String get enterEmail => 'Entrez votre e-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get serviceLocation => 'Lieu du service';

  @override
  String get yourLocation => 'Votre emplacement';

  @override
  String get searchAndSelectServiceArea =>
      'Recherchez et sélectionnez votre zone de service pour que les clients puissent vous trouver.';

  @override
  String get weUseLocationForServices =>
      'Nous utilisons votre emplacement pour vous montrer les services pertinents à proximité.';

  @override
  String get searchCitySuburbAddress =>
      'Rechercher ville, quartier ou adresse...';

  @override
  String get acceptTermsPrivacy =>
      'En créant un compte, j\'accepte les Conditions Générales et confirme avoir lu la Politique de Confidentialité';

  @override
  String get termsAndCondition => 'Conditions Générales';

  @override
  String get pleaseAcceptTerms =>
      'Veuillez accepter les conditions générales pour continuer';

  @override
  String get haveAccountLogin => 'Vous avez un compte ? Se connecter';

  @override
  String get login => 'Connexion';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get enterEmailSendOtp =>
      'Entrez votre e-mail et nous vous enverrons un OTP de réinitialisation.';

  @override
  String get enterYourEmail => 'Entrez votre e-mail';

  @override
  String get sendOtp => 'Envoyer OTP';

  @override
  String get otpVerifiedSuccessfully => 'OTP vérifié avec succès';

  @override
  String get otpResentSuccessfully => 'OTP renvoyé avec succès';

  @override
  String get verifyOtp => 'Vérifier OTP';

  @override
  String enterOtpSentTo(String email) {
    return 'Entrez l\'OTP envoyé à $email';
  }

  @override
  String get enterTheOtp => 'Entrez l\'OTP';

  @override
  String get verify => 'Vérifier';

  @override
  String get didNotReceiveOtpResend => 'OTP non reçu ? Renvoyer';

  @override
  String get resend => 'Renvoyer';

  @override
  String resendOtpInSeconds(int seconds) {
    return 'Renvoyer OTP dans ${seconds}s';
  }

  @override
  String get passwordResetSuccessfully =>
      'Mot de passe réinitialisé avec succès. Veuillez vous connecter.';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get or => 'ou';

  @override
  String get loginWithEmail => 'Se connecter avec e-mail';

  @override
  String get createWithEmail => 'Créer avec e-mail';

  @override
  String get weValueYourPrivacy => 'Nous respectons votre vie privée';

  @override
  String get cookiePolicyMsg =>
      'Webel utilise des cookies pour analyser les performances publicitaires, améliorer les annonces et personnaliser l\'expérience selon les préférences.';

  @override
  String get accept => 'Accepter';

  @override
  String get serviceAddress => 'Adresse du service';

  @override
  String get selectWhereYouWantToReceiveService =>
      'Sélectionnez où vous souhaitez recevoir le service';

  @override
  String get support => 'Support';

  @override
  String get call => 'Appeler';

  @override
  String get phoneNumberCopied =>
      'Numéro de téléphone copié dans le presse-papiers';

  @override
  String get message => 'Message';

  @override
  String get emailCopied => 'E-mail copié dans le presse-papiers';

  @override
  String get verificationPending => 'Vérification en attente';

  @override
  String get verificationPendingDesc =>
      'Votre compte est en attente de vérification. Certaines fonctionnalités peuvent être limitées.';

  @override
  String get refresh => 'Actualiser';

  @override
  String get whenDoYouNeedIt => 'Quand en avez-vous besoin ?';

  @override
  String get frequency => 'Fréquence';

  @override
  String get justOnce => 'Juste une fois';

  @override
  String get oneTime => 'Ponctuel';

  @override
  String get weekly => 'Hebdomadaire';

  @override
  String get recurring => 'Récurrent';

  @override
  String get daysOfTheWeek => 'Jour(s) de la semaine';

  @override
  String get startTime => 'Heure de début';

  @override
  String get flexibleStart => 'Début flexible';

  @override
  String get exactStart => 'Début exact';

  @override
  String get morning => 'Matin';

  @override
  String get evening => 'Soir';

  @override
  String get selectExactTime => 'Sélectionner l\'heure exacte';

  @override
  String get skip => 'Ignorer';

  @override
  String get search => 'Rechercher';

  @override
  String get back => 'Retour';

  @override
  String get clearFilters => 'Effacer les filtres';

  @override
  String get palliativeCare => 'Soins palliatifs';

  @override
  String get palliativeCareDesc =>
      'Afficher uniquement les professionnels spécialisés en soins palliatifs.';

  @override
  String get drivingLicence => 'Permis de conduire';

  @override
  String get drivingLicenceDesc =>
      'Afficher uniquement les professionnels avec un permis de conduire';

  @override
  String get businessProfiles => 'Profils professionnels';

  @override
  String get businessProfilesDesc =>
      'Uniquement les profils correspondant à une entreprise ou un professionnel indépendant validé.';

  @override
  String get qualifiedCarer => 'Soignant qualifié';

  @override
  String get qualifiedCarerDesc =>
      'Afficher uniquement les soignants avec une qualification, un diplôme en tant que personnel de santé';

  @override
  String get priceRange => 'Fourchette de prix';

  @override
  String get hourlyRate => 'Tarif horaire';

  @override
  String get maxPriceWillingToPay => 'Prix maximum que vous êtes prêt à payer.';

  @override
  String get experienceLevel => 'Niveau d\'expérience';

  @override
  String get specificTasksRequirements => 'Tâches spécifiques / Exigences';

  @override
  String get updatedSuccessfully => 'Mis à jour avec succès';

  @override
  String get images => 'Images';

  @override
  String get coverImage => 'Image de couverture';

  @override
  String get galleryImages => 'Images de la galerie';

  @override
  String get add => 'Ajouter';

  @override
  String get palliativeCareImage => 'Image soins palliatifs';

  @override
  String get drivingLicenceImage => 'Image permis de conduire';

  @override
  String get businessProfileImage => 'Image profil professionnel';

  @override
  String get qualificationCertificate => 'Certificat de qualification';

  @override
  String get submit => 'Soumettre';

  @override
  String get update => 'Mettre à jour';

  @override
  String get applyFilters => 'Appliquer les filtres';

  @override
  String get verificationSubmitted => 'Vérification soumise';

  @override
  String get verificationSubmittedDesc =>
      'Votre demande a été soumise avec succès.\n\nVeuillez vous reconnecter avec un autre compte.';

  @override
  String get findTheServiceYouNeed =>
      'Trouvez le service dont vous avez besoin';

  @override
  String get mostPopularInYourArea => 'Les plus populaires dans votre région';

  @override
  String get searchResults => 'Résultats de recherche';

  @override
  String get noServicesFound => 'Aucun service trouvé';

  @override
  String get tryADifferentSearchTerm => 'Essayez un autre terme de recherche';

  @override
  String get howDoesTheServiceWork => 'Comment fonctionne le service ?';

  @override
  String get finding => 'Recherche de ';

  @override
  String get professionals => 'professionnels';

  @override
  String get whenQuestion => 'Quand ?';

  @override
  String get filters => 'Filtres';

  @override
  String get howDoesTheServiceWorkTitle =>
      'Comment fonctionne le service de soins aux personnes âgées ?';

  @override
  String get noFaqsAvailable => 'Aucune FAQ disponible';

  @override
  String get bookingAccepted => 'Réservation acceptée';

  @override
  String get comment => 'Commentaire';

  @override
  String get serviceBookedSuccess =>
      'Service réservé avec succès pour les soins aux personnes âgées. Veuillez vous assurer que l\'assistance comprend des contrôles quotidiens, des rappels de médicaments et une aide à la mobilité.';

  @override
  String get dateAndTime => 'Date et heure';

  @override
  String get address => 'Adresse';

  @override
  String get servicePrice => 'Prix du service';

  @override
  String get complete => 'Terminer';

  @override
  String get bookingHasBeenCompleted => 'Cette réservation a été terminée';

  @override
  String get customer => 'Client :';

  @override
  String get provider => 'Prestataire :';

  @override
  String cantChatBeforeAction(String action) {
    return 'Vous ne pouvez pas chatter avant d\'$action la réservation';
  }

  @override
  String get accepting => 'accepter';

  @override
  String get creating => 'créer';

  @override
  String failedToLoadChat(String message) {
    return 'Échec du chargement du chat : $message';
  }

  @override
  String get serviceText => 'Service';

  @override
  String get bookingHours => 'Heures de réservation';

  @override
  String get subtotal => 'Sous-total';

  @override
  String get clientProtection => 'Protection client';

  @override
  String get total => 'Total';

  @override
  String get free => 'Gratuit';

  @override
  String get details => 'Détails';

  @override
  String get noDataFound => 'Aucune donnée trouvée';

  @override
  String get addressNotAvailable => 'Adresse non disponible';

  @override
  String addressCoordsLabel(String lat, String lng) {
    return 'Adresse : Lat : $lat, Lng : $lng';
  }

  @override
  String get congratulations => 'Félicitations';

  @override
  String get congratulationsDesc =>
      'Félicitations pour cette étape de votre parcours professionnel ! Votre dévouement, votre expertise et votre travail acharné sont vraiment remarquables.';

  @override
  String get done => 'Terminé';

  @override
  String get setUpAtLeastOneDay => 'Configurez au moins un jour';

  @override
  String get selectATimeSlot => 'Sélectionnez un créneau horaire';

  @override
  String get bookingDotDot => 'Réservation…';

  @override
  String continueForAmountPerWeek(String price) {
    return 'Continuer pour \$$price/semaine';
  }

  @override
  String bookForAmount(String price) {
    return 'Réserver pour \$$price';
  }

  @override
  String get couldNotLoadAvailableSlots =>
      'Impossible de charger les créneaux disponibles. Appuyez sur Réessayer.';

  @override
  String get noAvailableSlotsForDuration =>
      'Aucun créneau disponible pour cette durée.';

  @override
  String get selectATime => 'Sélectionnez une heure';

  @override
  String saveTimeDuration(String start, String end, String duration) {
    return 'Enregistrer $start - $end · ${duration}h';
  }

  @override
  String get chat => 'Chat';

  @override
  String get history => 'Historique';

  @override
  String get alerts => 'Alertes';

  @override
  String get newAlerts => 'Nouvelles alertes';

  @override
  String get searchFriends => 'Rechercher des amis';

  @override
  String get noUnreadAlerts => 'Aucune alerte non lue';

  @override
  String get paymentPending => 'Paiement en attente';

  @override
  String get pendingAcceptance => 'En attente d\'acceptation';

  @override
  String get payNow => 'Payer maintenant';

  @override
  String get pending => 'En attente';

  @override
  String get serviceInProgress => 'Service en cours';

  @override
  String get rating => 'Évaluation';

  @override
  String get needSupportImmediately => 'Besoin d\'aide immédiatement';

  @override
  String get manageSubscription => 'Gérer l\'abonnement';

  @override
  String get subscriptionStatus => 'Statut de l\'abonnement';

  @override
  String freeTrialDaysLeft(String daysLeft) {
    return 'Essai gratuit de 30 jours ($daysLeft jours restants)';
  }

  @override
  String get cancelledActiveTillPeriodEnd =>
      'Annulé (Actif jusqu\'à la fin de la période)';

  @override
  String get activePremium => 'Premium actif';

  @override
  String get expired => 'Expiré';

  @override
  String get currentPlan => 'Forfait actuel';

  @override
  String get subscriptionPrice => 'Prix de l\'abonnement';

  @override
  String get activationDate => 'Date d\'activation';

  @override
  String get nextBillingRenewal => 'Prochaine facturation / Renouvellement';

  @override
  String get purchasePlatform => 'Plateforme d\'achat';

  @override
  String get annualPremium => 'Premium annuel';

  @override
  String get monthlyPremium => 'Premium mensuel';

  @override
  String get noSubscriptionPurchased => 'Aucun abonnement acheté';

  @override
  String get yourValueThisMonth => 'Votre valeur ce mois-ci';

  @override
  String thisMonthRequestsBookings(String requests, String bookings) {
    return 'Ce mois-ci, vous avez reçu $requests demandes et accepté $bookings réservations.';
  }

  @override
  String get requestsReceived => 'Demandes reçues';

  @override
  String get bookingsAccepted => 'Réservations acceptées';

  @override
  String get acceptanceRate => 'Taux d\'acceptation';

  @override
  String get upgradeToPremiumNow => 'Passer au Premium maintenant';

  @override
  String get restorePurchase => 'Restaurer l\'achat';

  @override
  String get subscriptionRestoredSuccessfully =>
      'Abonnement restauré avec succès !';

  @override
  String get noActiveSubscriptionFoundToRestore =>
      'Aucun abonnement actif trouvé à restaurer.';

  @override
  String get cancelSubscription => 'Annuler l\'abonnement';

  @override
  String get cancelSubscriptionQuestion => 'Annuler l\'abonnement ?';

  @override
  String ifYouCancelTodayPremiumAccess(String date) {
    return 'Si vous annulez aujourd\'hui, votre accès Premium restera actif jusqu\'au $date.\n\nVeuillez nous dire pourquoi vous partez :';
  }

  @override
  String get tooExpensive => 'Trop cher';

  @override
  String get notGettingEnoughClientRequests =>
      'Pas assez de demandes de clients';

  @override
  String get usingADifferentPlatform => 'J\'utilise une autre plateforme';

  @override
  String get other => 'Autre';

  @override
  String get stayWithUsGet20Off =>
      'Restez avec nous ! Obtenez 20% de réduction sur votre prochain cycle de facturation au lieu d\'annuler.';

  @override
  String get keepMySubscription => 'Garder mon abonnement';

  @override
  String get confirmCancellation => 'Confirmer l\'annulation';

  @override
  String get pleaseCancelViaStore =>
      'Veuillez annuler via votre page d\'abonnements Google Play ou App Store.';

  @override
  String get bio => 'Biographie';

  @override
  String get writeSomethingAboutYourself => 'Écrivez quelque chose sur vous...';

  @override
  String get pricePerHour => 'Prix de l\'heure';

  @override
  String get experience => 'Expérience';

  @override
  String get selectExperience => 'Sélectionner l\'expérience';

  @override
  String get specialties => 'Spécialités';

  @override
  String get otherTasksOffered => 'Autres tâches proposées';

  @override
  String get workSchedule => 'Horaire de travail';

  @override
  String get whenAreYouAvailable =>
      'Quand êtes-vous disponible pour offrir vos services ?';

  @override
  String get monday => 'Lundi';

  @override
  String get tuesday => 'Mardi';

  @override
  String get wednesday => 'Mercredi';

  @override
  String get thursday => 'Jeudi';

  @override
  String get friday => 'Vendredi';

  @override
  String get saturday => 'Samedi';

  @override
  String get sunday => 'Dimanche';

  @override
  String get available => 'Disponible';

  @override
  String get notAvailable => 'Non disponible';

  @override
  String get confirm => 'Confirmer';

  @override
  String get pleaseUploadAnImage =>
      'Veuillez télécharger une image pour chaque option sélectionnée.';

  @override
  String get ifYouAlreadySubmitARequest =>
      'Si vous avez déjà soumis une demande, veuillez vous connecter avec un autre compte';

  @override
  String get preferences => 'Préférences';

  @override
  String get myWorkAreas => 'Mes zones de travail';

  @override
  String get currentLocationMap => 'Carte de localisation actuelle';

  @override
  String get next => 'Suivant';

  @override
  String get pleaseSelectYourRole => 'Veuillez sélectionner votre rôle';

  @override
  String get micAndCameraPermissionsRequired =>
      'Les permissions du microphone et de la caméra sont requises';

  @override
  String get userIsBusyOrUnavailable =>
      'L\'utilisateur est occupé ou indisponible';

  @override
  String get paymentSuccessful => 'Paiement réussi';

  @override
  String get accessLocked => 'ACCÈS VERROUILLÉ';

  @override
  String get subscriptionRequired => 'Abonnement requis';

  @override
  String get startFreeTrialToReceiveRequests =>
      'Commencez votre essai gratuit de 30 jours pour recevoir et gérer les demandes des clients.';

  @override
  String get startFreeTrial => 'Commencer l\'essai gratuit';

  @override
  String get youCanStillManageProfile =>
      'Vous pouvez toujours gérer votre profil, vos services et votre planning.';

  @override
  String get tryIumiProviderFree => 'Essayez IUMI Provider gratuitement';

  @override
  String get unlockEveryFeature =>
      'Débloquez toutes les fonctionnalités prestataire pendant 30 jours.';

  @override
  String get thirtyDaysFree => '30 JOURS GRATUITS';

  @override
  String get receiveCustomerRequests => 'Recevoir les demandes des clients';

  @override
  String get acceptOrDeclineBookings => 'Accepter ou refuser les réservations';

  @override
  String get contactCustomersAfterAcceptance =>
      'Contacter les clients après acceptation';

  @override
  String get manageYourSchedule => 'Gérer votre planning';

  @override
  String get freeFor30Days => 'Gratuit pendant 30 jours';

  @override
  String get then4999RonMonthCancelAnytime =>
      'Puis 49,99 RON/mois. Annulez à tout moment.';

  @override
  String get start30DayFreeTrial => 'Commencer l\'essai gratuit de 30 jours';

  @override
  String get upgradePremium => 'Passer à Premium';

  @override
  String get notNow => 'Pas maintenant';

  @override
  String get noPaymentToday =>
      'Aucun paiement aujourd\'hui. Fonctionne sur iOS, Android et web.';

  @override
  String get somethingWentWrong => 'Quelque chose s\'est mal passé';

  @override
  String get seeMore => 'Voir plus';

  @override
  String get documents => 'Documents';

  @override
  String get chooseYourPlan => 'Choisissez votre forfait';

  @override
  String get noPlansAvailable => 'Aucun forfait disponible pour le moment.';

  @override
  String get checkBackLater =>
      'Veuillez revenir plus tard ou contacter l\'assistance.';

  @override
  String get upgradeToPremium => 'Passer au Premium';

  @override
  String get unlockAllFeatures =>
      'Débloquez toutes les fonctionnalités et développez votre activité.';

  @override
  String savePercent(String percent) {
    return 'Économisez $percent%';
  }

  @override
  String get alreadySubscribed => 'Vous êtes déjà abonné à ce forfait.';

  @override
  String get planNotAvailable =>
      'Ce forfait n\'est pas encore disponible sur cette plateforme. Veuillez réessayer plus tard.';

  @override
  String successfullySubscribed(String planName) {
    return 'Abonnement réussi à $planName !';
  }

  @override
  String get subscribeNow => 'S\'abonner maintenant';

  @override
  String get messageSentSuccessfully =>
      'Votre message a été envoyé avec succès.';

  @override
  String get failedToSendMessage =>
      'Échec de l\'envoi du message. Veuillez réessayer.';

  @override
  String get pleaseSelectDocument =>
      'Veuillez sélectionner au moins un document pour continuer.';

  @override
  String get documentsUpdatedSuccessfully => 'Documents mis à jour avec succès';

  @override
  String get pleaseEnterValidPricePerHour =>
      'Veuillez entrer un prix valide par heure';

  @override
  String get listingUpdatedSuccessfully => 'Annonce mise à jour avec succès';

  @override
  String get failedToSubmitReview => 'Échec de la soumission de l\'avis';

  @override
  String get reviewSubmittedSuccessfully => 'Avis soumis avec succès';

  @override
  String get failedToSaveSchedule =>
      'Échec de l\'enregistrement de l\'horaire. Réessayez.';

  @override
  String get pleaseFillOutAllFields => 'Veuillez remplir tous les champs.';

  @override
  String get pleaseSelectFlexibleStartTime =>
      'Veuillez sélectionner une heure de début flexible ou utiliser \'Ignorer\'.';

  @override
  String get outstanding => 'Exceptionnel';

  @override
  String get hello => 'Bonjour';

  @override
  String get description => 'Description';

  @override
  String get copyrightIBadi => 'Copyright iBadi';

  @override
  String get badi => 'Badi';

  @override
  String get download => 'Télécharger';

  @override
  String get end => 'Fin';

  @override
  String get markAllRead => 'Tout marquer comme lu';

  @override
  String get goBack => 'Retour';

  @override
  String get iumiAdminSupport => 'Support Admin Iumi';

  @override
  String get emailAddress => 'Adresse e-mail';

  @override
  String get subject => 'Objet';

  @override
  String get yourMessage => 'Votre message';

  @override
  String get sayHello => 'Dites bonjour 👋';

  @override
  String get chooseOption => 'Choisir une option';

  @override
  String get settings => 'Paramètres';

  @override
  String get completePayment => 'Finaliser le paiement';

  @override
  String get noMessages => 'Aucun message';

  @override
  String get noNotification => 'Aucune notification';

  @override
  String get noScheduleAvailable => 'Aucun planning disponible.';

  @override
  String get additionalComments => 'Commentaires supplémentaires';

  @override
  String get gallery => 'Galerie';

  @override
  String get failedToLoadGallery => 'Échec du chargement de la galerie';

  @override
  String get noImagesAvailable => 'Aucune image disponible';

  @override
  String get viewGallery => 'Voir la galerie';

  @override
  String get noGalleryImageFound => 'Aucune image de galerie trouvée';

  @override
  String get comments => 'Commentaires';

  @override
  String get noCommentsFound => 'Aucun commentaire trouvé';

  @override
  String get serviceFrequency => 'Fréquence du service';

  @override
  String get howManyTimesDoYouWantTheService =>
      'Combien de fois souhaitez-vous le service ?';

  @override
  String get rateYourExperience => 'Évaluez votre expérience';

  @override
  String get deleteThisAddress => 'Supprimer cette adresse ?';

  @override
  String get showSpecialistsIn => 'Afficher les spécialistes dans :';

  @override
  String get ok => 'OK';

  @override
  String get chooseFromGallery => 'Choisir dans la galerie';

  @override
  String get takeAPhoto => 'Prendre une photo';

  @override
  String get profilePicture => 'Photo de profil';

  @override
  String get doYouWantToGoBack => 'Voulez-vous revenir en arrière ?';

  @override
  String get startYour30DayFreeTrialToReceiveAndManageCustomerRequests =>
      'Commencez votre essai gratuit de 30 jours pour recevoir et gérer les demandes des clients.';

  @override
  String get youCanStillManageYourProfileServicesAndSchedule =>
      'Vous pouvez toujours gérer votre profil, vos services et votre planning.';
}
