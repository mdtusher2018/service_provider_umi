import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/data/models/address_model.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/data/models/user_models.dart';
import 'package:service_provider_umi/featured/service/screens/booking_time_screen/booking_time_screen.dart';
import 'package:service_provider_umi/shared/widgets/exit_confirmation_wrapper.dart';
import 'package:service_provider_umi/featured/RootScreen.dart';
import 'package:service_provider_umi/featured/authentication/screens/provider_phone_number_screen.dart';
import 'package:service_provider_umi/featured/authentication/screens/profile_picture_screen/profile_picture_screen.dart';
import 'package:service_provider_umi/featured/authentication/screens/provider_onboarding.dart';
import 'package:service_provider_umi/featured/authentication/screens/provider_verify_code_screen.dart';
import 'package:service_provider_umi/featured/authentication/screens/welcome_screen/welcome_screen.dart';
import 'package:service_provider_umi/featured/communication_and_notification/screens/call_screen.dart';
import 'package:service_provider_umi/featured/communication_and_notification/screens/chat_screen/chat_screen.dart';
import 'package:service_provider_umi/featured/communication_and_notification/screens/communication_and_notification_screen/communication_and_notification_screen.dart';
import 'package:service_provider_umi/featured/favourites/favourites_screen.dart';
import 'package:service_provider_umi/featured/guest/guest_empty_screen.dart';
import 'package:service_provider_umi/featured/guest/guest_onboarding.dart';
import 'package:service_provider_umi/featured/profile/screen/change_password_screen.dart';
import 'package:service_provider_umi/featured/profile/screen/language_screen.dart';
import 'package:service_provider_umi/featured/profile/screen/my_addresses_screen.dart';
import 'package:service_provider_umi/featured/profile/screen/my_balance_screen.dart';
import 'package:service_provider_umi/featured/profile/screen/payments_screen.dart';
import 'package:service_provider_umi/featured/profile/screen/personal_details_screen.dart';
import 'package:service_provider_umi/featured/profile/screen/preferences/minimum_price_screen.dart';
import 'package:service_provider_umi/featured/profile/screen/preferences/preferences_screen.dart';
import 'package:service_provider_umi/featured/profile/screen/preferences/work_area_screen.dart';
import 'package:service_provider_umi/featured/profile/screen/profile_screen/profile_screen.dart';
import 'package:service_provider_umi/featured/profile/screen/provider_listing_screen/provider_listing_screen.dart';
import 'package:service_provider_umi/featured/service/screens/provider_profile_overview/provider_profile_screen.dart';
import 'package:service_provider_umi/featured/profile/screen/reviews_screen.dart';
import 'package:service_provider_umi/featured/profile/screen/static_page_screen.dart';
import 'package:service_provider_umi/featured/service/screens/booking_details_screen/booking_details_screen.dart';
import 'package:service_provider_umi/featured/service/screens/booking_schedule_screen/booking_schedule_screen.dart';
import 'package:service_provider_umi/featured/service/screens/provider_service_screen.dart';
import 'package:service_provider_umi/featured/service/screens/service_provider_home_screen.dart';
import 'package:service_provider_umi/featured/service/screens/service_search_screen/filter_screen.dart';
import 'package:service_provider_umi/featured/service/screens/service_search_screen/search_results/service_search_results_screen.dart';
import 'package:service_provider_umi/featured/service/screens/service_search_screen/search_screen.dart';
import 'package:service_provider_umi/featured/service/screens/user_home_screen/user_home_screen.dart';
import 'package:service_provider_umi/featured/service/screens/user_service_screen/user_service_screen.dart';
import 'package:service_provider_umi/featured/service/screens/work_schedule_screen/work_schedule_screen.dart';
import 'package:service_provider_umi/shared/enums/all_enums.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';
import 'package:service_provider_umi/shared/widgets/not_found_page_widget.dart';
import 'app_routes.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final role = ref.watch(appRoleProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    errorBuilder: (context, state) {
      return NotFoundScreen(error: state.error.toString());
    },

    redirect: (context, state) {
      final location = state.matchedLocation;

      // ← NEW: if already logged in, skip login screen
      if (location == AppRoutes.login) {
        if (role == AppRole.user) return AppRoutes.userHome;
        if (role == AppRole.provider) return AppRoutes.providerHome;
        return null; // guest stays on login
      }

      // Guard: provider can't access user shell
      if (role == AppRole.provider && location.startsWith('/user')) {
        return AppRoutes.providerHome;
      }

      // Guard: user/guest can't access provider shell
      if (role != AppRole.provider && location.startsWith('/provider')) {
        return AppRoutes.userHome;
      }

      return null;
    },

    routes: [
      // ── USER / GUEST SHELL ──────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return RootScreen(
            navigationShell: navigationShell,
            role: role == AppRole.provider ? AppRole.user : role,
          );
        },
        branches: [
          /// index 0 — Services
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.services,
                builder: (_, __) => Consumer(
                  builder: (context, ref, _) {
                    final r = ref.watch(appRoleProvider);
                    return r == AppRole.guest
                        ? const GuestServicesScreen()
                        : const UserServiceScreen();
                  },
                ),
              ),
            ],
          ),

          /// index 1 — Favourites
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favourites,
                builder: (_, __) => Consumer(
                  builder: (context, ref, _) {
                    final r = ref.watch(appRoleProvider);
                    return r == AppRole.guest
                        ? const GuestFavouritesScreen()
                        : const FavouritesScreen();
                  },
                ),
              ),
            ],
          ),

          /// index 2 — Home (FAB)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.userHome,
                builder: (_, __) => const UserHomeScreen(),
              ),
            ],
          ),

          /// index 3 — Inbox
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.inbox,
                builder: (_, __) => Consumer(
                  builder: (context, ref, _) {
                    final r = ref.watch(appRoleProvider);
                    return r == AppRole.guest
                        ? const GuestInboxScreen()
                        : const CommunicationAndNotificationScreen();
                  },
                ),
              ),
            ],
          ),

          /// index 4 — Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (_, __) => Consumer(
                  builder: (context, ref, _) {
                    final r = ref.watch(appRoleProvider);
                    return r == AppRole.guest
                        ? const GuestProfileScreen()
                        : const ProfileScreen();
                  },
                ),
              ),
            ],
          ),
        ],
      ),

      // ── PROVIDER SHELL ──────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return RootScreen(
            navigationShell: navigationShell,
            role: AppRole.provider,
          );
        },
        branches: [
          /// index 0 — Services/Calendar
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.providerServices,
                builder: (_, __) => const ProviderServiceScreen(),
              ),
            ],
          ),

          /// index 1 — Inbox/Chat
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.providerInbox,
                builder: (_, __) => const CommunicationAndNotificationScreen(),
              ),
            ],
          ),

          /// index 2 — Home (FAB)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.providerHome,
                builder: (_, __) => const ServiceProviderHomeScreen(),
              ),
            ],
          ),

          /// index 3 — Notifications
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.providerNotifications,
                builder: (_, __) => const CommunicationAndNotificationScreen(
                  isNotification: true,
                ),
              ),
            ],
          ),

          /// index 4 — Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.providerProfile,
                builder: (_, __) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Login / Welcome ──────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) =>
            const ExitConfirmationWrapper(child: WelcomeScreen()),
      ),

      // ── Guest Onboarding ────────────────────────────────
      GoRoute(
        path: AppRoutes.guestOnboarding,
        builder: (_, __) =>
            ExitConfirmationWrapper(child: GuestOnboardingScreen()),
      ),

      // ── Auth flow ───────────────────────────────────────
      GoRoute(
        path: AppRoutes.phoneNumber,
        builder: (_, __) => const ProviderPhoneNumberScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyOtp,
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return VerifyOTPScreen(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.profilePicture,
        builder: (_, __) => ProfilePictureScreen(),
      ),
      GoRoute(
        path: AppRoutes.providerOnboarding,
        builder: (_, __) => const ServiceProviderOnboardingScreen(),
      ),

      // ── Service discovery ────────────────────────────────
      GoRoute(
        path: "${AppRoutes.userHome}/${AppRoutes.searchTime}",
        builder: (_, __) => BookingTimeScreen(),
      ),
      GoRoute(
        path: AppRoutes.search + AppRoutes.searchTime,
        builder: (_, __) => BookingTimeScreen(),
      ),

      GoRoute(path: AppRoutes.search, builder: (_, __) => SearchScreen()),
      GoRoute(
        path: AppRoutes.searchResults,
        builder: (_, __) => SearchResultsScreen(),
      ),
      GoRoute(path: AppRoutes.filter, builder: (_, __) => FilterScreen()),
      GoRoute(
        path: AppRoutes.providerProfileView,
        builder: (context, state) {
          final id = state.pathParameters['providerId']!;
          return ProviderProfileOverviewScreen(providerId: id);
        },
      ),

      // ── Booking flow ─────────────────────────────────────
      GoRoute(
        path: AppRoutes.myBookings,
        builder: (_, __) => const MyBookingScreen(),
      ),
      GoRoute(
        path: AppRoutes.bookingSchedule,
        builder: (context, state) {
          final mode =
              state.extra as BookingFrequency? ?? BookingFrequency.once;
          return BookingScheduleScreen(bookingMode: mode);
        },
      ),
      GoRoute(
        path: AppRoutes.bookingDetail,
        builder: (context, state) {
          final booking = state.extra as BookingItem?;
          final fallback = BookingItem(
            bookingId: '',
            serviceName: '',
            serviceImageUrl: '',
            startTime: '',
            endTime: '',
            bookingDate: '',
            bookingStatus: BookingStatus.cancelled,
            paidOnDate: '',
            price: 0,
          );
          return BookingDetailScreen(booking: booking ?? fallback);
        },
      ),
      GoRoute(
        path: AppRoutes.providerCompletedServiceScreen,
        builder: (_, __) => ProviderCompletedServiceScreen(),
      ),

      // ── Profile sub-screens ──────────────────────────────
      GoRoute(
        path: AppRoutes.personalDetails,
        builder: (context, state) {
          final user = state.extra as UserProfile;
          return PersonalDetailsScreen(user: user);
        },
      ),
      GoRoute(
        path: AppRoutes.myAddresses,
        builder: (_, __) => const MyAddressesScreen(),
      ),
      GoRoute(
        path: AppRoutes.addAddress,
        builder: (context, state) {
          return AddressPage(address: state.extra as AddressModel?);
        },
      ),
      GoRoute(
        path: AppRoutes.payments,
        builder: (_, __) => const PaymentsScreen(),
      ),
      GoRoute(
        path: AppRoutes.myBalance,
        builder: (_, __) => const MyBalanceScreen(),
      ),
      GoRoute(
        path: AppRoutes.providerListing,
        builder: (_, __) => const ProviderListingScreen(),
      ),
      GoRoute(
        path: AppRoutes.preferences,
        builder: (_, __) => const PreferencesScreen(),
      ),
      GoRoute(
        path: AppRoutes.workAreas,
        builder: (_, __) => const WorkAreasScreen(),
      ),
      GoRoute(
        path: AppRoutes.workSchedule,
        builder: (_, __) => WorkScheduleScreen(),
      ),
      GoRoute(
        path: AppRoutes.minimumPrice,
        builder: (_, __) => const MinimumPriceScreen(),
      ),
      GoRoute(
        path: AppRoutes.providerReviews,
        builder: (_, __) => const ReviewsScreen(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        builder: (_, __) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.language,
        builder: (_, __) => const LanguageScreen(),
      ),
      GoRoute(
        path: AppRoutes.staticPage,
        builder: (context, state) {
          final type = state.pathParameters['type']!;
          final map = {
            'privacy': StaticPageType.privacy,
            'terms': StaticPageType.terms,
            'about-us': StaticPageType.aboutUs,
          };
          final titles = {
            'privacy': 'Privacy Policy',
            'terms': 'Terms & Conditions',
            'about-us': 'About Us',
          };
          return StaticPageScreen(
            title: titles[type] ?? type,
            type: map[type] ?? StaticPageType.aboutUs,
          );
        },
      ),

      // ── Chat & Calls ─────────────────────────────────────
      GoRoute(
        path: AppRoutes.chat,
        builder: (context, state) {
          final chatId = state.pathParameters['contactId']!;
          final extra = state.extra as Map<String, dynamic>?;
          final contactName = extra?['name'] ?? 'Contact';
          final otherUserId = extra?['otherUserId'];
          final imageUrl = extra?['imageUrl'] ?? '';
          final myId = extra?['myId'] ?? '';
          return ChatScreen(
            otherUserId: otherUserId,
            myId: myId,
            contactName: contactName,
            contactImageUrl: imageUrl,
            chatId: chatId,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.audioCall,
        builder: (context, state) {
          final contactId = state.pathParameters['contactId']!;
          final extra = state.extra as Map<String, dynamic>?;
          final contactName = extra?['name'] ?? 'Contact';
          final imageUrl = extra?['imageUrl'] ?? '';
          final channelId = extra?['channelId'];
          final isIncoming = (extra?['isIncoming'] ?? false) as bool;
          return CallScreen(
            contactId: contactId,
            contactName: contactName,
            contactImageUrl: imageUrl,
            channelId: channelId,
            isIncoming: isIncoming,
            callType: CallType.audio,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.videoCall,
        builder: (context, state) {
          final contactId = state.pathParameters['contactId']!;
          final extra = state.extra as Map<String, dynamic>?;
          final contactName = extra?['name'] ?? 'Contact';
          final imageUrl = extra?['imageUrl'] ?? '';
          final channelId = extra?['channelId'] ?? '';
          final isIncoming = (extra?['isIncoming'] ?? false) as bool;
          return CallScreen(
            contactId: contactId,
            contactName: contactName,
            contactImageUrl: imageUrl,
            channelId: channelId,
            isIncoming: isIncoming,
            callType: CallType.video,
          );
        },
      ),
    ],
  );
}
