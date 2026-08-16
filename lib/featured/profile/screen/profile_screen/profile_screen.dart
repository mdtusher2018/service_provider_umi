import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/di/core_providers.dart';
import 'package:service_provider_umi/core/services/storage/storage_key.dart';
import 'package:service_provider_umi/core/utils/animations.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/string_ext.dart';
import 'package:service_provider_umi/featured/profile/riverpod/user_provider.dart';
import 'package:service_provider_umi/featured/subscription/screens/manage_subscription_screen.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/featured/profile/screen/payment_webview.dart';
import 'package:service_provider_umi/shared/enums/all_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_error_widget.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/shared/widgets/app_link_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import 'package:service_provider_umi/core/services/revenuecat_service.dart';
import 'package:service_provider_umi/featured/subscription/riverpod/subscription_provider.dart';
import 'package:service_provider_umi/l10n/app_localizations.dart';
import 'package:service_provider_umi/core/services/socket/chat_socket_service.dart';

import '../../../../shared/enums/app_enums.dart';
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
      barrierColor: Colors.black.withValues(alpha: 0.4),
      pageBuilder: (_, _, _) => _LogoutDialog(
        onCancel: () {
          context.pop();
        },
        onLogout: () async {
          await ref.read(localStorageProvider).clearAll();
          await RevenueCatService.instance.logout();
          
          ChatSocketService.instance.clearCache();

          ref.invalidate(myProfileProvider);
          ref.invalidate(appRoleProvider);
          ref.invalidate(subscriptionProvider);

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
                    context,
                    ref,
                    name: profile.name,
                    phone: profile.phoneNumber ?? profile.email,
                    avaterUrl: profile.profileImage ?? "",
                    isStripeConnected:
                        profile.serviceProviderInfo?.stripeAccountId != null,
                  ),
                  failure: (_) => AppErrorWidget(
                    error: AppLocalizations.of(context)!.failedToLoadProfile,
                    onRetry: () => ref.read(myProfileProvider.notifier).fetch(),
                  ),
                ),
                // 16.verticalSpace,

                // _buildSwitchTile(ref),
                20.verticalSpace,
                // Section label
                AppText.labelLg(
                  AppLocalizations.of(context)!.accountSettings,
                  color: AppColors.textSecondary,
                ),
                16.verticalSpace,
                const AppDivider(),
                // Settings menu
                _MenuCard(
                  items: [
                    _Item(Icons.person_outline_rounded, AppLocalizations.of(context)!.personalDetails, () {
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
                          context.showSnackBar(AppLocalizations.of(context)!.pullToRefresh);
                        },
                      );
                    }),
                    if (role == AppRole.user) ...[
                      _Item(Icons.location_on_outlined, AppLocalizations.of(context)!.myAddresses, () {
                        if (kIsWeb) {
                          context.go(AppRoutes.myAddresses);
                        } else {
                          context.push(AppRoutes.myAddresses);
                        }
                      }),
                      _Item(
                        Icons.credit_card_outlined,
                        AppLocalizations.of(context)!.paymentsAndRefunds,
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
                      //   }
                      // }),
                      _Item(Icons.workspace_premium, AppLocalizations.of(context)!.mySubscription, () {
                        if (kIsWeb) {
                          // In web, you might want to use go_router, but for now we push
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ManageSubscriptionScreen()),
                          );
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ManageSubscriptionScreen()),
                          );
                        }
                      }),
                      _Item(Icons.list_alt, AppLocalizations.of(context)!.myListing, () {
                        if (kIsWeb) {
                          context.go(AppRoutes.providerListing);
                        } else {
                          context.push(AppRoutes.providerListing);
                        }
                      }),
                      // _Item(Icons.tune, 'Booking preferences', () {
                      //   if (kIsWeb) {
                      //     context.go(AppRoutes.preferences);
                      //   } else {
                      //     context.push(AppRoutes.preferences);
                      //   }
                      // }),
                      // _Item(Icons.location_on_outlined, 'My work areas', () {
                      //   if (kIsWeb) {
                      //     context.go(AppRoutes.workAreas);
                      //   } else {
                      //     context.push(AppRoutes.workAreas);
                      //   }
                      // }),
                      _Item(Icons.access_time_rounded, AppLocalizations.of(context)!.mySchedule, () {
                        if (kIsWeb) {
                          context.go('${AppRoutes.workSchedule}?from=profile');
                        } else {
                          context.push('${AppRoutes.workSchedule}?from=profile');
                        }
                      }),
                      _Item(Icons.attach_money_rounded, AppLocalizations.of(context)!.minimumBookingAmount, () {
                        if (kIsWeb) {
                          context.go(AppRoutes.minimumPrice);
                        } else {
                          context.push(AppRoutes.minimumPrice);
                        }
                      }),
                      _Item(Icons.star_border, AppLocalizations.of(context)!.myReview, () {
                        if (kIsWeb) {
                          context.go(AppRoutes.providerReviews);
                        } else {
                          context.push(AppRoutes.providerReviews);
                        }
                      }),
                      _Item(Icons.question_answer_outlined, AppLocalizations.of(context)!.addFaq, () {
                        userState.maybeWhen(
                          success: (profile) {
                            if (kIsWeb) {
                              context.go(AppRoutes.addFaq, extra: profile.id);
                            } else {
                              context.push(AppRoutes.addFaq, extra: profile.id);
                            }
                          },
                          orElse: () {
                            context.showSnackBar(AppLocalizations.of(context)!.failedToLoadProfile);
                          },
                        );
                      }),
                    ],
                    _Item(Icons.lock_outline_rounded, AppLocalizations.of(context)!.changePassword, () {
                      if (kIsWeb) {
                        context.go(AppRoutes.changePassword);
                      } else {
                        context.push(AppRoutes.changePassword);
                      }
                    }),
                    _Item(Icons.g_translate_outlined, AppLocalizations.of(context)!.language, () {
                      if (kIsWeb) {
                        context.go(AppRoutes.language);
                      } else {
                        context.push(AppRoutes.language);
                      }
                    }),
                    _Item(Icons.info_sharp, AppLocalizations.of(context)!.aboutUs, () {
                      if (kIsWeb) {
                        context.push(AppRoutes.staticPagePath('about-us'));
                      } else {
                        context.push(AppRoutes.staticPagePath('about-us'));
                      }
                    }),
                    _Item(
                      Icons.description_outlined,
                      AppLocalizations.of(context)!.termsAndConditions,
                      () {
                        if (kIsWeb) {
                          context.go(AppRoutes.staticPagePath('terms'));
                        } else {
                          context.push(AppRoutes.staticPagePath('terms'));
                        }
                      },
                    ),
                    _Item(Icons.privacy_tip_outlined, AppLocalizations.of(context)!.privacyPolicy, () {
                      if (kIsWeb) {
                        context.go(AppRoutes.staticPagePath('privacy'));
                      } else {
                        context.push(AppRoutes.staticPagePath('privacy'));
                      }
                    }),

                    _Item(
                      Icons.logout_rounded,
                      AppLocalizations.of(context)!.logout,
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
