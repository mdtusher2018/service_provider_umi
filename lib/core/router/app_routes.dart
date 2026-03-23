class AppRoutes {
  AppRoutes._();

  // ─── General ─────────────────────────────────────────────
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String guestOnboarding = '/guest-onboarding';
  static const String login = '/login';

  // ─── User Shell (bottom nav) ─────────────────────────────
  static const String userHome = '/user/home';
  static const String userBookings = '/user/bookings';
  static const String userFavorites = '/user/favorites';
  static const String userChat = '/user/chat';

  // ─── Service discovery ───────────────────────────────────
  static const String search = '/search';
  static const String searchResults = '/search/results';
  static const String filter = '/search/filter';
  static const String serviceSubCategory = '/service/subcategory';
  static const String providerProfile = '/provider/:providerId';

  // ─── Booking flow ────────────────────────────────────────
  static const String bookingTime = '/booking/time';
  static const String bookingSchedule = '/booking/schedule';
  static const String bookingDetail = '/booking/:bookingId';
  static const String myBookings = "/booking/my-bookings";

  // ─── Profile sub-screens ─────────────────────────────────
  static const String personalDetails = '/profile/personal-details';
  static const String myAddresses = '/profile/addresses';
  static const String addAddress = '/profile/addresses/add';
  static const String payments = '/profile/payments';
  static const String myBalance = '/profile/balance';
  static const String providerListing = '/profile/listing';
  static const String preferences = '/profile/preferences';
  static const String workAreas = '/profile/preferences/work-areas';
  static const String workSchedule = '/profile/preferences/schedule';
  static const String minimumPrice = '/profile/preferences/min-price';
  static const String providerReviews = '/profile/reviews';
  static const String changePassword = '/profile/change-password';
  static const String language = '/profile/language';
  static const String staticPage = '/page/:type';
  static const String notifications = '/notifications';

  // ─── Auth ────────────────────────────────────────────────
  static const String phoneNumber = '/auth/phone';
  static const String verifyOtp = '/auth/verify-otp';
  static const String profilePicture = '/auth/profile-picture';
  static const String providerOnboarding = '/provider-onboarding';

  // ─── Communication ───────────────────────────────────────
  static const String chat = '/chat/:contactId';
  static const String audioCall = '/audio/:contactId';
  static const String videoCall = '/video/:contactId';

  // ─── Provider Shell (bottom nav) ─────────────────────────
  static const String providerDashboard = '/provider-dashboard';
  static const String providerServices = '/provider-services';
  static const String providerUpcomingBookings = '/provider-upcoming-bookings';
  static const String providerNotification = '/provider-notification';
  static const String providerChat = '/provider-chat';

  static const String providerProfileRoot = '/profile';
  static const String providerCompletedServiceScreen =
      '/provider-completed-service-screen';

  // ─── Helpers ─────────────────────────────────────────────
  static String providerProfilePath(String id) => '/provider/$id';
  static String bookingDetailPath(String id) => '/booking/$id';
  static String chatPath(String contactId) => '/chat/$contactId';
  static String audioCallPath(String contactId) => '/audio/$contactId';
  static String videoCallPath(String contactId) => '/video/$contactId';
  static String staticPagePath(String type) => '/page/$type';
}
