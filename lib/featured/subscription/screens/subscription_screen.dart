import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/featured/subscription/riverpod/subscription_provider.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

import '../../../core/services/revenuecat_service.dart';
import 'premium_packages_screen.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Premium Subscription & 30-Day Free Trial Screen
/// Exactly matching Client Mockup 1 ("Try IUMI Provider free")
/// ─────────────────────────────────────────────────────────────────────────────
class SubscriptionScreen extends ConsumerStatefulWidget {
  final VoidCallback? onNotNowTapped;
  const SubscriptionScreen({super.key, this.onNotNowTapped});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  static const Color _cyanColor = Color(0xFF00B4D8);
  static const Color _lightCyanBg = Color(0xFFE0F7FA);
  
  bool _isDirectLoading = false;

  @override
  Widget build(BuildContext context) {
    final subState = ref.watch(subscriptionProvider);
    final offerings = subState.offerings?.current;

    // Default fallback price string if live offering isn't loaded yet
    String priceString = '49.99 RON/month';
    if (offerings != null && offerings.monthly != null) {
      priceString = '${offerings.monthly!.storeProduct.priceString}/month';
    } else if (offerings != null && offerings.availablePackages.isNotEmpty) {
      priceString = offerings.availablePackages.first.storeProduct.priceString;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: subState.isLoading
            ? const Center(child: CircularProgressIndicator(color: _cyanColor))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    20.verticalSpace,

                    /// 1. Crown Icon inside Cyan Circle with decorative ring
                    _buildDecorativeIcon(
                      icon: Icons.workspace_premium_outlined,
                      color: _cyanColor,
                    ),

                    20.verticalSpace,

                    /// 2. Main Titles
                    const AppText.h1(
                      'Try IUMI Provider free',
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                    8.verticalSpace,
                    const AppText.bodyMd(
                      'Unlock every provider feature for 30 days.',
                      textAlign: TextAlign.center,
                      color: Color(0xFF64748B),
                    ),

                    16.verticalSpace,

                    /// 3. "30 DAYS FREE" Pill Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: _lightCyanBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const AppText.bodySm(
                        '30 DAYS FREE',
                        color: _cyanColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    24.verticalSpace,

                    /// 4. Main White Card with Features List & Button
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildFeatureRow('Receive customer requests'),
                          const Divider(color: Color(0xFFF1F5F9), height: 24),
                          _buildFeatureRow('Accept or decline bookings'),
                          const Divider(color: Color(0xFFF1F5F9), height: 24),
                          _buildFeatureRow('Contact customers after acceptance'),
                          const Divider(color: Color(0xFFF1F5F9), height: 24),
                          _buildFeatureRow('Manage your schedule'),

                          28.verticalSpace,

                          /// Pricing Title
                          const AppText.h2(
                            'Free for 30 days',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                          4.verticalSpace,
                          AppText.bodySm(
                            'Then $priceString. Cancel anytime.',
                            color: const Color(0xFF94A3B8),
                          ),

                          24.verticalSpace,

                          /// Teal/Cyan Action Button ("Start 30-Day Free Trial")
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _cyanColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: _isDirectLoading 
                                ? null 
                                : () async {
                                    setState(() => _isDirectLoading = true);
                                    try {
                                      final success = await ref.read(subscriptionProvider.notifier).activateFreeTrial();
                                      
                                      if (mounted && success) {
                                        Navigator.of(context).pop();
                                      } else if (mounted) {
                                        final errorMsg = ref.read(subscriptionProvider).errorMessage;
                                        if (errorMsg != null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
                                          );
                                        }
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                                        );
                                      }
                                    } finally {
                                      if (mounted) {
                                        setState(() => _isDirectLoading = false);
                                      }
                                    }
                                  },
                              child: _isDirectLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const AppText.bodyLg(
                                    'Start 30-Day Free Trial',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),

                          14.verticalSpace,

                          /// "Upgrade Premium" underline button
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const PremiumPackagesScreen()),
                              );
                            },
                            child: const Text(
                              'Upgrade Premium',
                              style: TextStyle(
                                color: Color(0xFF00B4D8),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF00B4D8),
                              ),
                            ),
                          ),

                          /// "Not now" Link
                          TextButton(
                            onPressed: widget.onNotNowTapped ?? () => Navigator.of(context).pop(),
                            child: const AppText.bodyMd(
                              'Not now',
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    28.verticalSpace,

                    /// 5. Footer Info Note
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: _cyanColor, width: 1.5),
                          ),
                          child: const Center(
                            child: AppText.bodySm(
                              'i',
                              color: _cyanColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        12.horizontalSpace,
                        const Flexible(
                          child: AppText.bodySm(
                            'No payment today. Works across\niOS, Android and web.',
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),

                    20.verticalSpace,
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _cyanColor, width: 1.5),
          ),
          child: const Icon(Icons.check, color: _cyanColor, size: 14),
        ),
        16.horizontalSpace,
        Expanded(
          child: AppText.bodyMd(
            text,
            color: const Color(0xFF334155),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDecorativeIcon({required IconData icon, required Color color}) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _lightCyanBg.withOpacity(0.6),
        border: Border.all(color: _lightCyanBg, width: 2),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.15), width: 1),
              ),
            ),
            Icon(icon, color: color, size: 48),
          ],
        ),
      ),
    );
  }
}
