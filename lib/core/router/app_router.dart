import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_routes.dart';
import 'guards/auth_guard.dart';
import 'guards/role_guard.dart';
import '../../shared/enums/user_role.dart';

// Import screens (update paths as you build features)
// import '../../features/splash/presentation/splash_screen.dart';
// ... etc

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _userShellKey = GlobalKey<NavigatorState>(debugLabel: 'userShell');
final _providerShellKey = GlobalKey<NavigatorState>(
  debugLabel: 'providerShell',
);

@riverpod
GoRouter appRouter(Ref ref) {
  // final authState = ref.watch(authNotifierProvider);
  // final activeRole = ref.watch(activeRoleProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // 1. Auth guard
      final authRedirect = AuthGuard.redirect(ref, state);
      if (authRedirect != null) return authRedirect;

      // 2. Role guard
      const activeRole = UserRole.user; // replace with real provider
      final roleRedirect = RoleGuard.redirect(activeRole, state);
      if (roleRedirect != null) return roleRedirect;

      return null;
    },
    routes: [
      // ─── Splash ──────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) =>
            const Scaffold(body: Center(child: Text('Splash Screen'))),
      ),

      // ─── Onboarding ──────────────────────────────────────
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) =>
            const Scaffold(body: Center(child: Text('Onboarding Screen'))),
      ),

      // ─── Role Switch ─────────────────────────────────────
      GoRoute(
        path: AppRoutes.roleSwitch,
        builder: (_, __) =>
            const Scaffold(body: Center(child: Text('Role Switch Screen'))),
      ),

      // ─── Auth Routes ─────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) =>
            const Scaffold(body: Center(child: Text('Login Screen'))),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) =>
            const Scaffold(body: Center(child: Text('Register Screen'))),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, __) =>
            const Scaffold(body: Center(child: Text('Forgot Password Screen'))),
      ),
      GoRoute(
        path: AppRoutes.verifyOtp,
        builder: (_, __) =>
            const Scaffold(body: Center(child: Text('OTP Screen'))),
      ),

      // ─── Notifications ───────────────────────────────────
      GoRoute(
        path: AppRoutes.notifications,
        builder: (_, __) =>
            const Scaffold(body: Center(child: Text('Notifications Screen'))),
      ),

      // ─── Chat Detail ─────────────────────────────────────
      GoRoute(
        path: AppRoutes.chatDetail,
        builder: (context, state) {
          final conversationId = state.pathParameters['conversationId']!;
          return Scaffold(body: Center(child: Text('Chat: $conversationId')));
        },
      ),

      // ─── Audio Call ──────────────────────────────────────
      GoRoute(
        path: AppRoutes.audioCall,
        builder: (context, state) {
          final channelId = state.pathParameters['channelId']!;
          return Scaffold(body: Center(child: Text('Audio Call: $channelId')));
        },
      ),

      // ─── Video Call ──────────────────────────────────────
      GoRoute(
        path: AppRoutes.videoCall,
        builder: (context, state) {
          final channelId = state.pathParameters['channelId']!;
          return Scaffold(body: Center(child: Text('Video Call: $channelId')));
        },
      ),

      // ─── User Shell (Bottom Nav) ──────────────────────────
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, shell) {
          // Replace with your real UserShellScreen
          return Scaffold(body: shell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _userShellKey,
            routes: [
              GoRoute(
                path: AppRoutes.userHome,
                builder: (_, __) =>
                    const Scaffold(body: Center(child: Text('User Home'))),
                routes: [
                  GoRoute(
                    path: 'services/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return Scaffold(
                        body: Center(child: Text('Service Detail: $id')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.userBookings,
                builder: (_, __) =>
                    const Scaffold(body: Center(child: Text('Bookings'))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.userFavorites,
                builder: (_, __) =>
                    const Scaffold(body: Center(child: Text('Favorites'))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.userChat,
                builder: (_, __) =>
                    const Scaffold(body: Center(child: Text('Chat'))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.userProfile,
                builder: (_, __) =>
                    const Scaffold(body: Center(child: Text('Profile'))),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (_, __) => const Scaffold(
                      body: Center(child: Text('Edit Profile')),
                    ),
                  ),
                  GoRoute(
                    path: 'change-password',
                    builder: (_, __) => const Scaffold(
                      body: Center(child: Text('Change Password')),
                    ),
                  ),
                  GoRoute(
                    path: 'about-us',
                    builder: (_, __) =>
                        const Scaffold(body: Center(child: Text('About Us'))),
                  ),
                  GoRoute(
                    path: 'terms',
                    builder: (_, __) =>
                        const Scaffold(body: Center(child: Text('Terms'))),
                  ),
                  GoRoute(
                    path: 'privacy',
                    builder: (_, __) =>
                        const Scaffold(body: Center(child: Text('Privacy'))),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // ─── Provider Shell (Bottom Nav) ──────────────────────
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, shell) {
          return Scaffold(body: shell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _providerShellKey,
            routes: [
              GoRoute(
                path: AppRoutes.providerDashboard,
                builder: (_, __) => const Scaffold(
                  body: Center(child: Text('Provider Dashboard')),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.providerServices,
                builder: (_, __) => const Scaffold(
                  body: Center(child: Text('Provider Services')),
                ),
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (_, __) => const Scaffold(
                      body: Center(child: Text('Create Service')),
                    ),
                  ),
                  GoRoute(
                    path: ':id/edit',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return Scaffold(
                        body: Center(child: Text('Edit Service $id')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.providerHistory,
                builder: (_, __) => const Scaffold(
                  body: Center(child: Text('Provider History')),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.providerMap,
                builder: (_, __) =>
                    const Scaffold(body: Center(child: Text('Provider Map'))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.providerChat,
                builder: (_, __) =>
                    const Scaffold(body: Center(child: Text('Provider Chat'))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.providerProfile,
                builder: (_, __) => const Scaffold(
                  body: Center(child: Text('Provider Profile')),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
