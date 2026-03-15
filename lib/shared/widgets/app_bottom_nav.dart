import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Bottom navigation bar - Services / Favourites / [center FAB] / Inbox / Profile
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_work_outlined, activeIcon: Icons.home_work_rounded, label: 'Service'),
    _NavItem(icon: Icons.favorite_border_rounded, activeIcon: Icons.favorite_rounded, label: 'Favourites'),
    _NavItem(icon: Icons.add, activeIcon: Icons.add, label: ''),         // Center FAB placeholder
    _NavItem(icon: Icons.chat_bubble_outline_rounded, activeIcon: Icons.chat_bubble_rounded, label: 'Inbox'),
    _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(top: BorderSide(color: AppColors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(_items.length, (i) {
            if (i == 2) return _buildCenterFab(context);
            return _buildNavItem(context, i);
          }),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index) {
    final isActive = currentIndex == index;
    final item = _items[index];

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                key: ValueKey(isActive),
                color: isActive ? AppColors.primary : AppColors.grey400,
                size: 22,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              style: AppTextStyles.labelSm.copyWith(
                color: isActive ? AppColors.primary : AppColors.grey400,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterFab(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(2),
        child: Center(
          child: Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x4000BFA5),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.map_outlined, color: AppColors.white, size: 24),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}
