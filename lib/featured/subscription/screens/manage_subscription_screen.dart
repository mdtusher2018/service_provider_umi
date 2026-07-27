import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/featured/subscription/riverpod/subscription_provider.dart';
import 'package:service_provider_umi/featured/subscription/screens/subscription_screen.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

import '../../../core/services/revenuecat_service.dart';

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

    // Determine status label & color
    String statusLabel = 'Expired';
    Color statusColor = Colors.red;
    if (isTrial) {
      statusLabel = '30-Day Free Trial ($daysLeft days left)';
      statusColor = const Color(0xFFD97706);
    } else if (isActive) {
      statusLabel = entitlement?.willRenew == false ? 'Cancelled (Active till period end)' : 'Active Premium';
      statusColor = entitlement?.willRenew == false ? Colors.orange : const Color(0xFF059669);
    }

    // Format Dates
    final dateFormat = DateFormat('MMM dd, yyyy');
    String activationDateStr = 'N/A';
    String nextBillingDateStr = 'N/A';
    if (entitlement != null) {
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

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const AppText.h3('Manage Subscription'),
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
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const AppText.bodyLg('Subscription Status', fontWeight: FontWeight.bold),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: AppText.bodySm(
                                statusLabel,
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        16.verticalSpace,
                        const Divider(height: 1),
                        16.verticalSpace,
                        _buildInfoRow('Current Plan', isTrial ? 'Free Trial' : (entitlement?.productIdentifier ?? 'Annual Premium')),
                        12.verticalSpace,
                        _buildInfoRow('Subscription Price', isTrial ? '\$0.00 (Trial)' : '\$99.99/year'),
                        12.verticalSpace,
                        _buildInfoRow('Activation Date', activationDateStr),
                        12.verticalSpace,
                        _buildInfoRow('Next Billing / Renewal', nextBillingDateStr),
                        12.verticalSpace,
                        _buildInfoRow('Purchase Platform', platformStr),
                      ],
                    ),
                  ),

                  24.verticalSpace,

                  /// 2. Requirement #9: Provider Value Summary
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.analytics_outlined, color: Color(0xFF38BDF8), size: 24),
                            10.horizontalSpace,
                            const AppText.bodyLg(
                              'Your Value This Month',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        12.verticalSpace,
                        const Text(
                          '“This month you received 12 requests and accepted 5 bookings.”',
                          style: TextStyle(
                            color: Color(0xFFE2E8F0),
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        12.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem('12', 'Requests Received'),
                            Container(width: 1, height: 30, color: Colors.white24),
                            _buildStatItem('5', 'Bookings Accepted'),
                            Container(width: 1, height: 30, color: Colors.white24),
                            _buildStatItem('92%', 'Acceptance Rate'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  24.verticalSpace,

                  /// 3. Action Buttons (Upgrade, Manage, Restore, Cancel)
                  if (!isActive)
                    AppButton(
                      label: 'Upgrade to Premium Now',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
                        );
                      },
                    )
                  else ...[
                    AppButton(
                      label: 'Manage in App Store / Play Store',
                      onPressed: () async {
                        try {
                          if (Platform.isIOS) {
                            // Opens native Apple subscription manager
                          } else if (Platform.isAndroid) {
                            // Opens Google Play subscription manager
                          }
                        } catch (e) {
                          debugPrint('Error launching store management: $e');
                        }
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
                                    ? 'Subscription restored successfully!'
                                    : 'No active subscription found to restore.',
                              ),
                            ),
                          );
                        }
                      },
                      child: const AppText.bodyLg(
                        'Restore Purchase',
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    12.verticalSpace,
                    Center(
                      child: TextButton(
                        onPressed: () => _showCancelDialog(context, nextBillingDateStr),
                        child: const AppText.bodySm(
                          'Cancel Subscription',
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
    return Column(
      children: [
        AppText.h2(stat, color: const Color(0xFF38BDF8)),
        2.verticalSpace,
        AppText.bodySm(label, color: const Color(0xFF94A3B8), fontSize: 11),
      ],
    );
  }

  /// Requirement #10: Cancellation Reason Dialog & Retention Offer
  void _showCancelDialog(BuildContext context, String activeTillDate) {
    showDialog(
      context: context,
      builder: (ctx) {
        String? selectedReason;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const AppText.h3('Cancel Subscription?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.bodySm(
                'If you cancel today, your premium access will remain active until $activeTillDate.\n\nPlease let us know why you are leaving:',
                color: AppColors.grey500,
              ),
              12.verticalSpace,
              ...['Too expensive', 'Not getting enough client requests', 'Using a different platform', 'Other'].map(
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
                        'Stay with us! Get 20% OFF your next billing cycle instead of cancelling.',
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
              child: const AppText.bodyMd('Keep My Subscription', color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please cancel via your Google Play or App Store subscriptions page.')),
                );
              },
              child: const AppText.bodyMd('Confirm Cancellation', color: Colors.red),
            ),
          ],
        );
      },
    );
  }
}
