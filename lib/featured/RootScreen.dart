import 'package:flutter/material.dart';
import 'package:service_provider_umi/featured/HomeScreen.dart';
import 'package:service_provider_umi/featured/booking_time_screen.dart';
import 'package:service_provider_umi/featured/features/booking/presentation/screens/weekly_schedule_screen.dart';
import 'package:service_provider_umi/featured/features/service_discovery/presentation/screens/provider_profile_screen.dart';
import 'package:service_provider_umi/featured/search_results_screen.dart';
import 'package:service_provider_umi/shared/widgets/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    BookingTimeScreen(),
    WeeklyScheduleScreen(),
    HomeScreen(),
    SearchResultsScreen(),
    ProviderProfileScreen(providerId: ""),
  ];

  void onTabTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget _homeButton() {
    return FloatingActionButton(
      onPressed: () => onTabTap(2), // FIXED: call the method in state
      backgroundColor: AppColors.primary,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: const Icon(Icons.home, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: onTabTap,
      ),
      floatingActionButton: _homeButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
            icon: Icons.calendar_today_outlined,
            label: "Service",
            index: 0,
          ),
          _navItem(icon: Icons.favorite_border, label: "Favourites", index: 1),
          const SizedBox(width: 32), // space for FAB
          _navItem(icon: Icons.chat_bubble_outline, label: "Inbox", index: 3),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.primary.withOpacity(0.2)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: active ? AppColors.black : AppColors.grey500,
              size: active ? 26 : 22, // slightly bigger when selected
            ),
          ),
          const SizedBox(height: 4),
          AppText.bodyXs(
            label,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active ? AppColors.black : AppColors.grey500,
            // Optional: fontWeight: active ? FontWeight.bold : FontWeight.normal
          ),
        ],
      ),
    );
  }
}
