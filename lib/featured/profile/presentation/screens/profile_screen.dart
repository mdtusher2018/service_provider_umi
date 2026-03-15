import 'package:flutter/material.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import 'personal_details_screen.dart';
import 'my_addresses_screen.dart';
import 'change_password_screen.dart';
import 'language_screen.dart';
import 'payments_screen.dart';
import 'about_us_screen.dart';
import 'static_page_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _name = 'Mr. Raju';
  final String _phone = '+880 1840-560614';

  void _confirmLogout() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => _LogoutDialog(
        onCancel: () => Navigator.of(context).pop(),
        onLogout: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _push(Widget screen) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: AppText.h1('Profile'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User card
                    _buildUserCard(),
                    const SizedBox(height: 16),
                    // Switch to professional
                    _buildSwitchTile(),
                    const SizedBox(height: 20),
                    // Section label
                    AppText.labelLg(
                      'Account Settings',
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 16),
                    AppDivider(),
                    // Settings menu
                    _MenuCard(
                      items: [
                        _Item(
                          Icons.person_outline_rounded,
                          'Personal details',
                          () => _push(const PersonalDetailsScreen()),
                        ),
                        _Item(
                          Icons.location_on_outlined,
                          'My addresses',
                          () => _push(const MyAddressesScreen()),
                        ),
                        _Item(
                          Icons.credit_card_outlined,
                          'Payments and refunds',
                          () => _push(const PaymentsScreen()),
                        ),
                        _Item(
                          Icons.lock_outline_rounded,
                          'Change password',
                          () => _push(const ChangePasswordScreen()),
                        ),
                        _Item(
                          Icons.language_rounded,
                          'Language',
                          () => _push(const LanguageScreen()),
                        ),
                        _Item(
                          Icons.info_outline_rounded,
                          'About Us',
                          () => _push(const AboutUsScreen()),
                        ),
                        _Item(
                          Icons.description_outlined,
                          'Terms and conditions',
                          () => _push(
                            const StaticPageScreen(
                              title: 'Terms & Condition',
                              type: StaticPageType.terms,
                            ),
                          ),
                        ),
                        _Item(
                          Icons.shield_outlined,
                          'Privacy policy',
                          () => _push(
                            const StaticPageScreen(
                              title: 'Privacy Policy',
                              type: StaticPageType.privacy,
                            ),
                          ),
                        ),
                        _Item(
                          Icons.logout_rounded,
                          'Log Out',
                          _confirmLogout,

                          showArrow: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Logout
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return Row(
      children: [
        AppAvatar(name: _name, size: AvatarSize.md),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.h3(_name),
            AppText.bodySm(_phone, color: AppColors.textSecondary),
          ],
        ),
      ],
    );
  }

  Widget _buildSwitchTile() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.swap_horiz_rounded,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: AppText.bodyMd('Switch to professional version'),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.grey400,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Menu data ────────────────────────────────────────────────
class _Item {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  final bool showArrow;
  const _Item(this.icon, this.label, this.onTap, {this.showArrow = true});
}

class _MenuCard extends StatelessWidget {
  final List<_Item> items;
  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.asMap().entries.map((e) {
        final isLast = e.key == items.length - 1;
        final item = e.value;
        return Column(
          children: [
            InkWell(
              onTap: item.onTap,
              borderRadius: BorderRadius.vertical(
                top: e.key == 0 ? const Radius.circular(16) : Radius.zero,
                bottom: isLast ? const Radius.circular(16) : Radius.zero,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    Icon(item.icon, color: AppColors.primary, size: 24),
                    const SizedBox(width: 14),
                    Expanded(
                      child: AppText.bodyMd(
                        item.label,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (item.showArrow)
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.grey400,
                        size: 14,
                      ),
                  ],
                ),
              ),
            ),
            if (!isLast) AppDivider(),
          ],
        );
      }).toList(),
    );
  }
}

// ─── Logout dialog ────────────────────────────────────────────
class _LogoutDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onLogout;
  const _LogoutDialog({required this.onCancel, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onCancel,
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const AppText.h3('Are you sure you want to log out?'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const AppText.labelLg('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const AppText.labelLg(
                      'Log out',
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
