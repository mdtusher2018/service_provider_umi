import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/gen/assets.gen.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

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
    final isProvider = role == AppRole.provider;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 90,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: 30.circular,
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
          // index 0
          _navItem(
            icon: isProvider
                ? Icons.calendar_month_outlined
                : Icons.calendar_today_outlined,
            label: isProvider ? "Calendar" : "Service",
            index: 0,
          ),
          // index 1
          _navItem(
            icon: isProvider
                ? Icons.chat_bubble_outline
                : Icons.favorite_border,
            label: isProvider ? "Inbox" : "Favourites",
            index: 1,
          ),

          32.horizontalSpace, // FAB gap (index 2)
          // index 3
          _navItem(
            icon: isProvider
                ? Icons.notifications_none
                : Icons.chat_bubble_outline,
            label: isProvider ? "Notification" : "Inbox",
            index: 3,
          ),
          // index 4
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

class RootScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  final AppRole role; // 👈 passed from shell builder, no provider watch needed

  const RootScreen({
    super.key,
    required this.navigationShell,
    required this.role,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  Widget _homeButton() {
    return FloatingActionButton(
      onPressed: () => _onTap(2),
      backgroundColor: AppColors.primaryFor(role),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: 100.circular),
      child: Image.asset(
        role == AppRole.provider
            ? Assets.icons.upcoming.keyName
            : Assets.icons.home.keyName,
        width: 32,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: (kIsWeb)
          ? null
          : CustomBottomNavBar(
              currentIndex: navigationShell.currentIndex,
              onTap: _onTap,
              role: role,
            ),
      floatingActionButton: (kIsWeb) ? null : _homeButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
