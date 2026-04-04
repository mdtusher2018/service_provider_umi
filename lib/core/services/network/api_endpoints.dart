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
  static const String getUserById = '/users/{id}';
  static const String myProfile = '/users/my-profile';
  static const String updateMyProfile = '/users/update-my-profile';
  static const String deleteMyAccount = '/users/delete-my-account';

  // ─── Notifications ──────────────────────────────────────────────────────────
  static const String notifications = '/notifications';

  // ─── Contents ───────────────────────────────────────────────────────────────
  static const String contents = '/contents';

  // ─── Categories ─────────────────────────────────────────────────────────────
  static const String services = '/categories';
  static const String serviceById = '/categories/{id}';

  // ─── MOCK ─────────────────────────────────────────────────────────────

  // ─── Support ────────────────────────────────────────────────────────────────
  static const String support = '/support';

  // ─── Favorites ──────────────────────────────────────────────────────────────
  static const String favorites = '/favorites';

  // ─── Address ────────────────────────────────────────────────────────────────
  static const String addAddress = '/addresses';
  static const String savedAddresses = '/addresses';

  // ─── Sub Categories ─────────────────────────────────────────────────────────
  static const String subCategories = '/sub-categories/{id}';

  // ─── Booking ────────────────────────────────────────────────────────────────
  static const String bookingDetail = '/bookings/{id}';
  static const String myBookings = '/bookings';
  static const String createBooking = '/bookings';

  // ─── FAQs ───────────────────────────────────────────────────────────────────
  static const String faqs = '/faqs';

  // ─── Provider ───────────────────────────────────────────────────────────────
  static const String providerProfile = '/providers/{id}';

  // ─── Filters & Search ───────────────────────────────────────────────────────
  static const String serviceFilters = '/services/filters';
  static const String searchProviders = '/providers/search';
}
