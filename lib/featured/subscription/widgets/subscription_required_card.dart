import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/l10n/app_localizations.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Subscription Required Card & Skeleton Preview
/// Exactly matching Client Mockup 2 ("Service" - Restricted Mode)
/// ─────────────────────────────────────────────────────────────────────────────
class SubscriptionRequiredCard extends StatelessWidget {
  final VoidCallback onStartTrialTapped;
  final VoidCallback? onUpgradeTapped;
  final bool isEligibleForTrial;

  const SubscriptionRequiredCard({
    super.key,
    required this.onStartTrialTapped,
    this.onUpgradeTapped,
    this.isEligibleForTrial = true,
  });

  static const Color _cyanColor = Color(0xFF00B4D8);
  static const Color _lightCyanBg = Color(0xFFE0F7FA);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// 1. Main Restricted White Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              10.verticalSpace,

              // Lock Icon in decorative circle
              _buildDecorativeIcon(
                icon: Icons.lock_outline,
                color: _cyanColor,
              ),

              16.verticalSpace,

              // "ACCESS LOCKED" Pill Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: _lightCyanBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AppText.bodySm(
                  AppLocalizations.of(context)!.accessLocked,
                  color: _cyanColor,
                  fontWeight: FontWeight.bold,
                ),
              ),

              18.verticalSpace,

              // Title
              AppText.h2(
                AppLocalizations.of(context)!.subscriptionRequired,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
              8.verticalSpace,

              // Subtitle
              AppText.bodyMd(
                AppLocalizations.of(context)!.startFreeTrialToReceiveRequests,
                textAlign: TextAlign.center,
                color: const Color(0xFF64748B),
              ),

              24.verticalSpace,

              // Cyan Action Button ("Start Free Trial" or "Upgrade Now")
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
                  onPressed: onStartTrialTapped,
                  child: AppText.bodyLg(
                    isEligibleForTrial ? AppLocalizations.of(context)!.startFreeTrial : AppLocalizations.of(context)!.upgradePremium,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              16.verticalSpace,

              // Bottom subtext
              AppText.bodySm(
                AppLocalizations.of(context)!.youCanStillManageProfile,
                textAlign: TextAlign.center,
                color: const Color(0xFF94A3B8),
              ),

              10.verticalSpace,
            ],
          ),
        ),

        20.verticalSpace,

        /// 2. Faded Skeleton Placeholder Card (below main card)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Opacity(
            opacity: 0.35,
            child: Row(
              children: [
                // Faded Lock Circle
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _lightCyanBg,
                  ),
                  child: const Icon(Icons.lock_outline, color: _cyanColor, size: 22),
                ),
                16.horizontalSpace,
                // Skeleton Lines
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 130,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      8.verticalSpace,
                      Container(
                        width: double.infinity,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
                16.horizontalSpace,
                const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1)),
              ],
            ),
          ),
        ),

        20.verticalSpace,
      ],
    );
  }

  Widget _buildDecorativeIcon({required IconData icon, required Color color}) {
    return Container(
      width: 86,
      height: 86,
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
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.15), width: 1),
              ),
            ),
            Icon(icon, color: color, size: 40),
          ],
        ),
      ),
    );
  }
}
