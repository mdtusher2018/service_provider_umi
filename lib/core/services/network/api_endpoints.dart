class ApiEndpoints {
  ApiEndpoints._();

  // ─── Auth ───────────────────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/users';
  static const String refreshToken = '/auth/refresh-token';
  static const String googleLogin = '/auth/google-login';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';

  // ─── OTP ────────────────────────────────────────────────────────────────────
  static const String verifyOtp = '/otp/verify-otp';
  static const String resendOtp = '/otp/resend-otp';

  // ─── User ───────────────────────────────────────────────────────────────────
  static String getUserById(String id) => '/users/$id';
  static const String myProfile = '/users/my-profile';
  static const String updateMyProfile = '/users/update-my-profile';
  static const String deleteMyAccount = '/users/delete-my-account';
  static const String profileVerified = '/users/profile-verified';

  // ─── Notifications ──────────────────────────────────────────────────────────
  static const String notifications = '/notifications';
  static const String callHistory = '/call-history';

  // ─── Contents ───────────────────────────────────────────────────────────────
  static const String contents = '/contents';

  // ─── Categories ─────────────────────────────────────────────────────────────
  static const String services = '/categories';
  static const String serviceById = '/categories/{id}';

  // ─── Support ────────────────────────────────────────────────────────────────
  static const String support = '/support';

  // ─── Favorites ──────────────────────────────────────────────────────────────
  static const String favorites = '/favorites';

  // ─── Address ────────────────────────────────────────────────────────────────
  static const String addresses = '/address';
  static String addressById(String id) => '/address/$id';

  // ─── Sub Categories ─────────────────────────────────────────────────────────
  static const String subCategories = '/sub-categories/{id}';

  // ─── Chat ─────────────────────────────────────────────────────────
  static String getChatId(String receiverId) =>
      '/chat/get-by-user-id/$receiverId';

  // ─── Booking ────────────────────────────────────────────────────────────────
  static const String bookingDetail = '/bookings/{id}';
  static const String userBookings = '/bookings/user-booking';
  static const String providerBookings = '/bookings/provider-booking';
  static const String createBooking = '/bookings';
  static const String confirmPayment = '/payments/payout';

  static String acceptBooking(String id) => '/bookings/accept/$id';
  static String cancelBooking(String id) => '/bookings/canceled/$id';
  static String completeBooking(String id) => '/bookings/complete/$id';
  static String updateBooking(String id) =>
      '/bookings/$id?include=user,provider,payments';

  // ─── FAQs ───────────────────────────────────────────────────────────────────
  static const String faqs = '/faq';
  static const String giveReview = '/reviews';

  // ─── Provider ───────────────────────────────────────────────────────────────
  static String providerProfile(String id) => '/users/$id';
  static String providerReviews(String id) => '/reviews/user/$id';
  static const String updateServiceProviderProfile =
      '/users/service-provider-info';
  static const String stripeConnect = '/stripe/connect';

  // ─── Filters & Search ───────────────────────────────────────────────────────
  static const String serviceExperience = '/experience-options';
  static const String serviceOthersTaskOptions = '/others-task-options';
  static const String searchProviders = '/homepage';

  static const String workSchedule = '/workSchedule';

  static const String getMyPaymentCards = "/stripe/payment-method";
  static String deletePaymentCard(String paymentMethodId) =>
      "/stripe/payment-method/$paymentMethodId";
  static String setDefaultPaymentCard(String paymentMethodId) =>
      "/stripe/payment-method/default/$paymentMethodId";
  static const String getAddCardLink = "/stripe/payment-method/add-link";

  static const String availability = "/homepage/availability";
}
