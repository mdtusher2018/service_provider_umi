// ignore_for_file: dead_code

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app_routes.dart';

// Inject your auth provider here
// import '../../../features/auth/presentation/providers/auth_provider.dart';

class AuthGuard {
  static String? redirect(Ref ref, GoRouterState state) {
    // final authState = ref.read(authNotifierProvider);
    // final isAuthenticated = authState is AuthStateAuthenticated;
    // final isGuest = authState is AuthStateGuest;

    // Temporary: replace with real auth check
    const isAuthenticated = false;
    const isGuest = true;

    final location = state.uri.toString();
    final isAuthRoute = _authRoutes.contains(location);

    if (!isAuthenticated && !isGuest && !isAuthRoute) {
      return AppRoutes.login;
    }

    if (isAuthenticated && isAuthRoute) {
      return AppRoutes.userHome;
    }

    return null;
  }

  static const Set<String> _authRoutes = {
    AppRoutes.login,

    AppRoutes.verifyOtp,
    AppRoutes.onboarding,
    AppRoutes.splash,
  };

  // Routes accessible in guest mode
  static const Set<String> _guestAllowedRoutes = {
    AppRoutes.userHome,
    AppRoutes.filter,
    AppRoutes.search,
    AppRoutes.searchResults,
    AppRoutes.serviceSubCategory,
    AppRoutes.bookingTime,
    AppRoutes.providerProfile,
  };

  static bool isGuestAllowed(String path) {
    return _guestAllowedRoutes.any((route) => path.startsWith(route));
  }
}
