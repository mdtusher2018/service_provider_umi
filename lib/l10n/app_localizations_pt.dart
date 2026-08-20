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
  String get calendar => 'Calendário';

  @override
  String get service => 'Serviço';

  @override
  String get favourites => 'Favoritos';

  @override
  String get notification => 'Notificação';

  @override
  String get inbox => 'Caixa de entrada';

  @override
  String get minimumPriceSavedSuccessfully => 'Preço mínimo salvo com sucesso';

  @override
  String get minimumPriceTitle => 'Preço mínimo';

  @override
  String get minimumPriceQuestion =>
      'Qual é o preço mínimo que um cliente deve pagar para reservar seu serviço?  +info';

  @override
  String get minimumPriceLabel => 'Preço mínimo:';

  @override
  String get minimumPriceTip =>
      'Isso evitará ser reservado por um preço tão baixo que não valha o seu tempo para se deslocar até o serviço';

  @override
  String get upcomingBookings => 'Reservas futuras';

  @override
  String get dateFilter => 'Filtro de data';

  @override
  String get noBookingsFound => 'Nenhuma reserva encontrada';

  @override
  String get request => 'Solicitação';

  @override
  String get completed => 'Concluído';

  @override
  String get ongoing => 'Em andamento';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get completedServices => 'Serviços concluídos';

  @override
  String get accountSettings => 'Configurações da conta';

  @override
  String get personalDetails => 'Dados pessoais';

  @override
  String get myAddresses => 'Meus endereços';

  @override
  String get paymentsAndRefunds => 'Pagamentos e reembolsos';

  @override
  String get mySubscription => 'Minha assinatura';

  @override
  String get myListing => 'Meu anúncio';

  @override
  String get mySchedule => 'Meu horário';

  @override
  String get minimumBookingAmount => 'Valor mínimo de reserva';

  @override
  String get myReview => 'Minha avaliação';

  @override
  String get addFaq => 'Adicionar FAQ';

  @override
  String get changePassword => 'Mudar senha';

  @override
  String get language => 'Idioma';

  @override
  String get aboutUs => 'Sobre nós';

  @override
  String get termsAndConditions => 'Termos e condições';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get logout => 'Sair';

  @override
  String get failedToLoadProfile => 'Falha ao carregar perfil';

  @override
  String get pullToRefresh => 'Puxe para atualizar';

  @override
  String get areYouSureToLogout => 'Tem certeza de que deseja sair?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get notConnected => 'Não conectado';

  @override
  String get connected => 'Conectado';

  @override
  String stripe(String status) {
    return 'Stripe : $status';
  }

  @override
  String get areYouSureToDeleteAccount => 'Tem certeza de que deseja excluir?';

  @override
  String get profileUpdatedSuccessfully => 'Perfil atualizado com sucesso';

  @override
  String failedToUpdateProfile(String message) {
    return 'Falha ao atualizar perfil: $message';
  }

  @override
  String failedToDeleteAccount(String message) {
    return 'Falha ao excluir conta: $message';
  }

  @override
  String get fullName => 'Nome completo';

  @override
  String get aboutMe => 'Sobre mim';

  @override
  String get searchYourAddress => 'Pesquise seu endereço…';

  @override
  String get phoneNumber => 'Número de telefone';

  @override
  String get deleteAccountPermanently => 'Excluir conta permanentemente';

  @override
  String get yesDelete => 'SIM, EXCLUIR';

  @override
  String get noDontDelete => 'NÃO, NÃO EXCLUIR';

  @override
  String get myAddress => 'Meu endereço';

  @override
  String get yourAddresses => 'Seus endereços';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get noAddresses => 'Sem endereços';

  @override
  String get addYourFirstAddressBelow =>
      'Adicione seu primeiro endereço abaixo';

  @override
  String get addNewAddress => 'Adicionar novo endereço';

  @override
  String get defaultAddressUpdated => 'Endereço padrão atualizado';

  @override
  String get defaultString => 'Padrão';

  @override
  String addressLabel(String address) {
    return 'Endereço: $address';
  }

  @override
  String get setAsDefault => 'Definir como padrão';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Excluir';

  @override
  String get areYouSureToDelete => 'Tem certeza de que deseja excluir?';

  @override
  String get thisAddressWillBeRemoved =>
      'Este endereço será removido permanentemente.';

  @override
  String get pleaseSearchAndSelectAddress =>
      'Pesquise e selecione um endereço primeiro.';

  @override
  String get editAddress => 'Editar endereço';

  @override
  String get addAddress => 'Adicionar endereço';

  @override
  String get searchAddress => 'Pesquisar endereço';

  @override
  String latLng(String lat, String lng) {
    return 'Lat: $lat, Lng: $lng';
  }

  @override
  String get reviewAndAdjust => 'Revise e ajuste se necessário';

  @override
  String get addressLine1 => 'Linha de endereço 1 *';

  @override
  String get streetNumberAndName => 'Número e nome da rua';

  @override
  String get required => 'Obrigatório';

  @override
  String get addressLine2 => 'Linha de endereço 2';

  @override
  String get areaNeighbourhood => 'Área / bairro (opcional)';

  @override
  String get city => 'Cidade';

  @override
  String get state => 'Estado';

  @override
  String get postalCode => 'Código postal';

  @override
  String get postal => 'Postal';

  @override
  String get country => 'País';

  @override
  String get updateAddress => 'Atualizar endereço';

  @override
  String get saveAddress => 'Salvar endereço';

  @override
  String get myCards => 'Meus cartões';

  @override
  String get addNew => 'Adicionar';

  @override
  String get failedToGetAddCardLink =>
      'Falha ao obter link para adicionar cartão';

  @override
  String get noCardsFound => 'Nenhum cartão encontrado';

  @override
  String get cardDeletedSuccessfully => 'Cartão excluído com sucesso';

  @override
  String get setAsDefaultCardSuccessfully =>
      'Cartão padrão definido com sucesso';

  @override
  String get failedToSetDefaultCard => 'Falha ao definir cartão padrão';

  @override
  String get setAsDefaultCard => 'Definir como cartão padrão';

  @override
  String get myBalance => 'Meu saldo';

  @override
  String get availableBalance => 'Saldo disponível';

  @override
  String get paymentAndRefunds => 'Pagamentos e reembolsos';

  @override
  String get paymentMethods => 'Métodos de pagamento';

  @override
  String get myBooking => 'Minha reserva';

  @override
  String paidOn(String date) {
    return 'Pago em $date';
  }

  @override
  String serviceDate(String date) {
    return 'Data do serviço: $date';
  }

  @override
  String get passwordChangedSuccessfully => 'Senha alterada com sucesso';

  @override
  String get currentPassword => 'Senha atual';

  @override
  String get oldPassword => 'Senha antiga';

  @override
  String get enterOldPassword => 'Insira a senha antiga';

  @override
  String get newPassword => 'Nova senha';

  @override
  String get confirmNewPassword => 'Confirmar nova senha';

  @override
  String get confirmPassword => 'Confirmar senha';

  @override
  String get faqAddedSuccessfully => 'FAQ adicionada com sucesso';

  @override
  String get question => 'Pergunta';

  @override
  String get enterYourQuestion => 'Insira sua pergunta';

  @override
  String get pleaseEnterQuestion => 'Por favor, insira uma pergunta';

  @override
  String get answer => 'Resposta';

  @override
  String get enterYourAnswer => 'Insira sua resposta';

  @override
  String get pleaseEnterAnswer => 'Por favor, insira uma resposta';

  @override
  String get submitFaq => 'Enviar FAQ';

  @override
  String get reviews => 'Avaliações';

  @override
  String get noReviewsFound => 'Nenhuma avaliação encontrada';

  @override
  String get noContentAvailable => 'Nenhum conteúdo disponível.';

  @override
  String get tryAgain => 'Tentar novamente';

  @override
  String get createAccountBtn => 'Criar conta';

  @override
  String get logIn => 'Entrar';

  @override
  String get continueAsGuest => 'Continuar como convidado';

  @override
  String get whatWillYouDoOnIumi => 'O que você fará no iumi?';

  @override
  String get roleDecisionNotFinal =>
      'Esta decisão não é definitiva. Você pode ser cliente e profissional mais tarde.';

  @override
  String get bookAService => 'Reservar um serviço';

  @override
  String get iAmAClient => 'Sou cliente';

  @override
  String get offerServices => 'Oferecer serviços';

  @override
  String get iAmAProfessional => 'Sou profissional';

  @override
  String get createAccountTitle => 'Criar conta';

  @override
  String get enterYourName => 'Digite seu nome';

  @override
  String get enterEmail => 'Digite o email';

  @override
  String get password => 'Senha';

  @override
  String get serviceLocation => 'Local do serviço';

  @override
  String get yourLocation => 'Sua localização';

  @override
  String get searchAndSelectServiceArea =>
      'Pesquise e selecione sua área de serviço para que os clientes possam encontrá-lo.';

  @override
  String get weUseLocationForServices =>
      'Usamos sua localização para mostrar serviços relevantes por perto.';

  @override
  String get searchCitySuburbAddress =>
      'Pesquisar cidade, bairro ou endereço...';

  @override
  String get acceptTermsPrivacy =>
      'Ao criar uma conta, aceito os Termos e Condições e confirmo que li a Política de Privacidade';

  @override
  String get termsAndCondition => 'Termos e Condições';

  @override
  String get pleaseAcceptTerms => 'Aceite os termos e condições para continuar';

  @override
  String get haveAccountLogin => 'Tem uma conta? Entrar';

  @override
  String get login => 'Entrar';

  @override
  String get forgotPassword => 'Esqueceu a senha?';

  @override
  String get enterEmailSendOtp =>
      'Digite seu email e enviaremos um OTP de redefinição.';

  @override
  String get enterYourEmail => 'Digite seu email';

  @override
  String get sendOtp => 'Enviar OTP';

  @override
  String get otpVerifiedSuccessfully => 'OTP verificado com sucesso';

  @override
  String get otpResentSuccessfully => 'OTP reenviado com sucesso';

  @override
  String get verifyOtp => 'Verificar OTP';

  @override
  String enterOtpSentTo(String email) {
    return 'Digite o OTP enviado para $email';
  }

  @override
  String get enterTheOtp => 'Digite o OTP';

  @override
  String get verify => 'Verificar';

  @override
  String get didNotReceiveOtpResend => 'Não recebeu o OTP? Reenviar';

  @override
  String get resend => 'Reenviar';

  @override
  String resendOtpInSeconds(int seconds) {
    return 'Reenviar OTP em ${seconds}s';
  }

  @override
  String get passwordResetSuccessfully =>
      'Senha redefinida com sucesso. Faça login.';

  @override
  String get resetPassword => 'Redefinir senha';

  @override
  String get continueWithGoogle => 'Continuar com Google';

  @override
  String get or => 'ou';

  @override
  String get loginWithEmail => 'Entrar com email';

  @override
  String get createWithEmail => 'Criar com email';

  @override
  String get weValueYourPrivacy => 'Valorizamos sua privacidade';

  @override
  String get cookiePolicyMsg =>
      'Webel usa cookies para analisar o desempenho de campanhas publicitárias, melhorar anúncios e personalizar a experiência com base nas preferências do usuário.';

  @override
  String get accept => 'Aceitar';

  @override
  String get serviceAddress => 'Endereço do serviço';

  @override
  String get selectWhereYouWantToReceiveService =>
      'Selecione onde deseja receber o serviço';

  @override
  String get support => 'Suporte';

  @override
  String get call => 'Ligar';

  @override
  String get phoneNumberCopied =>
      'Número de telefone copiado para a área de transferência';

  @override
  String get message => 'Mensagem';

  @override
  String get emailCopied => 'Email copiado para a área de transferência';

  @override
  String get verificationPending => 'Verificação pendente';

  @override
  String get verificationPendingDesc =>
      'Sua conta está pendente de verificação. Alguns recursos podem ser limitados.';

  @override
  String get refresh => 'Atualizar';

  @override
  String get whenDoYouNeedIt => 'Quando você precisa?';

  @override
  String get frequency => 'Frequência';

  @override
  String get justOnce => 'Apenas uma vez';

  @override
  String get oneTime => 'Único';

  @override
  String get weekly => 'Semanal';

  @override
  String get recurring => 'Recorrente';

  @override
  String get daysOfTheWeek => 'Dia(s) da semana';

  @override
  String get startTime => 'Hora de início';

  @override
  String get flexibleStart => 'Início flexível';

  @override
  String get exactStart => 'Início exato';

  @override
  String get morning => 'Manhã';

  @override
  String get evening => 'Noite';

  @override
  String get selectExactTime => 'Selecionar hora exata';

  @override
  String get skip => 'Pular';

  @override
  String get search => 'Pesquisar';

  @override
  String get back => 'Voltar';

  @override
  String get clearFilters => 'Limpar filtros';

  @override
  String get palliativeCare => 'Cuidados paliativos';

  @override
  String get palliativeCareDesc =>
      'Mostrar apenas profissionais especializados em cuidados paliativos.';

  @override
  String get drivingLicence => 'Carta de condução';

  @override
  String get drivingLicenceDesc =>
      'Mostrar apenas profissionais com carta de condução';

  @override
  String get businessProfiles => 'Perfis empresariais';

  @override
  String get businessProfilesDesc =>
      'Apenas perfis correspondentes a uma empresa ou profissional autônomo validado.';

  @override
  String get qualifiedCarer => 'Cuidador qualificado';

  @override
  String get qualifiedCarerDesc =>
      'Mostrar apenas cuidadores com qualificação, diploma ou grau como pessoal de saúde';

  @override
  String get priceRange => 'Faixa de preço';

  @override
  String get hourlyRate => 'Taxa horária';

  @override
  String get maxPriceWillingToPay =>
      'Preço máximo que você está disposto a pagar.';

  @override
  String get experienceLevel => 'Nível de experiência';

  @override
  String get specificTasksRequirements => 'Tarefas específicas / Requisitos';

  @override
  String get updatedSuccessfully => 'Atualizado com sucesso';

  @override
  String get images => 'Imagens';

  @override
  String get coverImage => 'Imagem de capa';

  @override
  String get galleryImages => 'Imagens da galeria';

  @override
  String get add => 'Adicionar';

  @override
  String get palliativeCareImage => 'Imagem cuidados paliativos';

  @override
  String get drivingLicenceImage => 'Imagem carta de condução';

  @override
  String get businessProfileImage => 'Imagem perfil empresarial';

  @override
  String get qualificationCertificate => 'Certificado de qualificação';

  @override
  String get submit => 'Enviar';

  @override
  String get update => 'Atualizar';

  @override
  String get applyFilters => 'Aplicar filtros';

  @override
  String get verificationSubmitted => 'Verificação enviada';

  @override
  String get verificationSubmittedDesc =>
      'Sua solicitação foi enviada com sucesso.\n\nFaça login novamente com outra conta.';

  @override
  String get findTheServiceYouNeed => 'Encontre o serviço que você precisa';

  @override
  String get mostPopularInYourArea => 'Mais populares na sua área';

  @override
  String get searchResults => 'Resultados da pesquisa';

  @override
  String get noServicesFound => 'Nenhum serviço encontrado';

  @override
  String get tryADifferentSearchTerm => 'Tente outro termo de pesquisa';

  @override
  String get howDoesTheServiceWork => 'Como funciona o serviço?';

  @override
  String get finding => 'Procurando ';

  @override
  String get professionals => 'profissionais';

  @override
  String get whenQuestion => 'Quando?';

  @override
  String get filters => 'Filtros';

  @override
  String get howDoesTheServiceWorkTitle =>
      'Como funciona o serviço de cuidados a idosos?';

  @override
  String get noFaqsAvailable => 'Nenhuma FAQ disponível';

  @override
  String get bookingAccepted => 'Reserva aceita';

  @override
  String get comment => 'Comentário';

  @override
  String get serviceBookedSuccess =>
      'Serviço reservado com sucesso para cuidados a idosos. Certifique-se de que a assistência inclua verificações diárias, lembretes de medicação e ajuda com mobilidade.';

  @override
  String get dateAndTime => 'Data e hora';

  @override
  String get address => 'Endereço';

  @override
  String get servicePrice => 'Preço do serviço';

  @override
  String get complete => 'Concluir';

  @override
  String get bookingHasBeenCompleted => 'Esta reserva foi concluída';

  @override
  String get customer => 'Cliente:';

  @override
  String get provider => 'Prestador:';

  @override
  String cantChatBeforeAction(String action) {
    return 'Você não pode conversar antes de $action a reserva';
  }

  @override
  String get accepting => 'aceitar';

  @override
  String get creating => 'criar';

  @override
  String failedToLoadChat(String message) {
    return 'Falha ao carregar chat: $message';
  }

  @override
  String get serviceText => 'Serviço';

  @override
  String get bookingHours => 'Horas de reserva';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get clientProtection => 'Proteção ao cliente';

  @override
  String get total => 'Total';

  @override
  String get free => 'Grátis';

  @override
  String get details => 'Detalhes';

  @override
  String get noDataFound => 'Nenhum dado encontrado';

  @override
  String get addressNotAvailable => 'Endereço não disponível';

  @override
  String addressCoordsLabel(String lat, String lng) {
    return 'Endereço: Lat: $lat, Lng: $lng';
  }

  @override
  String get congratulations => 'Parabéns';

  @override
  String get congratulationsDesc =>
      'Parabéns por alcançar este marco na sua jornada profissional! Sua dedicação, expertise e trabalho árduo são realmente louváveis.';

  @override
  String get done => 'Concluído';

  @override
  String get setUpAtLeastOneDay => 'Configure pelo menos um dia';

  @override
  String get selectATimeSlot => 'Selecione um horário';

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
      'Não foi possível carregar horários disponíveis. Toque em Tentar novamente.';

  @override
  String get noAvailableSlotsForDuration =>
      'Nenhum horário disponível para esta duração.';

  @override
  String get selectATime => 'Selecione um horário';

  @override
  String saveTimeDuration(String start, String end, String duration) {
    return 'Salvar $start - $end · ${duration}h';
  }

  @override
  String get chat => 'Chat';

  @override
  String get history => 'Histórico';

  @override
  String get alerts => 'Alertas';

  @override
  String get newAlerts => 'Novos alertas';

  @override
  String get searchFriends => 'Pesquisar amigos';

  @override
  String get noUnreadAlerts => 'Sem alertas não lidos';

  @override
  String get paymentPending => 'Pagamento pendente';

  @override
  String get pendingAcceptance => 'Aceitação pendente';

  @override
  String get payNow => 'Pagar agora';

  @override
  String get pending => 'Pendente';

  @override
  String get serviceInProgress => 'Serviço em andamento';

  @override
  String get rating => 'Avaliação';

  @override
  String get needSupportImmediately => 'Precisa de suporte imediato';

  @override
  String get manageSubscription => 'Gerenciar assinatura';

  @override
  String get subscriptionStatus => 'Status da assinatura';

  @override
  String freeTrialDaysLeft(String daysLeft) {
    return 'Teste gratuito de 30 dias ($daysLeft dias restantes)';
  }

  @override
  String get cancelledActiveTillPeriodEnd =>
      'Cancelado (Ativo até o fim do período)';

  @override
  String get activePremium => 'Premium ativo';

  @override
  String get expired => 'Expirado';

  @override
  String get currentPlan => 'Plano atual';

  @override
  String get subscriptionPrice => 'Preço da assinatura';

  @override
  String get activationDate => 'Data de ativação';

  @override
  String get nextBillingRenewal => 'Próximo faturamento / Renovação';

  @override
  String get purchasePlatform => 'Plataforma de compra';

  @override
  String get annualPremium => 'Premium anual';

  @override
  String get monthlyPremium => 'Premium mensal';

  @override
  String get noSubscriptionPurchased => 'Nenhuma assinatura comprada';

  @override
  String get yourValueThisMonth => 'Seu valor este mês';

  @override
  String thisMonthRequestsBookings(String requests, String bookings) {
    return 'Neste mês, você recebeu $requests solicitações e aceitou $bookings reservas.';
  }

  @override
  String get requestsReceived => 'Solicitações recebidas';

  @override
  String get bookingsAccepted => 'Reservas aceitas';

  @override
  String get acceptanceRate => 'Taxa de aceitação';

  @override
  String get upgradeToPremiumNow => 'Atualizar para Premium agora';

  @override
  String get restorePurchase => 'Restaurar compra';

  @override
  String get subscriptionRestoredSuccessfully =>
      'Assinatura restaurada com sucesso!';

  @override
  String get noActiveSubscriptionFoundToRestore =>
      'Nenhuma assinatura ativa encontrada para restaurar.';

  @override
  String get cancelSubscription => 'Cancelar assinatura';

  @override
  String get cancelSubscriptionQuestion => 'Cancelar assinatura?';

  @override
  String ifYouCancelTodayPremiumAccess(String date) {
    return 'Se você cancelar hoje, seu acesso Premium permanecerá ativo até $date.\n\nDiga-nos por que você está saindo:';
  }

  @override
  String get tooExpensive => 'Muito caro';

  @override
  String get notGettingEnoughClientRequests =>
      'Não recebo solicitações suficientes de clientes';

  @override
  String get usingADifferentPlatform => 'Usando outra plataforma';

  @override
  String get other => 'Outro';

  @override
  String get stayWithUsGet20Off =>
      'Fique conosco! Ganhe 20% de desconto no próximo ciclo de cobrança em vez de cancelar.';

  @override
  String get keepMySubscription => 'Manter minha assinatura';

  @override
  String get confirmCancellation => 'Confirmar cancelamento';

  @override
  String get pleaseCancelViaStore =>
      'Cancele pela página de assinaturas do Google Play ou App Store.';

  @override
  String get bio => 'Biografia';

  @override
  String get writeSomethingAboutYourself => 'Escreva algo sobre você...';

  @override
  String get pricePerHour => 'Preço por hora';

  @override
  String get experience => 'Experiência';

  @override
  String get selectExperience => 'Selecionar experiência';

  @override
  String get specialties => 'Especialidades';

  @override
  String get otherTasksOffered => 'Outras tarefas oferecidas';

  @override
  String get workSchedule => 'Horário de trabalho';

  @override
  String get whenAreYouAvailable =>
      'Quando você está disponível para oferecer seus serviços?';

  @override
  String get monday => 'Segunda-feira';

  @override
  String get tuesday => 'Terça-feira';

  @override
  String get wednesday => 'Quarta-feira';

  @override
  String get thursday => 'Quinta-feira';

  @override
  String get friday => 'Sexta-feira';

  @override
  String get saturday => 'Sábado';

  @override
  String get sunday => 'Domingo';

  @override
  String get available => 'Disponível';

  @override
  String get notAvailable => 'Indisponível';

  @override
  String get confirm => 'Confirmar';

  @override
  String get pleaseUploadAnImage =>
      'Envie uma imagem para cada opção selecionada.';

  @override
  String get ifYouAlreadySubmitARequest =>
      'Se já enviou uma solicitação, faça login com outra conta';

  @override
  String get preferences => 'Preferências';

  @override
  String get myWorkAreas => 'Minhas áreas de trabalho';

  @override
  String get currentLocationMap => 'Mapa de localização atual';

  @override
  String get next => 'Próximo';

  @override
  String get pleaseSelectYourRole => 'Selecione sua função';

  @override
  String get micAndCameraPermissionsRequired =>
      'Permissões de microfone e câmera são necessárias';

  @override
  String get userIsBusyOrUnavailable =>
      'O usuário está ocupado ou indisponível';

  @override
  String get paymentSuccessful => 'Pagamento realizado com sucesso';

  @override
  String get accessLocked => 'ACESSO BLOQUEADO';

  @override
  String get subscriptionRequired => 'Assinatura necessária';

  @override
  String get startFreeTrialToReceiveRequests =>
      'Comece seu teste gratuito de 30 dias para receber e gerenciar solicitações de clientes.';

  @override
  String get startFreeTrial => 'Iniciar teste gratuito';

  @override
  String get youCanStillManageProfile =>
      'Você ainda pode gerenciar seu perfil, serviços e horários.';

  @override
  String get tryIumiProviderFree => 'Experimente IUMI Provider grátis';

  @override
  String get unlockEveryFeature =>
      'Desbloqueie todos os recursos do prestador por 30 dias.';

  @override
  String get thirtyDaysFree => '30 DIAS GRÁTIS';

  @override
  String get receiveCustomerRequests => 'Receber solicitações de clientes';

  @override
  String get acceptOrDeclineBookings => 'Aceitar ou recusar reservas';

  @override
  String get contactCustomersAfterAcceptance =>
      'Contatar clientes após aceitação';

  @override
  String get manageYourSchedule => 'Gerenciar seu horário';

  @override
  String get freeFor30Days => 'Grátis por 30 dias';

  @override
  String get then4999RonMonthCancelAnytime =>
      'Depois 49,99 RON/mês. Cancele quando quiser.';

  @override
  String get start30DayFreeTrial => 'Iniciar teste gratuito de 30 dias';

  @override
  String get upgradePremium => 'Upgrade Premium';

  @override
  String get notNow => 'Agora não';

  @override
  String get noPaymentToday =>
      'Sem pagamento hoje. Funciona em iOS, Android e web.';

  @override
  String get somethingWentWrong => 'Algo deu errado';

  @override
  String get seeMore => 'Ver mais';

  @override
  String get documents => 'Documentos';

  @override
  String get chooseYourPlan => 'Escolha o seu plano';

  @override
  String get noPlansAvailable => 'Nenhum plano disponível no momento.';

  @override
  String get checkBackLater =>
      'Por favor, verifique novamente mais tarde ou contate o suporte.';

  @override
  String get upgradeToPremium => 'Atualizar para Premium';

  @override
  String get unlockAllFeatures =>
      'Desbloqueie todos os recursos e expanda seus negócios.';

  @override
  String savePercent(String percent) {
    return 'Economize $percent%';
  }

  @override
  String get alreadySubscribed => 'Você já está inscrito neste plano.';

  @override
  String get planNotAvailable =>
      'Este plano ainda não está disponível para compra nesta plataforma. Tente novamente mais tarde.';

  @override
  String successfullySubscribed(String planName) {
    return 'Inscrito com sucesso em $planName!';
  }

  @override
  String get subscribeNow => 'Inscreva-se agora';

  @override
  String get messageSentSuccessfully => 'Sua mensagem foi enviada com sucesso.';

  @override
  String get failedToSendMessage =>
      'Falha ao enviar mensagem. Por favor, tente novamente.';

  @override
  String get pleaseSelectDocument =>
      'Por favor, selecione pelo menos um documento para prosseguir.';

  @override
  String get documentsUpdatedSuccessfully =>
      'Documentos atualizados com sucesso';

  @override
  String get pleaseEnterValidPricePerHour =>
      'Por favor, insira um preço válido por hora';

  @override
  String get listingUpdatedSuccessfully => 'Anúncio atualizado com sucesso';

  @override
  String get failedToSubmitReview => 'Falha ao enviar avaliação';

  @override
  String get reviewSubmittedSuccessfully => 'Avaliação enviada com sucesso';

  @override
  String get failedToSaveSchedule =>
      'Falha ao salvar o horário. Tente novamente.';

  @override
  String get pleaseFillOutAllFields => 'Por favor, preencha todos os campos.';

  @override
  String get pleaseSelectFlexibleStartTime =>
      'Por favor, selecione um horário de início flexível ou use \'Pular\'.';

  @override
  String get outstanding => 'Excelente';

  @override
  String get hello => 'Olá';

  @override
  String get description => 'Descrição';

  @override
  String get copyrightIBadi => 'Copyright iBadi';

  @override
  String get badi => 'Badi';

  @override
  String get download => 'Baixar';

  @override
  String get end => 'Fim';

  @override
  String get markAllRead => 'Marcar tudo como lido';

  @override
  String get goBack => 'Voltar';

  @override
  String get iumiAdminSupport => 'Suporte Admin Iumi';

  @override
  String get emailAddress => 'Endereço de email';

  @override
  String get subject => 'Assunto';

  @override
  String get yourMessage => 'Sua mensagem';

  @override
  String get sayHello => 'Diga olá 👋';

  @override
  String get chooseOption => 'Escolher opção';

  @override
  String get settings => 'Configurações';

  @override
  String get completePayment => 'Concluir pagamento';

  @override
  String get noMessages => 'Sem mensagens';

  @override
  String get noNotification => 'Sem notificação';

  @override
  String get noScheduleAvailable => 'Nenhum horário disponível.';

  @override
  String get additionalComments => 'Comentários adicionais';

  @override
  String get gallery => 'Galeria';

  @override
  String get failedToLoadGallery => 'Falha ao carregar galeria';

  @override
  String get noImagesAvailable => 'Nenhuma imagem disponível';

  @override
  String get viewGallery => 'Ver galeria';

  @override
  String get noGalleryImageFound => 'Nenhuma imagem na galeria';

  @override
  String get comments => 'Comentários';

  @override
  String get noCommentsFound => 'Nenhum comentário encontrado';

  @override
  String get serviceFrequency => 'Frequência do serviço';

  @override
  String get howManyTimesDoYouWantTheService =>
      'Quantas vezes você quer o serviço?';

  @override
  String get rateYourExperience => 'Avalie sua experiência';

  @override
  String get deleteThisAddress => 'Excluir este endereço?';

  @override
  String get showSpecialistsIn => 'Mostrar especialistas em:';

  @override
  String get ok => 'OK';

  @override
  String get chooseFromGallery => 'Escolher da galeria';

  @override
  String get takeAPhoto => 'Tirar uma foto';

  @override
  String get profilePicture => 'Foto do perfil';

  @override
  String get doYouWantToGoBack => 'Deseja voltar?';

  @override
  String get startYour30DayFreeTrialToReceiveAndManageCustomerRequests =>
      'Comece seu teste gratuito de 30 dias para receber e gerenciar solicitações de clientes.';

  @override
  String get youCanStillManageYourProfileServicesAndSchedule =>
      'Você ainda pode gerenciar seu perfil, serviços e horários.';
}
