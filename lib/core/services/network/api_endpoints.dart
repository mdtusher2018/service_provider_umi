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
}
