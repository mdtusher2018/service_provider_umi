import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/featured/RootScreen.dart';
import 'package:service_provider_umi/featured/authentication/screens/phone_number_screen.dart';
import 'package:service_provider_umi/featured/authentication/screens/profile_picture_screen/profile_picture_screen.dart';
import 'package:service_provider_umi/featured/authentication/screens/provider_onboarding.dart';
import 'package:service_provider_umi/featured/authentication/screens/verify_code_screen.dart';
import 'package:service_provider_umi/featured/authentication/screens/welcome_screen.dart';
import 'package:service_provider_umi/featured/communication_and_notification/screens/audio_call_screen.dart';
import 'package:service_provider_umi/featured/communication_and_notification/screens/chat_screen.dart';
import 'package:service_provider_umi/featured/communication_and_notification/screens/communication_and_notification_screen.dart';
import 'package:service_provider_umi/featured/communication_and_notification/screens/video_call_screen.dart';
import 'package:service_provider_umi/featured/guest/guest_onboarding.dart';
import 'package:service_provider_umi/featured/profile/change_password_screen.dart';
import 'package:service_provider_umi/featured/profile/language_screen.dart';
import 'package:service_provider_umi/featured/profile/my_addresses_screen.dart';
import 'package:service_provider_umi/featured/profile/my_balance_screen.dart';
import 'package:service_provider_umi/featured/profile/payments_screen.dart';
import 'package:service_provider_umi/featured/profile/personal_details_screen.dart';
import 'package:service_provider_umi/featured/profile/preferences/minimum_price_screen.dart';
import 'package:service_provider_umi/featured/profile/preferences/preferences_screen.dart';
import 'package:service_provider_umi/featured/profile/preferences/work_area_screen.dart';
import 'package:service_provider_umi/featured/profile/profile_screen/profile_screen.dart';
import 'package:service_provider_umi/featured/profile/provider_listing_screen/provider_listing_screen.dart';
import 'package:service_provider_umi/featured/profile/provider_profile_overview/provider_profile_screen.dart';
import 'package:service_provider_umi/featured/profile/reviews_screen.dart';
import 'package:service_provider_umi/featured/profile/static_page_screen.dart';
import 'package:service_provider_umi/featured/service/presentation/screens/booking_details_screen/booking_details_screen.dart';
import 'package:service_provider_umi/featured/service/presentation/screens/booking_schedule_screen/booking_schedule_screen.dart';
import 'package:service_provider_umi/featured/service/presentation/screens/booking_time_screen/booking_time_screen.dart';
import 'package:service_provider_umi/featured/service/presentation/screens/provider_service_screen.dart';
import 'package:service_provider_umi/featured/service/presentation/screens/service_search_screen/filter_screen.dart';
import 'package:service_provider_umi/featured/service/presentation/screens/service_search_screen/search_results/service_search_results_screen.dart';
import 'package:service_provider_umi/featured/service/presentation/screens/service_search_screen/search_screen.dart';
import 'package:service_provider_umi/featured/service/presentation/screens/service_sub_category_screen.dart';
import 'package:service_provider_umi/featured/service/presentation/screens/upcoming_bookings_screen.dart';
import 'package:service_provider_umi/featured/service/presentation/screens/work_schedule_screen/work_schedule_screen.dart';
import 'package:service_provider_umi/featured/service/presentation/widgets/booking_card_widget.dart';
import 'package:service_provider_umi/shared/enums/all_enums.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';

