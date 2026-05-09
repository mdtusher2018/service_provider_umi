class AppRoutes {
  AppRoutes._();

  // ─── General ─────────────────────────────────────────────
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String guestOnboarding = '/guest-onboarding';

  // ─── User Shell Tabs ─────────────────────────────────────
  static const String services = '/user/services';
  static const String favourites = '/user/favourites';
  static const String userHome = '/user/home';
  static const String inbox = '/user/inbox';
  static const String profile = '/user/profile';

  // ─── Provider Shell Tabs ──────────────────────────────────
  static const String providerServices = '/provider/services';
  static const String providerInbox = '/provider/inbox';
  static const String providerHome = '/provider/home';
  static const String providerNotifications = '/provider/notifications';
  static const String providerProfile = '/provider/profile';

  // ─── Auth ────────────────────────────────────────────────
  static const String phoneNumber = '/auth/phone';
  static const String verifyOtp = '/auth/verify-otp';
  static const String profilePicture = '/auth/profile-picture';
  static const String providerOnboarding = '/service-provider-onboarding';

  // ─── Service discovery ───────────────────────────────────
  static const String search = '/search';
  static const String searchResults = '/search-results';
  static const String filter = '/search-results/filter';
  static const String providerProfileView = '/service-provider/:providerId';
  static const searchTime = ':serviceId/search-time';

  // ─── Booking flow ────────────────────────────────────────
  static const String bookingSchedule = '/booking/schedule';
  static const String bookingDetail = '/booking/:bookingId';
  static const String myBookings = '/booking/my-bookings';

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
  static const String staticPage = '/profile/:type';

  // ─── Communication ───────────────────────────────────────
  static const String chat = '/chat/:contactId';
  static const String audioCall = '/audio/:contactId';
  static const String videoCall = '/video/:contactId';

  // ─── Provider-specific screens ───────────────────────────
  static const String providerCompletedServiceScreen =
      '/service-provider-completed-screen';

  // ─── Helpers ─────────────────────────────────────────────
  static String providerProfilePath(String id) => '/service-provider/$id';
  static String bookingDetailPath(String id) => '/booking/$id';
  static String chatPath(String contactId) => '/chat/$contactId';
  static String audioCallPath(String contactId) => '/audio/$contactId';
  static String videoCallPath(String contactId) => '/video/$contactId';
  static String staticPagePath(String type) => '/profile/$type';
  static String searchTimePath(String serviceId) {
    return '$userHome/$serviceId/search-time';
  }
}
