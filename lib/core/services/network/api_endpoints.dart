class ApiEndpoints {
  ApiEndpoints._();

  // ─── Auth ──────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/users';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyOtp = '/otp/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String socialLogin = '/auth/social-login';

  // ─── Profile ───────────────────────────────────────────
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  static const String changePassword = '/user/change-password';
  static const String deleteAccount = '/user/delete-account';
  static const String uploadAvatar = '/user/avatar';

  // ─── Phone Verification ────────────────────────────────
  static const String sendPhoneOtp = '/phone/send-otp';
  static const String verifyPhone = '/phone/verify';

  // ─── Services (User) ───────────────────────────────────
  static const String services = '/services';
  static const String popularServices = '/services/popular';
  static const String serviceDetail = '/services/{id}';
  static const String filterServices = '/services/filter';
  static const String searchServices = '/services/search';

  // ─── Bookings (User) ───────────────────────────────────
  static const String createBooking = '/bookings';
  static const String bookingHistory = '/bookings/history';
  static const String bookingDetail = '/bookings/{id}';
  static const String cancelBooking = '/bookings/{id}/cancel';

  // ─── Ratings ───────────────────────────────────────────
  static const String submitRating = '/ratings';
  static const String getProviderRatings = '/ratings/provider/{id}';

  // ─── Favorites ─────────────────────────────────────────
  static const String favorites = '/favorites';
  static const String toggleFavorite = '/favorites/toggle';

  // ─── Payments ──────────────────────────────────────────
  static const String createPaymentIntent = '/payments/intent';
  static const String paymentHistory = '/payments/history';
  static const String confirmPayment = '/payments/confirm';

  // ─── Notifications ─────────────────────────────────────
  static const String notifications = '/notifications';
  static const String markNotificationRead = '/notifications/{id}/read';
  static const String markAllRead = '/notifications/read-all';
  static const String registerDeviceToken = '/notifications/device-token';

  // ─── Chat ──────────────────────────────────────────────
  static const String conversations = '/chat/conversations';
  static const String messages = '/chat/conversations/{id}/messages';
  static const String sendMessage = '/chat/send';

  // ─── Service Provider ──────────────────────────────────
  static const String spServices = '/provider/services';
  static const String createService = '/provider/services';
  static const String updateService = '/provider/services/{id}';
  static const String spBookingRequests = '/provider/bookings/requests';
  static const String spOngoingBookings = '/provider/bookings/ongoing';
  static const String spCancelledBookings = '/provider/bookings/cancelled';
  static const String spBookingHistory = '/provider/bookings/history';
  static const String acceptBooking = '/provider/bookings/{id}/accept';
  static const String rejectBooking = '/provider/bookings/{id}/reject';
  static const String spReviews = '/provider/reviews';
  static const String blockUser = '/provider/users/{id}/block';
  static const String unblockUser = '/provider/users/{id}/unblock';

  // ─── Map ───────────────────────────────────────────────
  static const String serviceArea = '/provider/service-area';
  static const String updateServiceArea = '/provider/service-area/update';
  static const String nearbyProviders = '/map/nearby';

  // ─── Static Pages ──────────────────────────────────────
  static const String aboutUs = '/pages/about-us';
  static const String termsConditions = '/pages/terms-conditions';
  static const String privacyPolicy = '/pages/privacy-policy';

  // ─── Admin ─────────────────────────────────────────────
  static const String switchRole = '/user/switch-role';
}
