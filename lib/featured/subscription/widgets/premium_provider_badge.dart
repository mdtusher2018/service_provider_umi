import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Premium Provider Badge (Requirement #12)
/// ─────────────────────────────────────────────────────────────────────────────
/// Separate from standard identity/document verification badge.
/// Displays a shiny gold/amber crown badge for active subscribers.
/// ─────────────────────────────────────────────────────────────────────────────
class PremiumProviderBadge extends StatelessWidget {
  final bool compact;
  const PremiumProviderBadge({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          ),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF59E0B).withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.workspace_premium, color: Colors.white, size: 12),
            4.horizontalSpace,
            const AppText.bodySm(
              'PRO',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 9,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.workspace_premium, color: Colors.white, size: 16),
          6.horizontalSpace,
          const AppText.bodySm(
            'PREMIUM PROVIDER',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ],
      ),
    );
  }
}
