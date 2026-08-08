import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/featured/subscription/riverpod/subscription_provider.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

import '../../../core/services/revenuecat_service.dart';
import '../../../l10n/app_localizations.dart';
import '../riverpod/provider_monthly_analytics_provider.dart';
import 'premium_packages_screen.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Manage Subscription Screen (Under Profile / Settings)
/// ─────────────────────────────────────────────────────────────────────────────
class ManageSubscriptionScreen extends ConsumerWidget {
  const ManageSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subState = ref.watch(subscriptionProvider);
    final info = subState.customerInfo;
    final entitlement = info?.entitlements.all[RevenueCatService.entitlementId];

    final isTrial = subState.isInTrial;
    final isActive = subState.hasActiveAccess;
    final daysLeft = subState.remainingTrialDays;
    final backendSub = subState.backendSubscription;

    // Determine status label & color
    String? statusLabel;
    Color statusColor = Colors.transparent;
    
    if (isTrial) {
      statusLabel = AppLocalizations.of(context)!.freeTrialDaysLeft(daysLeft.toString());
      statusColor = const Color(0xFFD97706);
    } else if (isActive) {
      bool willRenew = true;
      if (backendSub != null && backendSub['isExpired'] == true) {
        willRenew = false;
      } else if (entitlement != null) {
        willRenew = entitlement.willRenew;
      }
      statusLabel = !willRenew ? AppLocalizations.of(context)!.cancelledActiveTillPeriodEnd : AppLocalizations.of(context)!.activePremium;
      statusColor = !willRenew ? Colors.orange : const Color(0xFF059669);
    } else if (entitlement != null || backendSub != null) {
      statusLabel = AppLocalizations.of(context)!.expired;
      statusColor = Colors.red;
    }

    // Format Dates
    final dateFormat = DateFormat('MMM dd, yyyy');
    String activationDateStr = 'N/A';
    String nextBillingDateStr = 'N/A';
    
    // Find matching package
    Package? activePackage;
    if (entitlement != null && subState.offerings != null) {
      for (final offering in subState.offerings!.all.values) {
        for (final package in offering.availablePackages) {
          if (package.storeProduct.identifier == entitlement.productIdentifier) {
            activePackage = package;
            break;
          }
        }
        if (activePackage != null) break;
      }
    }
    
    // Determine plan name dynamically
    String planName = 'Annual Premium';
    if (backendSub != null && backendSub['package'] != null) {
      planName = backendSub['package']['name'] ?? planName;
    } else if (activePackage != null) {
      if (activePackage.packageType == PackageType.monthly) {
        planName = AppLocalizations.of(context)!.monthlyPremium;
      } else if (activePackage.packageType == PackageType.annual) {
        planName = AppLocalizations.of(context)!.annualPremium;
      } else {
        planName = activePackage.storeProduct.title; 
      }
    } else if (entitlement?.productIdentifier != null) {
      final pid = entitlement!.productIdentifier.toLowerCase();
      if (pid.contains('monthly')) planName = AppLocalizations.of(context)!.monthlyPremium;
      else if (pid.contains('annual') || pid.contains('yearly')) planName = AppLocalizations.of(context)!.annualPremium;
      else planName = entitlement.productIdentifier;
    }

    // Determine price dynamically
    String priceStr = '\$9.99/year';
    if (backendSub != null && backendSub['package'] != null) {
      final price = backendSub['package']['price']?.toString() ?? '0';
      priceStr = '\$$price';
    } else if (activePackage != null) {
      priceStr = activePackage.storeProduct.priceString;
    } else if (entitlement?.productIdentifier != null && entitlement!.productIdentifier.toLowerCase().contains('monthly')) {
      priceStr = '\$0.99/month';
    }

