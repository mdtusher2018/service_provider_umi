class AppRoutes {
  AppRoutes._();

  // ─── General ─────────────────────────────────────────────
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSwitch = '/role-switch';

  // ─── Auth ────────────────────────────────────────────────
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verifyOtp = '/verify-otp';

  // ─── User Shell ──────────────────────────────────────────
  static const String userShell = '/user';
  static const String userHome = '/user/home';
  static const String userBookings = '/user/bookings';
  static const String userFavorites = '/user/favorites';
  static const String userChat = '/user/chat';
  static const String userProfile = '/user/profile';

  // ─── Service Discovery ───────────────────────────────────
  static const String serviceDetail = '/user/services/:id';
  static const String serviceFilter = '/user/services/filter';
  static const String serviceSearch = '/user/services/search';

  // ─── Booking ─────────────────────────────────────────────
  static const String bookService = '/user/book/:serviceId';
  static const String bookingConfirmation = '/user/booking/confirmation';
  static const String bookingHistory = '/user/booking/history';

  // ─── Payments ────────────────────────────────────────────
  static const String payment = '/user/payment';

  // ─── Profile ─────────────────────────────────────────────
  static const String editProfile = '/profile/edit';
  static const String changePassword = '/profile/change-password';
  static const String aboutUs = '/profile/about-us';
  static const String termsConditions = '/profile/terms';
  static const String privacyPolicy = '/profile/privacy';

  // ─── Notifications ───────────────────────────────────────
  static const String notifications = '/notifications';

  // ─── Chat ────────────────────────────────────────────────
  static const String chatDetail = '/chat/:conversationId';

  // ─── Calls ───────────────────────────────────────────────
  static const String audioCall = '/call/audio/:channelId';
  static const String videoCall = '/call/video/:channelId';

  // ─── Service Provider Shell ──────────────────────────────
  static const String providerShell = '/provider';
  static const String providerDashboard = '/provider/dashboard';
  static const String providerServices = '/provider/services';
  static const String providerHistory = '/provider/history';
  static const String providerMap = '/provider/map';
  static const String providerChat = '/provider/chat';
  static const String providerProfile = '/provider/profile';

  // ─── Provider Booking Management ─────────────────────────
  static const String providerBookingRequests = '/provider/bookings/requests';
  static const String providerOngoingBookings = '/provider/bookings/ongoing';
  static const String providerCancelledBookings = '/provider/bookings/cancelled';

  // ─── Provider Service Management ─────────────────────────
  static const String createService = '/provider/services/create';
  static const String editService = '/provider/services/:id/edit';

  // ─── Provider Reviews ────────────────────────────────────
  static const String providerReviews = '/provider/reviews';
}
