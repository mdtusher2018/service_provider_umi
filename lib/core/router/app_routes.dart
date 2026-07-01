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
  static const String verificationProviderDocument =
      '/service-provider-document-verification';

  // ─── Service discovery ───────────────────────────────────
  static const String search = '/search';
  static const String searchResults = '/search-results/:serviceId';
  static const String filter = '/search-results/:serviceId/filter';
  static const String providerProfileView = '/service-provider/:providerId';
  static const searchTime = ':serviceId/search-time';

  // ─── Booking flow ────────────────────────────────────────
  static const String bookingSchedule = '/booking/schedule/:providerId';
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
  static const String addFaq = '/profile/add-faq';
  static const String staticPage = '/profile/:type';
  static const String paymentCardsPage = '/my-cards-page';

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
  static String bookingSchedulePath(
    String id, {
    required price,
    required frequency,
  }) => '/booking/schedule/$id?price=$price&frequency=$frequency';

  static String filterPath(String id) => '/search-results/$id/filter';
  static String chatPath(String contactId) => '/chat/$contactId';
  static String audioCallPath(String contactId) => '/audio/$contactId';
  static String videoCallPath(String contactId) => '/video/$contactId';
  static String staticPagePath(String type) => '/profile/$type';
  static String searchTimePath(String serviceId) {
    return '$userHome/$serviceId/search-time';
  }

  static String searchResultPath(
    String serviceId, {
    // Scheduling
    String? bookingType,
    String? date,
    String? days,
    String? startTimeType,
    String? flexibleSlot,
    String? startTime,
    String? endTime,
    String? duration,
    // Text / Category
    String? searchTerm,
    String? categoryId,

    // Filters
    String? experienceOptionId,
    String? otherTaskIds,
    String? minPrice,
    String? maxPrice,
    String? qualifiedCarer,
    String? palliativeCare,
    String? drivingLicense,
    String? businessProfiles,
    // Pagination / Sort
    String? page,
    String? limit,
  }) {
    final q = <String, String>{};

    void add(String key, String? value) {
      if (value != null && value.isNotEmpty) q[key] = value;
    }

    add('bookingType', bookingType);
    add('date', date);
    add('days', days);
    add('startTimeType', startTimeType);
    add('flexibleSlot', flexibleSlot);
    add('startTime', startTime);
    add('endTime', endTime);
    add('duration', duration);
    add('searchTerm', searchTerm);
    add('categoryId', categoryId);
    add('experienceOptionId', experienceOptionId);
    add('otherTaskIds', otherTaskIds);
    add('minPrice', minPrice);
    add('maxPrice', maxPrice);
    add('qualifiedCarer', qualifiedCarer);
    add('palliativeCare', palliativeCare);
    add('drivingLicense', drivingLicense);
    add('businessProfiles', businessProfiles);
    add('page', page);
    add('limit', limit);

    return Uri(
      path: '/search-results/$serviceId',
      queryParameters: q.isEmpty ? null : q,
    ).toString();
  }

  // ── Helper: merge existing params with new filter overrides ───────────────
  /// Call this from FilterScreen / header search to build the new path while
  /// keeping all existing scheduling params intact.
  static String searchResultPathMerged({
    required String serviceId,
    required Map<String, String> existingParams,
    // any of these non-null values WIN over the existing params:
    String? searchTerm,
    String? categoryId,

    String? experienceOptionId,
    String? otherTaskIds,
    String? minPrice,
    String? maxPrice,
    String? qualifiedCarer,
    String? palliativeCare,
    String? drivingLicense,
    String? businessProfiles,
  }) {
    // Start from existing params, then selectively override.
    final merged = Map<String, String>.from(existingParams);

    void override(String key, String? value) {
      if (value != null) {
        if (value.isEmpty) {
          merged.remove(key); // empty string = clear the param
        } else {
          merged[key] = value;
        }
      }
    }

    // Reset to page 1 whenever filters change.
    merged['page'] = '1';

    override('searchTerm', searchTerm);
    override('categoryId', categoryId);

    override('experienceOptionId', experienceOptionId);
    override('otherTaskIds', otherTaskIds);
    override('minPrice', minPrice);
    override('maxPrice', maxPrice);
    override('qualifiedCarer', qualifiedCarer);
    override('palliativeCare', palliativeCare);
    override('drivingLicense', drivingLicense);
    override('businessProfiles', businessProfiles);

    return Uri(
      path: '/search-results/$serviceId',
      queryParameters: merged.isEmpty ? null : merged,
    ).toString();
  }
}
