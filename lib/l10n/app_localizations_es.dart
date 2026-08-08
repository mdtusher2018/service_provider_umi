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
  String get calendar => 'Calendario';

  @override
  String get service => 'Servicio';

  @override
  String get favourites => 'Favoritos';

  @override
  String get notification => 'Notificación';

  @override
  String get inbox => 'Mensajes';

  @override
  String get minimumPriceSavedSuccessfully =>
      'Precio mínimo guardado con éxito';

  @override
  String get minimumPriceTitle => 'Precio mínimo';

  @override
  String get minimumPriceQuestion =>
      '¿Cuál es el precio mínimo que debe pagar un cliente para reservar su servicio?  +info';

  @override
  String get minimumPriceLabel => 'Precio mínimo:';

  @override
  String get minimumPriceTip =>
      'Esto evitará que se reserve por un precio tan bajo que no valga la pena el tiempo de desplazamiento para el servicio';

  @override
  String get upcomingBookings => 'Próximas Reservas';

  @override
  String get dateFilter => 'Filtro de Fecha';

  @override
  String get noBookingsFound => 'No se encontraron reservas';

  @override
  String get request => 'Solicitud';

  @override
  String get completed => 'Completado';

  @override
  String get ongoing => 'En curso';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get completedServices => 'Servicios Completados';

  @override
  String get accountSettings => 'Configuración de la Cuenta';

  @override
  String get personalDetails => 'Detalles Personales';

  @override
  String get myAddresses => 'My addresses';

  @override
  String get paymentsAndRefunds => 'Payments and refunds';

  @override
  String get mySubscription => 'Mi Suscripción';

  @override
  String get myListing => 'Mi Anuncio';

  @override
  String get mySchedule => 'Mi Horario';

  @override
  String get minimumBookingAmount => 'Monto Mínimo de Reserva';

  @override
  String get myReview => 'Mis Reseñas';

  @override
  String get addFaq => 'Añadir Preguntas Frecuentes';

  @override
  String get changePassword => 'Cambiar Contraseña';

  @override
  String get language => 'Idioma';

  @override
  String get aboutUs => 'Sobre Nosotros';

  @override
  String get termsAndConditions => 'Términos y Condiciones';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get failedToLoadProfile => 'Failed to load profile';

  @override
  String get pullToRefresh => 'Pull to refresh';

  @override
  String get areYouSureToLogout =>
      '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get notConnected => 'No Conectado';

  @override
  String get connected => 'Conectado';

  @override
  String stripe(String status) {
    return 'Stripe: $status';
  }

  @override
  String get areYouSureToDeleteAccount =>
      '¿Estás seguro de eliminar la cuenta?';

  @override
  String get profileUpdatedSuccessfully => 'Perfil actualizado exitosamente';

  @override
  String failedToUpdateProfile(String message) {
    return 'Error al actualizar el perfil: $message';
  }

  @override
  String failedToDeleteAccount(String message) {
    return 'Error al eliminar la cuenta: $message';
  }

  @override
  String get fullName => 'Nombre completo';

  @override
  String get aboutMe => 'Sobre mí';

  @override
  String get searchYourAddress => 'Busca tu dirección…';

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String get deleteAccountPermanently => 'Eliminar cuenta permanentemente';

  @override
  String get yesDelete => 'Sí, eliminar';

  @override
  String get noDontDelete => 'No, no eliminar';

  @override
  String get myAddress => 'My Address';

  @override
  String get yourAddresses => 'Your Addresses';

  @override
  String get retry => 'Retry';

  @override
  String get noAddresses => 'No addresses';

  @override
  String get addYourFirstAddressBelow => 'Add your first address below';

  @override
  String get addNewAddress => 'Add New Address';

  @override
  String get defaultAddressUpdated => 'Default address updated';

  @override
  String get defaultString => 'Default';

  @override
  String addressLabel(String address) {
    return 'Address: $address';
  }

  @override
  String get setAsDefault => 'Set as Default';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get areYouSureToDelete => 'Are you sure you want to delete?';

  @override
  String get thisAddressWillBeRemoved =>
      'This address will be permanently removed.';

  @override
  String get pleaseSearchAndSelectAddress =>
      'Please search and select an address first.';

  @override
  String get editAddress => 'Edit Address';

  @override
  String get addAddress => 'Add address';

  @override
  String get searchAddress => 'Search Address';

  @override
  String latLng(String lat, String lng) {
    return 'Lat: $lat,  Lng: $lng';
  }

  @override
  String get reviewAndAdjust => 'Review & adjust if needed';

  @override
  String get addressLine1 => 'Address Line 1 *';

  @override
  String get streetNumberAndName => 'Street number & name';

  @override
  String get required => 'Required';

  @override
  String get addressLine2 => 'Address Line 2';

  @override
  String get areaNeighbourhood => 'Area / neighbourhood (optional)';

  @override
  String get city => 'City';

  @override
  String get state => 'State';

  @override
  String get postalCode => 'Postal Code';

  @override
  String get postal => 'Postal';

  @override
  String get country => 'Country';

  @override
  String get updateAddress => 'Update Address';

  @override
  String get saveAddress => 'Save Address';

  @override
  String get myCards => 'My Cards';

  @override
  String get addNew => 'Add New';

  @override
  String get failedToGetAddCardLink => 'Failed to get add card link';

  @override
  String get noCardsFound => 'No cards found';

  @override
  String get cardDeletedSuccessfully => 'Card deleted successfully';

  @override
  String get setAsDefaultCardSuccessfully => 'Set as default card successfully';

  @override
  String get failedToSetDefaultCard => 'Failed to set default card';

  @override
  String get setAsDefaultCard => 'Set as Default Card';

  @override
  String get myBalance => 'My Balance';

  @override
  String get availableBalance => 'Available balance';

  @override
  String get paymentAndRefunds => 'Payment and refunds';

  @override
  String get paymentMethods => 'Payments methods';

  @override
  String get myBooking => 'My booking';

  @override
  String paidOn(String date) {
    return 'Paid on $date';
  }

  @override
  String serviceDate(String date) {
    return 'Service date: $date';
  }

  @override
  String get passwordChangedSuccessfully => 'Password changed successfully';

  @override
  String get currentPassword => 'Current password';

  @override
  String get oldPassword => 'Old password';

  @override
  String get enterOldPassword => 'Enter old password';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get faqAddedSuccessfully => 'FAQ added successfully';

  @override
  String get question => 'Question';

  @override
  String get enterYourQuestion => 'Enter your question';

  @override
  String get pleaseEnterQuestion => 'Please enter a question';

  @override
  String get answer => 'Answer';

  @override
  String get enterYourAnswer => 'Enter your answer';

  @override
  String get pleaseEnterAnswer => 'Please enter an answer';

  @override
  String get submitFaq => 'Submit FAQ';

  @override
  String get reviews => 'Reviews';

  @override
  String get noReviewsFound => 'No reviews found';

  @override
  String get noContentAvailable => 'No content available.';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get createAccountBtn => 'Create Account';

  @override
  String get logIn => 'Log in';

  @override
  String get continueAsGuest => 'Continue as a guest';

  @override
  String get whatWillYouDoOnIumi => 'What will you do on iumi?';

  @override
  String get roleDecisionNotFinal =>
      'This decision is not final. You can later be both a client\nand a professional from the account if you wish.';

  @override
  String get bookAService => 'Book a service';

  @override
  String get iAmAClient => 'I am a Client';

  @override
  String get offerServices => 'Offer services';

  @override
  String get iAmAProfessional => 'I am a Professional';

  @override
  String get createAccountTitle => 'Create account';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get enterEmail => 'Enter email';

  @override
  String get password => 'Password';

  @override
  String get serviceLocation => 'Service location';

  @override
  String get yourLocation => 'Your Location';

  @override
  String get searchAndSelectServiceArea =>
      'Search and select your service area so clients can find you.';

  @override
  String get weUseLocationForServices =>
      'We use your location to show you relevant services nearby.';

  @override
  String get searchCitySuburbAddress => 'Search city, suburb or address...';

  @override
  String get acceptTermsPrivacy =>
      'By creating an account, I accept the Terms and Condition and confirm that I have read the Privacy Policy';

  @override
  String get termsAndCondition => 'Terms and Condition';

  @override
  String get pleaseAcceptTerms =>
      'Please accept the Terms and Conditions to proceed';

  @override
  String get haveAccountLogin => 'Do you have an account?  Log in';

  @override
  String get login => 'Login';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get enterEmailSendOtp =>
      'Enter your email and we\'ll send you a reset OTP.';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get otpVerifiedSuccessfully => 'OTP Verified Successfully';

  @override
  String get otpResentSuccessfully => 'OTP resent successfully';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String enterOtpSentTo(String email) {
    return 'Enter the OTP sent to $email';
  }

  @override
  String get enterTheOtp => 'Enter the OTP';

  @override
  String get verify => 'Verify';

  @override
  String get didNotReceiveOtpResend => 'Didn\'t receive OTP?  Resend';

  @override
  String get resend => 'Resend';

  @override
  String resendOtpInSeconds(int seconds) {
    return 'Resend OTP in ${seconds}s';
  }

  @override
  String get passwordResetSuccessfully =>
      'Password reset successfully. Please log in.';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get or => 'or';

  @override
  String get loginWithEmail => 'Login with email';

  @override
  String get createWithEmail => 'Create with email';

  @override
  String get weValueYourPrivacy => 'We value your privacy';

  @override
  String get cookiePolicyMsg =>
      'Webel uses cookies to analyse advertising campaign performance, improve app ads, and personalize the experience based on user preference.';

  @override
  String get accept => 'Aceptar';

  @override
  String get serviceAddress => 'Service address';

  @override
  String get selectWhereYouWantToReceiveService =>
      'Select where you want to receive the service';

  @override
  String get support => 'Support';

  @override
  String get call => 'Call';

  @override
  String get phoneNumberCopied => 'Phone number copied to clipboard';

  @override
  String get message => 'Message';

  @override
  String get emailCopied => 'Email copied to clipboard';

  @override
  String get verificationPending => 'Verification Pending';

  @override
  String get verificationPendingDesc =>
      'Your account is pending verification. Some features may be limited until your account is verified.';

  @override
  String get refresh => 'Refresh';

  @override
  String get whenDoYouNeedIt => 'When do you need it?';

  @override
  String get frequency => 'Frequency';

  @override
  String get justOnce => 'Just once';

  @override
  String get oneTime => 'One-Time';

  @override
  String get weekly => 'Weekly';

  @override
  String get recurring => 'Recurring';

  @override
  String get daysOfTheWeek => 'Day(s) of the week';

  @override
  String get startTime => 'Start time';

  @override
  String get flexibleStart => 'Flexible start';

  @override
  String get exactStart => 'Exact start';

  @override
  String get morning => 'Morning';

  @override
  String get evening => 'Evening';

  @override
  String get selectExactTime => 'Select exact time';

  @override
  String get skip => 'Skip';

  @override
  String get search => 'Search';

  @override
  String get back => 'Back';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get palliativeCare => 'Palliative care';

  @override
  String get palliativeCareDesc =>
      'Only show professionals specialising in palliative care.';

  @override
  String get drivingLicence => 'Driving licence';

  @override
  String get drivingLicenceDesc =>
      'Only show professionals with a driving licence';

  @override
  String get businessProfiles => 'Business profiles';

  @override
  String get businessProfilesDesc =>
      'Only profiles that correspond to a validated business or self employed professional.';

  @override
  String get qualifiedCarer => 'Qualified carer';

  @override
  String get qualifiedCarerDesc =>
      'Only show caregivers with a qualification, diploma or degree as health personal';

  @override
  String get priceRange => 'Price range';

  @override
  String get hourlyRate => 'Hourly rate';

  @override
  String get maxPriceWillingToPay => 'Maximum price you are willing to pay.';

  @override
  String get experienceLevel => 'Experience level';

  @override
  String get specificTasksRequirements => 'Specific tasks / Requirements';

  @override
  String get updatedSuccessfully => 'Updated successfully';

  @override
  String get images => 'Images';

  @override
  String get coverImage => 'Cover Image';

  @override
  String get galleryImages => 'Gallery Images';

  @override
  String get add => 'Add';

  @override
  String get palliativeCareImage => 'Palliative Care Image';

  @override
  String get drivingLicenceImage => 'Driving Licence Image';

  @override
  String get businessProfileImage => 'Business Profile Image';

  @override
  String get qualificationCertificate => 'Qualification Certificate';

  @override
  String get submit => 'Submit';

  @override
  String get update => 'Update';

  @override
  String get applyFilters => 'Apply filters';

  @override
  String get verificationSubmitted => 'Verification Submitted';

  @override
  String get verificationSubmittedDesc =>
      'Your request has been submitted successfully.\n\nPlease login again with another account.';

  @override
  String get findTheServiceYouNeed => 'Find the service you need';

  @override
  String get mostPopularInYourArea => 'Most popular in your area';

  @override
  String get searchResults => 'Search results';

  @override
  String get noServicesFound => 'No services found';

  @override
  String get tryADifferentSearchTerm => 'Try a different search term';

  @override
  String get howDoesTheServiceWork => 'How does the service work?';

  @override
  String get finding => 'Finding ';

  @override
  String get professionals => 'professionals';

  @override
  String get whenQuestion => 'When?';

  @override
  String get filters => 'Filters';

  @override
  String get howDoesTheServiceWorkTitle =>
      'How does the Elderly care\nservice work?';

  @override
  String get noFaqsAvailable => 'No FAQs available';

  @override
  String get bookingAccepted => 'Booking accepted';

  @override
  String get comment => 'Comment';

  @override
  String get serviceBookedSuccess =>
      'Service booked successfully for elder care. Please ensure assistance includes daily check-ins, medication reminders, and help with mobility as discussed.';

  @override
  String get dateAndTime => 'Date and time';

  @override
  String get address => 'Address';

  @override
  String get servicePrice => 'Service price';

  @override
  String get complete => 'Complete';

  @override
  String get bookingHasBeenCompleted => 'This Booking has been Completed';

  @override
  String get customer => 'Customer:';

  @override
  String get provider => 'Provider:';

  @override
  String cantChatBeforeAction(String action) {
    return 'You can\'t chat before $action the booking';
  }

  @override
  String get accepting => 'accepting';

  @override
  String get creating => 'creating';

  @override
  String failedToLoadChat(String message) {
    return 'Failed to load chat: $message';
  }

  @override
  String get serviceText => 'Service';

  @override
  String get bookingHours => 'Booking hours';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get clientProtection => 'Client protection';

  @override
  String get total => 'Total';

  @override
  String get free => 'Free';

  @override
  String get details => 'Details';

  @override
  String get noDataFound => 'No data found';

  @override
  String get addressNotAvailable => 'Address not available';

  @override
  String addressCoordsLabel(String lat, String lng) {
    return 'Address: Lat: $lat, Lng: $lng';
  }

  @override
  String get congratulations => 'Congratulations';

  @override
  String get congratulationsDesc =>
      'Congratulations on achieving this milestone in your professional journey! Your dedication, expertise, and hard work are truly commendable.';

  @override
  String get done => 'Done';

  @override
  String get setUpAtLeastOneDay => 'Set up at least one day';

  @override
  String get selectATimeSlot => 'Select a time slot';

  @override
  String get bookingDotDot => 'Booking…';

  @override
  String continueForAmountPerWeek(String price) {
    return 'Continue for \$$price/week';
  }

  @override
  String bookForAmount(String price) {
    return 'Book for \$$price';
  }

  @override
  String get couldNotLoadAvailableSlots =>
      'Could not load available slots. Tap retry above.';

  @override
  String get noAvailableSlotsForDuration =>
      'No available slots for this duration.';

  @override
  String get selectATime => 'Select a time';

  @override
  String saveTimeDuration(String start, String end, String duration) {
    return 'Save $start - $end · ${duration}h';
  }

  @override
  String get chat => 'Chat';

  @override
  String get history => 'Historial';

  @override
  String get alerts => 'Alertas';

  @override
  String get newAlerts => 'Nuevas Alertas';

  @override
  String get searchFriends => 'Buscar amigos';

  @override
  String get noUnreadAlerts => 'No hay alertas nuevas';

  @override
  String get paymentPending => 'Pago Pendiente';

  @override
  String get pendingAcceptance => 'Pending acceptance';

  @override
  String get payNow => 'Pay now';

  @override
  String get pending => 'Pending';

  @override
  String get serviceInProgress => 'Service in progress';

  @override
  String get rating => 'Rating';

  @override
  String get needSupportImmediately => 'Need Support Immediately';

  @override
  String get manageSubscription => 'Administrar Suscripción';

  @override
  String get subscriptionStatus => 'Estado de la Suscripción';

  @override
  String freeTrialDaysLeft(String daysLeft) {
    return 'Prueba Gratuita de 30 Días ($daysLeft días restantes)';
  }

  @override
  String get cancelledActiveTillPeriodEnd =>
      'Cancelado (Activo hasta fin de período)';

  @override
  String get activePremium => 'Premium Activo';

  @override
  String get expired => 'Expirado';

  @override
  String get currentPlan => 'Plan Actual';

  @override
  String get subscriptionPrice => 'Precio de la Suscripción';

  @override
  String get activationDate => 'Fecha de Activación';

  @override
  String get nextBillingRenewal => 'Próxima Facturación / Renovación';

  @override
  String get purchasePlatform => 'Plataforma de Compra';

  @override
  String get annualPremium => 'Premium Anual';

  @override
  String get monthlyPremium => 'Premium Mensual';

  @override
  String get noSubscriptionPurchased => 'No hay suscripción comprada';

  @override
  String get yourValueThisMonth => 'Tu Valor Este Mes';

  @override
  String thisMonthRequestsBookings(String requests, String bookings) {
    return 'Este mes recibiste $requests solicitudes y aceptaste $bookings reservas.';
  }

  @override
  String get requestsReceived => 'Solicitudes Recibidas';

  @override
  String get bookingsAccepted => 'Reservas Aceptadas';

  @override
  String get acceptanceRate => 'Tasa de Aceptación';

  @override
  String get upgradeToPremiumNow => 'Mejorar a Premium Ahora';

  @override
  String get restorePurchase => 'Restaurar Compra';

  @override
  String get subscriptionRestoredSuccessfully =>
      '¡Suscripción restaurada con éxito!';

  @override
  String get noActiveSubscriptionFoundToRestore =>
      'No se encontró suscripción activa para restaurar.';

  @override
  String get cancelSubscription => 'Cancelar Suscripción';

  @override
  String get cancelSubscriptionQuestion => '¿Cancelar Suscripción?';

  @override
  String ifYouCancelTodayPremiumAccess(String date) {
    return 'Si cancelas hoy, tu acceso premium seguirá activo hasta el $date.\n\nPor favor, dinos por qué te vas:';
  }

  @override
  String get tooExpensive => 'Demasiado caro';

  @override
  String get notGettingEnoughClientRequests =>
      'No recibo suficientes solicitudes de clientes';

  @override
  String get usingADifferentPlatform => 'Uso una plataforma diferente';

  @override
  String get other => 'Otro';

  @override
  String get stayWithUsGet20Off =>
      '¡Quédate con nosotros! Obtén un 20% de DESCUENTO en tu próximo ciclo de facturación en lugar de cancelar.';

  @override
  String get keepMySubscription => 'Mantener Mi Suscripción';

  @override
  String get confirmCancellation => 'Confirmar Cancelación';

  @override
  String get pleaseCancelViaStore =>
      'Por favor, cancela a través de la página de suscripciones de Google Play o App Store.';

  @override
  String get bio => 'Biografía';

  @override
  String get writeSomethingAboutYourself => 'Escribe algo sobre ti...';

  @override
  String get pricePerHour => 'Precio por hora';

  @override
  String get experience => 'Experiencia';

  @override
  String get selectExperience => 'Seleccionar experiencia';

  @override
  String get specialties => 'Especialidades';

  @override
  String get otherTasksOffered => 'Otras tareas ofrecidas';

  @override
  String get workSchedule => 'Horario de trabajo';

  @override
  String get whenAreYouAvailable =>
      '¿Cuándo estás disponible para ofrecer tus servicios?';

  @override
  String get monday => 'Lunes';

  @override
  String get tuesday => 'Martes';

  @override
  String get wednesday => 'Miércoles';

  @override
  String get thursday => 'Jueves';

  @override
  String get friday => 'Viernes';

  @override
  String get saturday => 'Sábado';

  @override
  String get sunday => 'Domingo';

  @override
  String get available => 'Disponible';

  @override
  String get notAvailable => 'No disponible';

  @override
  String get confirm => 'Confirmar';

  @override
  String get pleaseUploadAnImage =>
      'Please upload an image for each selected option.';

  @override
  String get ifYouAlreadySubmitARequest =>
      'If you already submit a request please login with another account';

  @override
  String get preferences => 'Preferencias';

  @override
  String get myWorkAreas => 'Mis áreas de trabajo';

  @override
  String get currentLocationMap => 'Mapa de ubicación actual';

  @override
  String get next => 'Next';

  @override
  String get pleaseSelectYourRole => 'Por favor, selecciona tu rol';

  @override
  String get micAndCameraPermissionsRequired =>
      'Se requieren permisos de micrófono y cámara';

  @override
  String get userIsBusyOrUnavailable =>
      'El usuario está ocupado o no disponible';

  @override
  String get paymentSuccessful => 'Pago exitoso';

  @override
  String get accessLocked => 'ACCESO BLOQUEADO';

  @override
  String get subscriptionRequired => 'Suscripción requerida';

  @override
  String get startFreeTrialToReceiveRequests =>
      'Comienza tu prueba gratuita de 30 días para recibir\ny gestionar solicitudes de clientes.';

  @override
  String get startFreeTrial => 'Iniciar prueba gratuita';

  @override
  String get youCanStillManageProfile =>
      'Aún puedes gestionar tu perfil,\nservicios y horario.';

  @override
  String get tryIumiProviderFree => 'Prueba IUMI Provider gratis';

  @override
  String get unlockEveryFeature =>
      'Desbloquea todas las funciones de proveedor por 30 días.';

  @override
  String get thirtyDaysFree => '30 DÍAS GRATIS';

  @override
  String get receiveCustomerRequests => 'Recibir solicitudes de clientes';

  @override
  String get acceptOrDeclineBookings => 'Aceptar o rechazar reservas';

  @override
  String get contactCustomersAfterAcceptance =>
      'Contactar clientes después de aceptar';

  @override
  String get manageYourSchedule => 'Gestionar tu horario';

  @override
  String get freeFor30Days => 'Gratis por 30 días';

  @override
  String get then4999RonMonthCancelAnytime =>
      'Luego 49.99 RON/mes. Cancela cuando quieras.';

  @override
  String get start30DayFreeTrial => 'Comenzar prueba gratuita de 30 días';

  @override
  String get upgradePremium => 'Actualizar a Premium';

  @override
  String get notNow => 'Ahora no';

  @override
  String get noPaymentToday =>
      'Sin pago hoy. Funciona en\niOS, Android y la web.';

  @override
  String get somethingWentWrong => 'Algo salió mal';
}
