import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/theme/app_role.dart';
import 'package:service_provider_umi/featured/RootScreen.dart';
import 'package:service_provider_umi/featured/profile/my_balance_screen.dart';
import 'package:service_provider_umi/featured/profile/provider_listing_screen.dart';
import 'package:service_provider_umi/featured/profile/preferences_screen.dart';
import 'package:service_provider_umi/featured/profile/reviews_screen.dart';
import 'package:service_provider_umi/featured/provider/provider_onboarding.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_link_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import 'personal_details_screen.dart';
import 'my_addresses_screen.dart';
import 'change_password_screen.dart';
import 'language_screen.dart';
import 'payments_screen.dart';
import 'about_us_screen.dart';
import 'static_page_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
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
                    16.verticalSpace,
                    // Switch to professional
                    _buildSwitchTile(ref),
                    20.verticalSpace,
                    // Section label
                    AppText.labelLg(
                      'Account Settings',
                      color: AppColors.textSecondary,
                    ),
                    16.verticalSpace,
                    AppDivider(),
                    // Settings menu
                    _MenuCard(
                      items: [
                        _Item(
                          Icons.person_outline_rounded,
                          'Personal details',
                          () => _push(const PersonalDetailsScreen()),
                        ),
                        if (ref.watch(appRoleProvider) == AppRole.user) ...[
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
                        ],
                        if (ref.watch(appRoleProvider) == AppRole.provider) ...[
                          _Item(
                            Icons.credit_card,
                            'My balance',
                            () => _push(const MyBalanceScreen()),
                          ),

                          _Item(
                            Icons.campaign,
                            'My listing',
                            () => _push(const ProviderListingScreen()),
                          ),
                          _Item(
                            Icons.tune,
                            'Booking preferences',
                            () => _push(const PreferencesScreen()),
                          ),
                          _Item(
                            Icons.star_border,
                            'My Review',
                            () => _push(const ReviewsScreen()),
                          ),
                        ],
                        _Item(
                          Icons.lock_outline_rounded,
                          'Change password',
                          () => _push(const ChangePasswordScreen()),
                        ),
                        _Item(
                          Icons.g_translate_outlined,
                          'Language',
                          () => _push(const LanguageScreen()),
                        ),
                        _Item(
                          Icons.info_sharp,
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
                          Icons.privacy_tip_outlined,
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
                    8.verticalSpace,

                    // Logout
                    40.verticalSpace,
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
        14.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.h3(_name),
            if (ref.watch(appRoleProvider) == AppRole.user)
              AppText.bodySm(_phone, color: AppColors.textSecondary),
            if (ref.watch(appRoleProvider) == AppRole.provider)
              AppLinkText(
                links: [AppTextLink(label: "Not verified", onTap: () {})],
                "Verification : Not verified",
                linkColor: AppColors.primaryFor(ref.watch(appRoleProvider)),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSwitchTile(WidgetRef ref) {
    final currentRole = ref.watch(appRoleProvider);
    final isProvider = currentRole == AppRole.provider;

    return GestureDetector(
      onTap: () {
        ref.read(appRoleProvider.notifier).switchRole();
        if (ref.read(appRoleProvider) == AppRole.provider) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ServiceProviderOnboardingScreen();
              },
            ),
            (route) => false,
          );
          return;
        }
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return RootScreen();
            },
          ),
          (route) => false,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(Icons.sync),
            12.horizontalSpace,
            Expanded(
              child: Text(
                isProvider
                    ? 'Switch to user version'
                    : 'Switch to professional version',
              ),
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

class _MenuCard extends ConsumerWidget {
  final List<_Item> items;
  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryFor(
                          ref.watch(appRoleProvider),
                        ).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        item.icon,
                        color: AppColors.primaryFor(ref.watch(appRoleProvider)),
                        size: 28,
                      ),
                    ),
                    14.horizontalSpace,
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
            8.verticalSpace,
            const AppText.h3('Are you sure you want to log out?'),
            20.verticalSpace,
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
                12.horizontalSpace,
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
