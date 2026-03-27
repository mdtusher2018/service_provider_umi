class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'YourAppName';
  static const String appVersion = '1.0.0';

  // Assets
  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';
  static const String _animationsPath = 'assets/animations';

  static const String logoImage = '$_imagesPath/logo.png';
  static const String placeholderImage = '$_imagesPath/placeholder.png';
  static const String onboarding1 = '$_imagesPath/onboarding_1.png';
  static const String onboarding2 = '$_imagesPath/onboarding_2.png';
  static const String onboarding3 = '$_imagesPath/onboarding_3.png';

  static const String splashAnimation = '$_animationsPath/splash.json';
  static const String loadingAnimation = '$_animationsPath/loading.json';
  static const String successAnimation = '$_animationsPath/success.json';
  static const String emptyAnimation = '$_animationsPath/empty.json';

  static const String settingsIcon = '$_iconsPath/settings.svg';
  static const String notificationIcon = '$_iconsPath/notification.svg';

  // Date Formats
  static const String dateFormat = 'dd MMM yyyy';
  static const String timeFormat = 'hh:mm a';
  static const String dateTimeFormat = 'dd MMM yyyy, hh:mm a';
  static const String apiDateFormat = 'yyyy-MM-dd';

  // Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration snackbarDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration debounceDelay = Duration(milliseconds: 500);

  // Limits
  static const int otpLength = 6;
  static const int maxFavorites = 100;
  static const int searchMinChars = 2;
  static const double maxRating = 5.0;

  // Map
  static const double defaultMapZoom = 14.0;
  static const double defaultLatitude = 0.0;
  static const double defaultLongitude = 0.0;

  // Regex
  static const String emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^\+?[0-9]{8,15}$';
  static const String passwordRegex =
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';

  // Supported Locales
  static const List<String> supportedLocales = ['en', 'ar', 'fr'];
  static const String defaultLocale = 'en';
}
