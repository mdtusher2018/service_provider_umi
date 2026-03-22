import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/theme/app_role.dart';
import 'package:service_provider_umi/featured/RootScreen.dart';
import 'package:service_provider_umi/featured/profile/my_balance_screen.dart';
import 'package:service_provider_umi/featured/profile/provider_listing_screen/provider_listing_screen.dart';
import 'package:service_provider_umi/featured/profile/preferences/preferences_screen.dart';
import 'package:service_provider_umi/featured/profile/reviews_screen.dart';
import 'package:service_provider_umi/featured/authentication/provider_onboarding.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_link_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import '../personal_details_screen.dart';
import '../my_addresses_screen.dart';
import '../change_password_screen.dart';
import '../language_screen.dart';
import '../payments_screen.dart';
import '../static_page_screen.dart';
part '_logout_dialog.dart';
part '_menu_card.dart';
part '_widget_cards.dart';

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
                    _buildUserCard(ref, name: _name, phone: _phone),
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
                          () => _push(
                            const StaticPageScreen(
                              title: 'About Us',
                              type: StaticPageType.aboutus,
                            ),
                          ),
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
}
