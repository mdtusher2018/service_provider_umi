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
      '¿Cuál es el precio mínimo que un cliente debe pagar para reservar tu servicio?  +info';

  @override
  String get minimumPriceLabel => 'Precio mínimo:';

  @override
  String get minimumPriceTip =>
      'Esto evitará que te reserven por un precio tan bajo que no valga la pena tu tiempo para desplazarte al servicio';

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
  String get myAddresses => 'Mis direcciones';

  @override
  String get paymentsAndRefunds => 'Pagos y reembolsos';

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
  String get addFaq => 'Añadir FAQ';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get language => 'Idioma';

  @override
  String get aboutUs => 'Sobre nosotros';

  @override
  String get termsAndConditions => 'Términos y condiciones';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get failedToLoadProfile => 'Error al cargar el perfil';

  @override
  String get pullToRefresh => 'Desliza para actualizar';

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
  String get myAddress => 'Mi dirección';

  @override
  String get yourAddresses => 'Tus direcciones';

  @override
  String get retry => 'Reintentar';

  @override
  String get noAddresses => 'Sin direcciones';

  @override
  String get addYourFirstAddressBelow => 'Añade tu primera dirección abajo';

  @override
  String get addNewAddress => 'Añadir nueva dirección';

  @override
  String get defaultAddressUpdated => 'Dirección predeterminada actualizada';

  @override
  String get defaultString => 'Predeterminado';

  @override
  String addressLabel(String address) {
    return 'Dirección: $address';
  }

  @override
  String get setAsDefault => 'Establecer como predeterminado';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get areYouSureToDelete => '¿Estás seguro de que quieres eliminar?';

  @override
  String get thisAddressWillBeRemoved =>
      'Esta dirección se eliminará permanentemente.';

  @override
  String get pleaseSearchAndSelectAddress =>
      'Por favor, busca y selecciona una dirección primero.';

  @override
  String get editAddress => 'Editar dirección';

  @override
  String get addAddress => 'Añadir dirección';

  @override
  String get searchAddress => 'Buscar dirección';

  @override
  String latLng(String lat, String lng) {
    return 'Lat: $lat, Lng: $lng';
  }

  @override
  String get reviewAndAdjust => 'Revisar y ajustar si es necesario';

  @override
  String get addressLine1 => 'Línea de dirección 1 *';

  @override
  String get streetNumberAndName => 'Número y nombre de calle';

  @override
  String get required => 'Obligatorio';

  @override
  String get addressLine2 => 'Línea de dirección 2';

  @override
  String get areaNeighbourhood => 'Zona / barrio (opcional)';

  @override
  String get city => 'Ciudad';

  @override
  String get state => 'Estado';

  @override
  String get postalCode => 'Código postal';

  @override
  String get postal => 'Postal';

  @override
  String get country => 'País';

  @override
  String get updateAddress => 'Actualizar dirección';

  @override
  String get saveAddress => 'Guardar dirección';

  @override
  String get myCards => 'Mis tarjetas';

  @override
  String get addNew => 'Añadir nueva';

  @override
  String get failedToGetAddCardLink =>
      'Error al obtener el enlace para añadir tarjeta';

  @override
  String get noCardsFound => 'No se encontraron tarjetas';

  @override
  String get cardDeletedSuccessfully => 'Tarjeta eliminada con éxito';

  @override
  String get setAsDefaultCardSuccessfully =>
      'Tarjeta predeterminada establecida con éxito';

  @override
  String get failedToSetDefaultCard =>
      'Error al establecer tarjeta predeterminada';

  @override
  String get setAsDefaultCard => 'Establecer como tarjeta predeterminada';

  @override
  String get myBalance => 'Mi saldo';

  @override
  String get availableBalance => 'Saldo disponible';

  @override
  String get paymentAndRefunds => 'Pagos y reembolsos';

  @override
  String get paymentMethods => 'Métodos de pago';

  @override
  String get myBooking => 'Mi reserva';

  @override
  String paidOn(String date) {
    return 'Pagado el $date';
  }

  @override
  String serviceDate(String date) {
    return 'Fecha del servicio: $date';
  }

  @override
  String get passwordChangedSuccessfully => 'Contraseña cambiada con éxito';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get oldPassword => 'Contraseña antigua';

  @override
  String get enterOldPassword => 'Introduce la contraseña antigua';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get confirmNewPassword => 'Confirmar nueva contraseña';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get faqAddedSuccessfully => 'FAQ añadido con éxito';

  @override
  String get question => 'Pregunta';

  @override
  String get enterYourQuestion => 'Introduce tu pregunta';

  @override
  String get pleaseEnterQuestion => 'Por favor, introduce una pregunta';

  @override
  String get answer => 'Respuesta';

  @override
  String get enterYourAnswer => 'Introduce tu respuesta';

  @override
  String get pleaseEnterAnswer => 'Por favor, introduce una respuesta';

  @override
  String get submitFaq => 'Enviar FAQ';

  @override
  String get reviews => 'Reseñas';

  @override
  String get noReviewsFound => 'No se encontraron reseñas';

  @override
  String get noContentAvailable => 'No hay contenido disponible.';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get createAccountBtn => 'Crear cuenta';

  @override
  String get logIn => 'Iniciar sesión';

  @override
  String get continueAsGuest => 'Continuar como invitado';

  @override
  String get whatWillYouDoOnIumi => '¿Qué harás en iumi?';

  @override
  String get roleDecisionNotFinal =>
      'Esta decisión no es definitiva. Puedes ser tanto cliente como profesional más adelante.';

  @override
  String get bookAService => 'Reservar un servicio';

  @override
  String get iAmAClient => 'Soy cliente';

  @override
  String get offerServices => 'Ofrecer servicios';

  @override
  String get iAmAProfessional => 'Soy profesional';

  @override
  String get createAccountTitle => 'Crear cuenta';

  @override
  String get enterYourName => 'Introduce tu nombre';

  @override
  String get enterEmail => 'Introduce tu email';

  @override
  String get password => 'Contraseña';

  @override
  String get serviceLocation => 'Ubicación del servicio';

  @override
  String get yourLocation => 'Tu ubicación';

  @override
  String get searchAndSelectServiceArea =>
      'Busca y selecciona tu área de servicio para que los clientes te encuentren.';

  @override
  String get weUseLocationForServices =>
      'Usamos tu ubicación para mostrarte servicios relevantes cerca de ti.';

  @override
  String get searchCitySuburbAddress => 'Buscar ciudad, barrio o dirección...';

  @override
  String get acceptTermsPrivacy =>
      'Al crear una cuenta, acepto los Términos y Condiciones y confirmo que he leído la Política de Privacidad';

  @override
  String get termsAndCondition => 'Términos y Condiciones';

  @override
  String get pleaseAcceptTerms =>
      'Acepta los términos y condiciones para continuar';

  @override
  String get haveAccountLogin => '¿Tienes una cuenta? Iniciar sesión';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get forgotPassword => '¿Olvidaste la contraseña?';

  @override
  String get enterEmailSendOtp =>
      'Introduce tu email y te enviaremos un OTP de restablecimiento.';

  @override
  String get enterYourEmail => 'Introduce tu email';

  @override
  String get sendOtp => 'Enviar OTP';

  @override
  String get otpVerifiedSuccessfully => 'OTP verificado con éxito';

  @override
  String get otpResentSuccessfully => 'OTP reenviado con éxito';

  @override
  String get verifyOtp => 'Verificar OTP';

  @override
  String enterOtpSentTo(String email) {
    return 'Introduce el OTP enviado a $email';
  }

  @override
  String get enterTheOtp => 'Introduce el OTP';

  @override
  String get verify => 'Verificar';

  @override
  String get didNotReceiveOtpResend => '¿No recibiste el OTP? Reenviar';

  @override
  String get resend => 'Reenviar';

  @override
  String resendOtpInSeconds(int seconds) {
    return 'Reenviar OTP en ${seconds}s';
  }

  @override
  String get passwordResetSuccessfully =>
      'Contraseña restablecida con éxito. Inicia sesión.';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get or => 'o';

  @override
  String get loginWithEmail => 'Iniciar sesión con email';

  @override
  String get createWithEmail => 'Crear con email';

  @override
  String get weValueYourPrivacy => 'Valoramos tu privacidad';

  @override
  String get cookiePolicyMsg =>
      'Webel usa cookies para analizar el rendimiento de campañas publicitarias, mejorar anuncios y personalizar la experiencia según las preferencias del usuario.';

  @override
  String get accept => 'Aceptar';

  @override
  String get serviceAddress => 'Dirección del servicio';

  @override
  String get selectWhereYouWantToReceiveService =>
      'Selecciona dónde quieres recibir el servicio';

  @override
  String get support => 'Soporte';

  @override
  String get call => 'Llamar';

  @override
  String get phoneNumberCopied => 'Número de teléfono copiado al portapapeles';

  @override
  String get message => 'Mensaje';

  @override
  String get emailCopied => 'Email copiado al portapapeles';

  @override
  String get verificationPending => 'Verificación pendiente';

  @override
  String get verificationPendingDesc =>
      'Tu cuenta está pendiente de verificación. Algunas funciones pueden estar limitadas.';

  @override
  String get refresh => 'Actualizar';

  @override
  String get whenDoYouNeedIt => '¿Cuándo lo necesitas?';

  @override
  String get frequency => 'Frecuencia';

  @override
  String get justOnce => 'Solo una vez';

  @override
  String get oneTime => 'Una vez';

  @override
  String get weekly => 'Semanal';

  @override
  String get recurring => 'Recurrente';

  @override
  String get daysOfTheWeek => 'Día(s) de la semana';

  @override
  String get startTime => 'Hora de inicio';

  @override
  String get flexibleStart => 'Inicio flexible';

  @override
  String get exactStart => 'Inicio exacto';

  @override
  String get morning => 'Mañana';

  @override
  String get evening => 'Noche';

  @override
  String get selectExactTime => 'Seleccionar hora exacta';

  @override
  String get skip => 'Omitir';

  @override
  String get search => 'Buscar';

  @override
  String get back => 'Atrás';

  @override
  String get clearFilters => 'Limpiar filtros';

  @override
  String get palliativeCare => 'Cuidados paliativos';

  @override
  String get palliativeCareDesc =>
      'Solo mostrar profesionales especializados en cuidados paliativos.';

  @override
  String get drivingLicence => 'Permiso de conducir';

  @override
  String get drivingLicenceDesc =>
      'Solo mostrar profesionales con permiso de conducir';

  @override
  String get businessProfiles => 'Perfiles empresariales';

  @override
  String get businessProfilesDesc =>
      'Solo perfiles que correspondan a una empresa o profesional autónomo validado.';

  @override
  String get qualifiedCarer => 'Cuidador cualificado';

  @override
  String get qualifiedCarerDesc =>
      'Solo mostrar cuidadores con cualificación, diploma o título como personal sanitario';

  @override
  String get priceRange => 'Rango de precio';

  @override
  String get hourlyRate => 'Tarifa por hora';

  @override
  String get maxPriceWillingToPay =>
      'Precio máximo que estás dispuesto a pagar.';

  @override
  String get experienceLevel => 'Nivel de experiencia';

  @override
  String get specificTasksRequirements => 'Tareas específicas / Requisitos';

  @override
  String get updatedSuccessfully => 'Actualizado con éxito';

  @override
  String get images => 'Imágenes';

  @override
  String get coverImage => 'Imagen de portada';

  @override
  String get galleryImages => 'Imágenes de la galería';

  @override
  String get add => 'Añadir';

  @override
  String get palliativeCareImage => 'Imagen cuidados paliativos';

  @override
  String get drivingLicenceImage => 'Imagen permiso de conducir';

  @override
  String get businessProfileImage => 'Imagen perfil empresarial';

  @override
  String get qualificationCertificate => 'Certificado de cualificación';

  @override
  String get submit => 'Enviar';

  @override
  String get update => 'Actualizar';

  @override
  String get applyFilters => 'Aplicar filtros';

  @override
  String get verificationSubmitted => 'Verificación enviada';

  @override
  String get verificationSubmittedDesc =>
      'Tu solicitud se ha enviado con éxito.\n\nInicia sesión con otra cuenta.';

  @override
  String get findTheServiceYouNeed => 'Encuentra el servicio que necesitas';

  @override
  String get mostPopularInYourArea => 'Los más populares en tu zona';

  @override
  String get searchResults => 'Resultados de búsqueda';

  @override
  String get noServicesFound => 'No se encontraron servicios';

  @override
  String get tryADifferentSearchTerm => 'Prueba con otro término de búsqueda';

  @override
  String get howDoesTheServiceWork => '¿Cómo funciona el servicio?';

  @override
  String get finding => 'Buscando ';

  @override
  String get professionals => 'profesionales';

  @override
  String get whenQuestion => '¿Cuándo?';

  @override
  String get filters => 'Filtros';

  @override
  String get howDoesTheServiceWorkTitle =>
      '¿Cómo funciona el servicio de cuidado de personas mayores?';

  @override
  String get noFaqsAvailable => 'No hay FAQs disponibles';

  @override
  String get bookingAccepted => 'Reserva aceptada';

  @override
  String get comment => 'Comentario';

  @override
  String get serviceBookedSuccess =>
      'Servicio reservado con éxito para cuidado de personas mayores.';

  @override
  String get dateAndTime => 'Fecha y hora';

  @override
  String get address => 'Dirección';

  @override
  String get servicePrice => 'Precio del servicio';

  @override
  String get complete => 'Completar';

  @override
  String get bookingHasBeenCompleted => 'Esta reserva ha sido completada';

  @override
  String get customer => 'Cliente:';

  @override
  String get provider => 'Proveedor:';

  @override
  String cantChatBeforeAction(String action) {
    return 'No puedes chatear antes de $action la reserva';
  }

  @override
  String get accepting => 'aceptar';

  @override
  String get creating => 'crear';

  @override
  String failedToLoadChat(String message) {
    return 'Error al cargar el chat: $message';
  }

  @override
  String get serviceText => 'Servicio';

  @override
  String get bookingHours => 'Horas de reserva';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get clientProtection => 'Protección al cliente';

  @override
  String get total => 'Total';

  @override
  String get free => 'Gratis';

  @override
  String get details => 'Detalles';

  @override
  String get noDataFound => 'No se encontraron datos';

  @override
  String get addressNotAvailable => 'Dirección no disponible';

  @override
  String addressCoordsLabel(String lat, String lng) {
    return 'Dirección: Lat: $lat, Lng: $lng';
  }

  @override
  String get congratulations => 'Felicidades';

  @override
  String get congratulationsDesc =>
      '¡Felicidades por alcanzar este hito en tu carrera profesional!';

  @override
  String get done => 'Hecho';

  @override
  String get setUpAtLeastOneDay => 'Configura al menos un día';

  @override
  String get selectATimeSlot => 'Selecciona un horario';

  @override
  String get bookingDotDot => 'Reservando…';

  @override
  String continueForAmountPerWeek(String price) {
    return 'Continuar por \$$price/semana';
  }

  @override
  String bookForAmount(String price) {
    return 'Reservar por \$$price';
  }

  @override
  String get couldNotLoadAvailableSlots =>
      'No se pudieron cargar los horarios disponibles. Toca Reintentar.';

  @override
  String get noAvailableSlotsForDuration =>
      'No hay horarios disponibles para esta duración.';

  @override
  String get selectATime => 'Selecciona una hora';

  @override
  String saveTimeDuration(String start, String end, String duration) {
    return 'Guardar $start - $end · ${duration}h';
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
  String get pendingAcceptance => 'Aceptación pendiente';

  @override
  String get payNow => 'Pagar ahora';

  @override
  String get pending => 'Pendiente';

  @override
  String get serviceInProgress => 'Servicio en progreso';

  @override
  String get rating => 'Calificación';

  @override
  String get needSupportImmediately => 'Necesitas soporte inmediato';

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
      'Sube una imagen para cada opción seleccionada.';

  @override
  String get ifYouAlreadySubmitARequest =>
      'Si ya enviaste una solicitud, inicia sesión con otra cuenta';

  @override
  String get preferences => 'Preferencias';

  @override
  String get myWorkAreas => 'Mis áreas de trabajo';

  @override
  String get currentLocationMap => 'Mapa de ubicación actual';

  @override
  String get next => 'Siguiente';

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

  @override
  String get seeMore => 'Ver más';

  @override
  String get documents => 'Documentos';

  @override
  String get chooseYourPlan => 'Elige tu plan';

  @override
  String get noPlansAvailable => 'No hay planes disponibles en este momento.';

  @override
  String get checkBackLater =>
      'Vuelve a comprobarlo más tarde o contacta con soporte.';

  @override
  String get upgradeToPremium => 'Actualizar a Premium';

  @override
  String get unlockAllFeatures =>
      'Desbloquea todas las funciones y haz crecer tu negocio.';

  @override
  String savePercent(String percent) {
    return 'Ahorra un $percent%';
  }

  @override
  String get alreadySubscribed => 'Ya estás suscrito a este plan.';

  @override
  String get planNotAvailable =>
      'Este plan aún no está disponible para su compra en esta plataforma. Inténtalo más tarde.';

  @override
  String successfullySubscribed(String planName) {
    return '¡Suscrito con éxito a $planName!';
  }

  @override
  String get subscribeNow => 'Suscríbete ahora';

  @override
  String get messageSentSuccessfully => 'Tu mensaje ha sido enviado con éxito.';

  @override
  String get failedToSendMessage =>
      'Error al enviar el mensaje. Por favor, inténtalo de nuevo.';

  @override
  String get pleaseSelectDocument =>
      'Por favor, selecciona al menos un documento para continuar.';

  @override
  String get documentsUpdatedSuccessfully =>
      'Documentos actualizados con éxito';

  @override
  String get pleaseEnterValidPricePerHour =>
      'Por favor, introduce un precio válido por hora';

  @override
  String get listingUpdatedSuccessfully => 'Anuncio actualizado con éxito';

  @override
  String get failedToSubmitReview => 'Error al enviar la reseña';

  @override
  String get reviewSubmittedSuccessfully => 'Reseña enviada con éxito';

  @override
  String get failedToSaveSchedule =>
      'Error al guardar el horario. Inténtalo de nuevo.';

  @override
  String get pleaseFillOutAllFields => 'Por favor, completa todos los campos.';

  @override
  String get pleaseSelectFlexibleStartTime =>
      'Por favor, selecciona una hora de inicio flexible o usa \'Omitir\'.';

  @override
  String get outstanding => 'Excelente';

  @override
  String get hello => 'Hola';

  @override
  String get description => 'Descripción';

  @override
  String get copyrightIBadi => 'Copyright iBadi';

  @override
  String get badi => 'Badi';

  @override
  String get download => 'Descargar';

  @override
  String get end => 'Fin';

  @override
  String get markAllRead => 'Marcar todo como leído';

  @override
  String get goBack => 'Volver';

  @override
  String get iumiAdminSupport => 'Soporte Admin Iumi';

  @override
  String get emailAddress => 'Dirección de email';

  @override
  String get subject => 'Asunto';

  @override
  String get yourMessage => 'Tu mensaje';

  @override
  String get sayHello => 'Saluda 👋';

  @override
  String get chooseOption => 'Elegir opción';

  @override
  String get settings => 'Configuración';

  @override
  String get completePayment => 'Completar pago';

  @override
  String get noMessages => 'Sin mensajes';

  @override
  String get noNotification => 'Sin notificaciones';

  @override
  String get noScheduleAvailable => 'Sin horario disponible.';

  @override
  String get additionalComments => 'Comentarios adicionales';

  @override
  String get gallery => 'Galería';

  @override
  String get failedToLoadGallery => 'Error al cargar la galería';

  @override
  String get noImagesAvailable => 'Sin imágenes disponibles';

  @override
  String get viewGallery => 'Ver galería';

  @override
  String get noGalleryImageFound => 'No se encontró imagen en la galería';

  @override
  String get comments => 'Comentarios';

  @override
  String get noCommentsFound => 'No se encontraron comentarios';

  @override
  String get serviceFrequency => 'Frecuencia del servicio';

  @override
  String get howManyTimesDoYouWantTheService =>
      '¿Cuántas veces quieres el servicio?';

  @override
  String get rateYourExperience => 'Califica tu experiencia';

  @override
  String get deleteThisAddress => '¿Eliminar esta dirección?';

  @override
  String get showSpecialistsIn => 'Mostrar especialistas en:';

  @override
  String get ok => 'OK';

  @override
  String get chooseFromGallery => 'Elegir de la galería';

  @override
  String get takeAPhoto => 'Tomar una foto';

  @override
  String get profilePicture => 'Foto de perfil';

  @override
  String get doYouWantToGoBack => '¿Quieres volver atrás?';

  @override
  String get startYour30DayFreeTrialToReceiveAndManageCustomerRequests =>
      'Comienza tu prueba gratuita de 30 días para recibir y gestionar solicitudes de clientes.';

  @override
  String get youCanStillManageYourProfileServicesAndSchedule =>
      'Aún puedes gestionar tu perfil, servicios y horario.';
}
