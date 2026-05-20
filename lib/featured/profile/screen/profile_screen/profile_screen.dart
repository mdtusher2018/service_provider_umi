import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/di/core_providers.dart';
import 'package:service_provider_umi/core/logger/app_logger.dart';
import 'package:service_provider_umi/core/services/storage/storage_key.dart';
import 'package:service_provider_umi/core/utils/animations.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/string_ext.dart';
import 'package:service_provider_umi/featured/profile/riverpod/user_provider.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/featured/profile/screen/payment_webview.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/shared/widgets/app_link_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
part '_logout_dialog.dart';
part '_menu_card.dart';
part '_user_cards.dart';
part '_switch_tile.dart';

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
    showGeneralDialog(
      context: context,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      barrierColor: Colors.black.withOpacity(0.4),
      pageBuilder: (_, _, _) => _LogoutDialog(
        onCancel: () {
          context.pop();
        },
        onLogout: () async {
          await ref.read(localStorageProvider).clearAll();

          ref.invalidate(myProfileProvider);
          ref.invalidate(appRoleProvider);

          if (mounted) {
            context.go(AppRoutes.login);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(myProfileProvider);
    final role = ref.watch(appRoleProvider);
    ref.listen(stripeConnectProvider, (previous, next) {
      next.whenOrNull(
        loading: () {
          context.showLoader(); // your loader
        },
        success: (url) {
          context.hideLoader();

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PaymentWebViewScreen(url: url)),
          );
        },
        failure: (failure) {
          context.hideLoader();
          context.showSnackBar(failure.message);
        },
      );
    });
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
                  loading: () => const AppLoader(),
                  success: (profile) => _buildUserCard(
                    ref,
                    name: profile.name,
                    phone: profile.phoneNumber ?? profile.email,
                    avaterUrl: profile.profileImage ?? "",
                    isStripeConnected:
                        profile.serviceProviderInfo?.stripeAccountId != null,
                  ),
                  failure: (_) => const Center(
                    child: AppText.bodyMd('Failed to load profile'),
                  ),
                ),
                // 16.verticalSpace,

                // _buildSwitchTile(ref),
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
                          if (kIsWeb) {
                            context.go(
                              AppRoutes.personalDetails,
                              extra: profile,
                            );
                          } else {
                            context.push(
                              AppRoutes.personalDetails,
                              extra: profile,
                            );
                          }
                        },
                        orElse: () {
                          context.showSnackBar("Pull to refresh");
                        },
                      );
                    }),
                    if (role == AppRole.user) ...[
                      _Item(Icons.location_on_outlined, 'My addresses', () {
                        if (kIsWeb) {
                          context.go(AppRoutes.myAddresses);
                        } else {
                          context.push(AppRoutes.myAddresses);
                        }
                      }),
                      _Item(
                        Icons.credit_card_outlined,
                        'Payments and refunds',
                        () {
                          // if (kIsWeb) {
                          //   context.go(AppRoutes.payments);
                          // } else {
                          //   context.push(AppRoutes.payments);
                          // }
                          if (kIsWeb) {
                            context.go(AppRoutes.paymentCardsPage);
                          } else {
                            context.push(AppRoutes.paymentCardsPage);
                          }
                        },
                      ),
                    ],
                    if (role == AppRole.provider) ...[
                      // _Item(Icons.credit_card, 'My balance', () {
                      //   if (kIsWeb) {
                      //     context.go(AppRoutes.myBalance);
                      //   } else {
                      //     context.push(AppRoutes.myBalance);
                      //   }
                      // }),
                      _Item(Icons.tune, 'Booking preferences', () {
                        if (kIsWeb) {
                          context.go(AppRoutes.preferences);
                        } else {
                          context.push(AppRoutes.preferences);
                        }
                      }),
                      _Item(Icons.star_border, 'My Review', () {
                        if (kIsWeb) {
                          context.go(AppRoutes.providerReviews);
                        } else {
                          context.push(AppRoutes.providerReviews);
                        }
                      }),
                    ],
                    _Item(Icons.lock_outline_rounded, 'Change password', () {
                      if (kIsWeb) {
                        context.go(AppRoutes.changePassword);
                      } else {
                        context.push(AppRoutes.changePassword);
                      }
                    }),
                    _Item(Icons.g_translate_outlined, 'Language', () {
                      if (kIsWeb) {
                        context.go(AppRoutes.language);
                      } else {
                        context.push(AppRoutes.language);
                      }
                    }),
                    _Item(Icons.info_sharp, 'About Us', () {
                      if (kIsWeb) {
                        context.push(AppRoutes.staticPagePath('about-us'));
                      } else {
                        context.push(AppRoutes.staticPagePath('about-us'));
                      }
                    }),
                    _Item(
                      Icons.description_outlined,
                      'Terms and conditions',
                      () {
                        if (kIsWeb) {
                          context.go(AppRoutes.staticPagePath('terms'));
                        } else {
                          context.push(AppRoutes.staticPagePath('terms'));
                        }
                      },
                    ),
                    _Item(Icons.privacy_tip_outlined, 'Privacy policy', () {
                      if (kIsWeb) {
                        context.go(AppRoutes.staticPagePath('privacy'));
                      } else {
                        context.push(AppRoutes.staticPagePath('privacy'));
                      }
                    }),

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
