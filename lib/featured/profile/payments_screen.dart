import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

// ─── Payments and refunds ─────────────────────────────────────
class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimary,
            size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const AppText.h3('Payment and refunds'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PaymentTile(
                icon: Icons.receipt_long_outlined,
                label: 'My booking',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MyBookingScreen()),
                ),
              ),
              const Divider(height: 1, indent: 52, color: AppColors.divider),
              _PaymentTile(
                icon: Icons.credit_card_outlined,
                label: 'Payments methods',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _PaymentTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            14.horizontalSpace,
            Expanded(child: AppText.bodyMd(label, fontWeight: FontWeight.w500)),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.grey400,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── My booking ───────────────────────────────────────────────
class MyBookingScreen extends StatelessWidget {
  const MyBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimary,
            size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const AppText.h3('My booking'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _BookingCard(
            serviceTitle: 'Elderly Care',
            imageUrl: '',
            paidOn: '12/01/2025',
            serviceDate: '13/01/2025',
            price: '\$10.00 hrs',
            cancelledBy: 'Cancelled by NM Sujon',
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final String serviceTitle;
  final String imageUrl;
  final String paidOn;
  final String serviceDate;
  final String price;
  final String? cancelledBy;

  const _BookingCard({
    required this.serviceTitle,
    required this.imageUrl,
    required this.paidOn,
    required this.serviceDate,
    required this.price,
    this.cancelledBy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 68,
              height: 68,
              color: AppColors.primaryLight,
              child: imageUrl.isEmpty
                  ? const Icon(
                      Icons.elderly_outlined,
                      color: AppColors.primary,
                      size: 32,
                    )
                  : Image.network(imageUrl, fit: BoxFit.cover),
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.labelLg(serviceTitle),
                    AppText.labelMd(price, color: AppColors.primary),
                  ],
                ),
                4.verticalSpace,
                AppText.bodySm(
                  'Paid on $paidOn',
                  color: AppColors.textSecondary,
                ),
                AppText.bodySm(
                  'Service date: $serviceDate',
                  color: AppColors.textSecondary,
                ),
                if (cancelledBy != null) ...[
                  6.verticalSpace,
                  AppText.bodySm(
                    cancelledBy!,
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