import 'app_routes.dart';
part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _userShellKey = GlobalKey<NavigatorState>(debugLabel: 'userShell');
final _providerShellKey = GlobalKey<NavigatorState>(
  debugLabel: 'providerShell',
);

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    routes: [
      // ── Login / Welcome ──────────────────────────────────
      GoRoute(path: AppRoutes.login, builder: (_, __) => const WelcomeScreen()),

      // ── Guest Onboarding ────────────────────────────────
      GoRoute(
        path: AppRoutes.guestOnboarding,

        builder: (_, __) => GuestOnboardingScreen(),
      ),

      // ── Auth flow ───────────────────────────────────────
      GoRoute(
        path: AppRoutes.phoneNumber,
        builder: (_, __) => const PhoneNumberScreen(),
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
      GoRoute(path: AppRoutes.search, builder: (_, __) => SearchScreen()),
      GoRoute(
        path: AppRoutes.searchResults,
        builder: (context, state) {
          final category = state.extra as String? ?? 'Elderly Care';
          return SearchResultsScreen(category: category);
        },
      ),
      GoRoute(path: AppRoutes.filter, builder: (_, __) => FilterScreen()),
      GoRoute(
        path: AppRoutes.serviceSubCategory,
        builder: (_, __) => const ServiceSubCategoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.providerProfile,
        builder: (context, state) {
          final id = state.pathParameters['providerId']!;
          return ProviderProfileOverviewScreen(providerId: id);
        },
      ),

      // ── Booking flow ─────────────────────────────────────
      GoRoute(
        path: AppRoutes.bookingTime,
        builder: (_, __) => const BookingTimeScreen(),
      ),
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
            id: state.pathParameters['bookingId']!,
            serviceTitle: 'Service',
            imageUrl: '',
            timeRange: '',
            date: '',
            status: BookingStatus.pending,
          );
          return BookingDetailScreen(booking: booking ?? fallback);
        },
      ),
      GoRoute(
        path: AppRoutes.providerCompletedServiceScreen,
        builder: (_, _) {
          return ProviderCompletedServiceScreen();
        },
      ),

      // ── Profile sub-screens ──────────────────────────────
      GoRoute(
        path: AppRoutes.personalDetails,
        builder: (_, __) => const PersonalDetailsScreen(),
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
            'about-us': StaticPageType.aboutus,
          };
          final titles = {
            'privacy': 'Privacy Policy',
            'terms': 'Terms & Conditions',
            'about-us': 'About Us',
          };
          return StaticPageScreen(
            title: titles[type] ?? type,
            type: map[type] ?? StaticPageType.aboutus,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (_, __) => const CommunicationAndNotificationScreen(),
      ),

      // ── Chat & Calls ─────────────────────────────────────
      GoRoute(
        path: AppRoutes.chat,
        builder: (context, state) {
          final contactId = state.pathParameters['contactId']!;
          final extra = state.extra as Map<String, dynamic>?;
          final contactName = extra?['name'] ?? 'Contact';
          final imageUrl = extra?['imageUrl'] ?? '';
          return ChatScreen(
            contactId: contactId,
            contactName: contactName,
            contactImageUrl: imageUrl,
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
          final channelId = extra?['channelId'] ?? '';
          final isIncoming = (extra?['isIncoming'] ?? false) as bool;
          return AudioCallScreen(
            contactId: contactId,
            contactName: contactName,
            contactImageUrl: imageUrl,
            channelId: channelId,
            isIncoming: isIncoming,
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
          return VideoCallScreen(
            contactId: contactId,
            contactName: contactName,
            contactImageUrl: imageUrl,
            channelId: channelId,
            isIncoming: isIncoming,
          );
        },
      ),

      // ── User Shell (bottom nav) ──────────────────────────
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, shell) => RootScreen(),
        branches: [
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
            navigatorKey: _userShellKey,
            routes: [
              GoRoute(
                path: AppRoutes.userHome,
                builder: (_, __) =>
                    const Scaffold(body: Center(child: Text('Home'))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.userChat,
                builder: (_, __) => const CommunicationAndNotificationScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.providerProfileRoot,
                builder: (_, __) => ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Provider Shell (bottom nav) ──────────────────────
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, shell) => RootScreen(),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.providerDashboard,
                builder: (_, __) =>
                    const Scaffold(body: ProviderServiceScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _providerShellKey,
            routes: [
              GoRoute(
                path: AppRoutes.providerChat,
                builder: (_, __) =>
                    const Scaffold(body: CommunicationAndNotificationScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.providerUpcomingBookings,
                builder: (_, __) =>
                    const Scaffold(body: UpcomingBookingsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.providerNotification,
                builder: (_, __) => const CommunicationAndNotificationScreen(
                  isNotification: true,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.providerProfileRoot,
                builder: (_, __) => const Scaffold(body: ProfileScreen()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