    if (backendSub != null) {
      if (backendSub['purchasedAt'] != null) {
        final date = DateTime.tryParse(backendSub['purchasedAt']);
        if (date != null) activationDateStr = dateFormat.format(date.toLocal());
      }
      if (backendSub['expiresAt'] != null) {
        final date = DateTime.tryParse(backendSub['expiresAt']);
        if (date != null) nextBillingDateStr = dateFormat.format(date.toLocal());
      }
    } else if (entitlement != null) {
      if (entitlement.latestPurchaseDate.isNotEmpty) {
        final date = DateTime.tryParse(entitlement.latestPurchaseDate);
        if (date != null) activationDateStr = dateFormat.format(date);
      }
      if (entitlement.expirationDate != null && entitlement.expirationDate!.isNotEmpty) {
        final date = DateTime.tryParse(entitlement.expirationDate!);
        if (date != null) nextBillingDateStr = dateFormat.format(date);
      }
    }

    String platformStr = kIsWeb ? 'Web (Stripe)' : (Platform.isIOS ? 'iOS App Store' : 'Google Play Billing');
    if (backendSub != null && backendSub['productId'] == 'free_trial') {
      platformStr = 'Free Trial (In-App)';
    } else if (backendSub != null && backendSub['store'] != null) {
      platformStr = backendSub['store'].toString();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: AppText.h3(AppLocalizations.of(context)!.manageSubscription),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: subState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 1. Status Banner Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.bodyLg(AppLocalizations.of(context)!.subscriptionStatus, fontWeight: FontWeight.w800),
                            if (statusLabel != null) ...[
                              8.verticalSpace,
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: AppText.bodyXs(
                                    statusLabel,
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                        16.verticalSpace,
                        const Divider(height: 1),
                        16.verticalSpace,
                        if (!isActive && !isTrial) ...[
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: AppText.bodyMd(
                                AppLocalizations.of(context)!.noSubscriptionPurchased,
                                color: AppColors.grey500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ] else ...[
                          _buildInfoRow(AppLocalizations.of(context)!.currentPlan, isTrial ? 'Free Trial' : planName),
                          12.verticalSpace,
                          _buildInfoRow(AppLocalizations.of(context)!.subscriptionPrice, isTrial ? '\$0.00 (Trial)' : priceStr),
                          12.verticalSpace,
                          _buildInfoRow(AppLocalizations.of(context)!.activationDate, activationDateStr),
                          12.verticalSpace,
                          _buildInfoRow(AppLocalizations.of(context)!.nextBillingRenewal, nextBillingDateStr),
                          12.verticalSpace,
                          _buildInfoRow(AppLocalizations.of(context)!.purchasePlatform, platformStr),
                        ],
                      ],
                    ),
                  ),

                  24.verticalSpace,

                  /// 2. Requirement #9: Provider Value Summary
                  _buildValueSummary(context, ref),

                  24.verticalSpace,

                  /// 3. Action Buttons (Upgrade, Restore)
                  AppButton(
                    label: AppLocalizations.of(context)!.upgradeToPremiumNow,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PremiumPackagesScreen()),
                      );
                    },
                  ),
                  12.verticalSpace,
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      final restored = await ref.read(subscriptionProvider.notifier).restorePurchases();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              restored
                                  ? AppLocalizations.of(context)!.subscriptionRestoredSuccessfully
                                  : AppLocalizations.of(context)!.noActiveSubscriptionFoundToRestore,
                            ),
                          ),
                        );
                      }
                    },
                    child: AppText.bodyLg(
                      AppLocalizations.of(context)!.restorePurchase,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  12.verticalSpace,
                  Center(
                    child: TextButton(
                      onPressed: () => _showCancelDialog(context, nextBillingDateStr, info),
                      child: AppText.bodySm(
                        AppLocalizations.of(context)!.cancelSubscription,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildValueSummary(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(providerMonthlyAnalyticsProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: analyticsAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(color: Color(0xFF38BDF8), strokeWidth: 2),
          ),
        ),
        error: (error, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics_outlined, color: Color(0xFF38BDF8), size: 24),
                10.horizontalSpace,
                AppText.bodyLg(
                  AppLocalizations.of(context)!.yourValueThisMonth,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            12.verticalSpace,
            const Text(
              'Unable to load analytics data.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            ),
            8.verticalSpace,
            GestureDetector(
              onTap: () => ref.invalidate(providerMonthlyAnalyticsProvider),
              child: const Text(
                'Tap to retry',
                style: TextStyle(
                  color: Color(0xFF38BDF8),
                  fontSize: 13,
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFF38BDF8),
                ),
              ),
            ),
          ],
        ),
        data: (analytics) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics_outlined, color: Color(0xFF38BDF8), size: 24),
                10.horizontalSpace,
                AppText.bodyLg(
                  AppLocalizations.of(context)!.yourValueThisMonth,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            12.verticalSpace,
            Text(
              AppLocalizations.of(context)!.thisMonthRequestsBookings('${analytics.requestsReceived}', '${analytics.bookingsAccepted}'),
              style: const TextStyle(
                color: Color(0xFFE2E8F0),
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
            12.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('${analytics.requestsReceived}', AppLocalizations.of(context)!.requestsReceived),
                Container(width: 1, height: 30, color: Colors.white24),
                _buildStatItem('${analytics.bookingsAccepted}', AppLocalizations.of(context)!.bookingsAccepted),
                Container(width: 1, height: 30, color: Colors.white24),
                _buildStatItem(analytics.acceptanceRate, AppLocalizations.of(context)!.acceptanceRate),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.bodySm(label, color: AppColors.grey500),
        AppText.bodySm(value, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      ],
    );
  }

  Widget _buildStatItem(String stat, String label) {
    return Expanded(
      child: Column(
        children: [
          AppText.h2(stat, color: const Color(0xFF38BDF8)),
          2.verticalSpace,
          AppText.bodySm(label, color: const Color(0xFF94A3B8), fontSize: 11, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  /// Requirement #10: Cancellation Reason Dialog & Retention Offer
  void _showCancelDialog(BuildContext context, String activeTillDate, CustomerInfo? info) {
    showDialog(
      context: context,
      builder: (ctx) {
        String? selectedReason;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: AppText.h3(AppLocalizations.of(context)!.cancelSubscriptionQuestion),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.bodySm(
                AppLocalizations.of(context)!.ifYouCancelTodayPremiumAccess(activeTillDate),
                color: AppColors.grey500,
              ),
              12.verticalSpace,
              ...[AppLocalizations.of(context)!.tooExpensive, AppLocalizations.of(context)!.notGettingEnoughClientRequests, AppLocalizations.of(context)!.usingADifferentPlatform, AppLocalizations.of(context)!.other].map(
                (reason) => StatefulBuilder(
                  builder: (context, setState) => RadioListTile<String>(
                    title: AppText.bodySm(reason),
                    value: reason,
                    groupValue: selectedReason,
                    onChanged: (val) {
                      setState(() => selectedReason = val);
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
              ),
              12.verticalSpace,
              // Retention Offer Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_offer, color: Color(0xFFD97706), size: 20),
                    8.horizontalSpace,
                    Expanded(
                      child: AppText.bodySm(
                        AppLocalizations.of(context)!.stayWithUsGet20Off,
                        color: const Color(0xFF92400E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: AppText.bodyMd(AppLocalizations.of(context)!.keepMySubscription, color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                try {
                  if (info?.managementURL != null) {
                    final uri = Uri.parse(info!.managementURL!);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                      return;
                    }
                  }
                  final iosUrl = Uri.parse("https://apps.apple.com/account/subscriptions");
                  final androidUrl = Uri.parse("https://play.google.com/store/account/subscriptions");
                  if (Platform.isIOS) {
                    await launchUrl(iosUrl);
                  } else if (Platform.isAndroid) {
                    await launchUrl(androidUrl);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context)!.pleaseCancelViaStore)),
                    );
                  }
                }
              },
              child: AppText.bodyMd(AppLocalizations.of(context)!.confirmCancellation, color: Colors.red),
            ),
          ],
        );
      },
    );
  }
}
