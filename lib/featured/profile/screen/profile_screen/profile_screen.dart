import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/featured/profile/riverpod/user_provider.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/shared/widgets/app_link_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
part '_logout_dialog.dart';
part '_menu_card.dart';
part '_widget_cards.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(myProfileProvider.notifier).fetch();
    });
  }

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

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(myProfileProvider);
    final role = ref.watch(appRoleProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.read(myProfileProvider.notifier).fetch();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.verticalSpace,
                userState.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  success: (profile) => _buildUserCard(
                    ref,
                    name: profile.name,
                    phone: profile.phoneNumber ?? profile.email,
                    avaterUrl: profile.profileImage ?? "",
                  ),
                  failure: (_) => const Center(
                    child: AppText.bodyMd('Failed to load profile'),
                  ),
                ),
                16.verticalSpace,
                // Switch to professional (if needed)
                _buildSwitchTile(ref),
                20.verticalSpace,
                // Section label
                AppText.labelLg(
                  'Account Settings',
                  color: AppColors.textSecondary,
                ),
                16.verticalSpace,
                const AppDivider(),
                // Settings menu
                _MenuCard(
                  items: [
                    _Item(Icons.person_outline_rounded, 'Personal details', () {
                      userState.maybeWhen(
                        success: (profile) {
                          context.push(
                            AppRoutes.personalDetails,
                            extra: profile,
                          );
                        },
                        orElse: () {
                          context.showSnackBar("Pull to refresh");
                        },
                      );
                    }),
                    if (role == AppRole.user) ...[
                      _Item(
                        Icons.location_on_outlined,
                        'My addresses',
                        () => context.push(AppRoutes.myAddresses),
                      ),
                      _Item(
                        Icons.credit_card_outlined,
                        'Payments and refunds',
                        () => context.push(AppRoutes.payments),
                      ),
                    ],
                    if (role == AppRole.provider) ...[
                      _Item(
                        Icons.credit_card,
                        'My balance',
                        () => context.push(AppRoutes.myBalance),
                      ),
                      _Item(
                        Icons.campaign,
                        'My listing',
                        () => context.push(AppRoutes.providerListing),
                      ),
                      _Item(
                        Icons.tune,
                        'Booking preferences',
                        () => context.push(AppRoutes.preferences),
                      ),
                      _Item(
                        Icons.star_border,
                        'My Review',
                        () => context.push(AppRoutes.providerReviews),
                      ),
                    ],
                    _Item(
                      Icons.lock_outline_rounded,
                      'Change password',
                      () => context.push(AppRoutes.changePassword),
                    ),
                    _Item(
                      Icons.g_translate_outlined,
                      'Language',
                      () => context.push(AppRoutes.language),
                    ),
                    _Item(
                      Icons.info_sharp,
                      'About Us',
                      () => context.push(AppRoutes.staticPagePath('about-us')),
                    ),
                    _Item(
                      Icons.description_outlined,
                      'Terms and conditions',
                      () => context.push(AppRoutes.staticPagePath('terms')),
                    ),
                    _Item(
                      Icons.privacy_tip_outlined,
                      'Privacy policy',
                      () => context.push(AppRoutes.staticPagePath('privacy')),
                    ),
                    _Item(
                      Icons.logout_rounded,
                      'Log Out',
                      _confirmLogout,
                      showArrow: false,
                    ),
                  ],
                ),
                40.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
