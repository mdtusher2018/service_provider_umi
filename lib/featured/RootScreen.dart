import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';

import 'package:service_provider_umi/featured/service/screens/user_home_screen.dart';
import 'package:service_provider_umi/featured/favourites/favourites_screen.dart';
import 'package:service_provider_umi/featured/communication_and_notification/screens/communication_and_notification_screen.dart';
import 'package:service_provider_umi/featured/guest/guest_empty_screen.dart';
import 'package:service_provider_umi/featured/profile/screen/profile_screen/profile_screen.dart';
import 'package:service_provider_umi/featured/service/screens/provider_service_screen.dart';
import 'package:service_provider_umi/featured/service/screens/service_provider_home_screen.dart';
import 'package:service_provider_umi/featured/service/screens/user_service_screen/user_service_screen.dart';

import 'package:service_provider_umi/shared/widgets/app_text.dart';

class RootScreen extends ConsumerStatefulWidget {
  const RootScreen({super.key});

  @override
  ConsumerState<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends ConsumerState<RootScreen> {
  int currentIndex = 2;

  void onTabTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget _homeButton(AppRole role) {
    return FloatingActionButton(
      onPressed: () => onTabTap(2),
      backgroundColor: AppColors.primaryFor(role),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Image.asset(
        (role == AppRole.provider)
            ? "assets/icons/upcoming.png"
            : "assets/icons/home.png",
        width: 32,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(appRoleProvider);

    /// USER SCREENS
    final userScreens = [
      const UserServiceScreen(),
      const FavouritesScreen(),
      const UserHomeScreen(),
      const CommunicationAndNotificationScreen(),
      const ProfileScreen(),
    ];

    /// PROVIDER SCREENS
    final providerScreens = [
      const ProviderServiceScreen(),
      const CommunicationAndNotificationScreen(),
      const ServiceProviderHomeScreen(),
      const CommunicationAndNotificationScreen(isNotification: true),
      const ProfileScreen(),
    ];

    /// GUEST SCREENS (mostly browsing)
    final guestScreens = [
      const GuestServicesScreen(),
      const GuestFavouritesScreen(), // could redirect to login later
      const UserHomeScreen(),
      const GuestInboxScreen(),
      const GuestProfileScreen(), // can show login/signup
    ];

    /// Choose screens based on role
    List<Widget> screens;

    switch (role) {
      case AppRole.guest:
        screens = guestScreens;
        break;

      case AppRole.user:
        screens = userScreens;
        break;

      case AppRole.provider:
        screens = providerScreens;
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: CustomBottomNavBar(
        role: role,
        currentIndex: currentIndex,
        onTap: onTabTap,
      ),
      floatingActionButton: _homeButton(role),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final AppRole role;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final isUserLike = role == AppRole.user || role == AppRole.guest;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 90,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            icon: isUserLike
                ? Icons.calendar_today_outlined
                : Icons.calendar_month_outlined,
            label: isUserLike ? "Service" : "Calendar",
            index: 0,
          ),
          _navItem(
            icon: isUserLike
                ? Icons.favorite_border
                : Icons.chat_bubble_outline,
            label: isUserLike ? "Favourites" : "Inbox",
            index: 1,
          ),

          32.horizontalSpace,

          _navItem(
            icon: isUserLike
                ? Icons.chat_bubble_outline
                : Icons.notifications_none,
            label: isUserLike ? "Inbox" : "Notification",
            index: 3,
          ),
          _navItem(icon: Icons.person_outline, label: "Profile", index: 4),
        ],
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool active = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: 8.paddingAll,
            decoration: BoxDecoration(
              color: active
                  ? AppColors.primary.withOpacity(0.2)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: active ? AppColors.black : AppColors.grey500,
              size: active ? 26 : 22,
            ),
          ),
          4.verticalSpace,
          AppText.bodyXs(
            label,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active ? AppColors.black : AppColors.grey500,
          ),
        ],
      ),
    );
  }
}
